import os
import streamlit as st
import psycopg
import pandas as pd

from utils.config import VEGETATION_FILTERS, ORIGIN_FILTERS


# -----------------------------------------------------------------------------
# CONNEXION BASE DE DONNÉES
# -----------------------------------------------------------------------------

# Database Connection
def get_conn():
    return psycopg.connect(
        host=os.environ["POSTGRES_HOST"],
        port=os.environ.get("POSTGRES_PORT", "5432"),
        user=os.environ["POSTGRES_USER"],
        password=os.environ["POSTGRES_PASSWORD"],
        dbname=os.environ["POSTGRES_DB"],
        options="-c search_path=incendies,public",
    )


# -----------------------------------------------------------------------------
# CONNEXION BASE DE DONNÉES : historical_tab
# -----------------------------------------------------------------------------

@st.cache_data(ttl=600)
def get_surface_bounds():
    """Retourne les bornes de surface disponibles, en hectares."""
    with get_conn() as conn, conn.cursor() as cur:
        cur.execute(
            """
            SELECT
                COALESCE(MIN(surface_parcourue) / 10000.0, 0),
                COALESCE(MAX(surface_parcourue) / 10000.0, 1)
            FROM incendies.incendie
            """
        )
        return tuple(float(value) for value in cur.fetchone())


@st.cache_data(ttl=600)
def get_incendies(years, months, surface_min, surface_max, vegetation, origins):
    """Charge les incendies géolocalisés selon les filtres de l'interface."""
    conditions = [
        "l.latitude IS NOT NULL",
        "l.longitude IS NOT NULL",
        "i.annee = ANY(%s)",
        "EXTRACT(MONTH FROM i.date_premiere_alerte)::int = ANY(%s)",
        "i.surface_parcourue BETWEEN %s AND %s",
    ]
    params = [
        list(years),
        list(months),
        int(surface_min * 10_000),
        int(surface_max * 10_000),
    ]
    if vegetation:
        conditions.append(
            "(" + " OR ".join(VEGETATION_FILTERS[item] for item in vegetation) + ")"
        )
    if origins:
        conditions.append(
            "(" + " OR ".join(ORIGIN_FILTERS[item] for item in origins) + ")"
        )

    query = f"""
        SELECT
            i.annee,
            EXTRACT(MONTH FROM i.date_premiere_alerte)::int AS mois,
            i.surface_parcourue / 10000.0 AS surface_ha,
            l.latitude::float AS latitude,
            l.longitude::float AS longitude,
            COALESCE(r.nom, 'Région non renseignée') AS region,
            COALESCE(n.nom, 'Origine non renseignée') AS origine
        FROM incendies.incendie i
        JOIN incendies.localisation l ON l.id_localisation = i.localisation
        LEFT JOIN incendies.commune c ON c.code_insee = i.code_insee
        LEFT JOIN incendies.region r ON r.id = c.region
        LEFT JOIN incendies.nature n ON n.id = i.nature
        WHERE {' AND '.join(conditions)}
    """
    with get_conn() as conn, conn.cursor() as cur:
        cur.execute(query, params)
        columns = [column.name for column in cur.description]
        return pd.DataFrame(cur.fetchall(), columns=columns)


@st.cache_data(ttl=3600)
def get_communes():
    """Charge les communes proposées dans l'interface de prédiction."""
    query = """
        SELECT
            c.code_insee,
            c.nom_standard,
            COALESCE(d.nom, 'Département non renseigné') AS departement,
            COALESCE(r.nom, 'Région non renseignée') AS region
        FROM incendies.commune c
        LEFT JOIN incendies.departement d ON d.code = c.departement
        LEFT JOIN incendies.region r ON r.id = c.region
        ORDER BY c.nom_standard, c.code_insee
    """
    with get_conn() as conn, conn.cursor() as cur:
        cur.execute(query)
        columns = [column.name for column in cur.description]
        return pd.DataFrame(cur.fetchall(), columns=columns)


# -----------------------------------------------------------------------------
# CONNEXION BASE DE DONNÉES : forecast_tab
# -----------------------------------------------------------------------------

@st.cache_data(ttl=3600)
def get_liste_communes():
    """Récupère la liste des communes PACA pour le menu déroulant."""
    query = (
        "SELECT code_insee, nom_standard FROM v_commune_paca ORDER BY nom_standard ASC;"
    )
    with get_conn() as conn:
        return pd.read_sql(query, conn)


@st.cache_data(ttl=300)
def fetch_donnees_commune(code_insee: str, date_prediction: str) -> pd.DataFrame:
    """Exécute la requête SQL pour extraire les 18 features brutes via get_conn()."""
    query = """
    WITH params AS (
        SELECT 
            %(code_insee)s::text AS code_insee,
            %(date_prediction)s::date AS date_prediction
    ),
    commune_info AS (
        SELECT 
            c.code_insee,
            c.densite,
            c.superficie_hectare,
            c.altitude_moyenne,
            (c.altitude_maximale - c.altitude_minimale) as amplitude_altitude,
            l2.geom
        FROM v_commune_paca c, params p, localisation l2 
        WHERE c.code_insee = p.code_insee
            AND c.localisation = l2.id_localisation
    ),
    histo_commune AS (
        SELECT 
            COUNT(*) FILTER (WHERE i.date_premiere_alerte >= p.date_prediction - INTERVAL '30 days') AS nb_incendies_30j,
            COUNT(*) FILTER (WHERE i.date_premiere_alerte >= p.date_prediction - INTERVAL '90 days') AS nb_incendies_90j,
            COUNT(*) FILTER (WHERE i.date_premiere_alerte >= p.date_prediction - INTERVAL '365 days') AS nb_incendies_365j,
            COALESCE(SUM(i.surface_parcourue) FILTER (WHERE i.date_premiere_alerte >= p.date_prediction - INTERVAL '5 years'), 0) AS surface_totale_5a
        FROM incendie i
        JOIN params p ON i.code_insee = p.code_insee
        WHERE i.date_premiere_alerte < p.date_prediction
        GROUP BY p.date_prediction
    ),
    buffers_spatiaux AS (
        SELECT 
            COUNT(*) FILTER (WHERE ST_DWithin(l1.geom, ST_Centroid(l2.geom), 10000)) AS buffer_10km,
            COUNT(*) FILTER (WHERE ST_DWithin(l1.geom, ST_Centroid(l2.geom), 20000)) AS buffer_20km,
            COUNT(*) FILTER (WHERE ST_DWithin(l1.geom, ST_Centroid(l2.geom), 50000)) AS buffer_50km
        FROM incendie i
        JOIN localisation l1
            ON i.localisation = l1.id_localisation
        CROSS JOIN v_commune_paca ci
        JOIN localisation l2 
            ON ci.localisation = l2.id_localisation
        CROSS JOIN params p
        WHERE ci.code_insee = p.code_insee
        AND i.date_premiere_alerte >= p.date_prediction - INTERVAL '365 days'
        AND i.date_premiere_alerte < p.date_prediction
    )
    SELECT 
        ci.densite,
        ci.superficie_hectare,
        ci.altitude_moyenne,
        ci.amplitude_altitude,
        EXTRACT(ISODOW FROM p.date_prediction) AS jour_semaine,
        p.date_prediction,
        COALESCE(hc.nb_incendies_30j, 0) AS nb_incendies_30j,
        COALESCE(hc.nb_incendies_90j, 0) AS nb_incendies_90j,
        COALESCE(hc.nb_incendies_365j, 0) AS nb_incendies_365j,
        COALESCE(hc.surface_totale_5a, 0) AS surface_totale_5a,
        COALESCE(bs.buffer_10km, 0) AS buffer_10km,
        COALESCE(bs.buffer_20km, 0) AS buffer_20km,
        COALESCE(bs.buffer_50km, 0) AS buffer_50km
    FROM commune_info ci
    CROSS JOIN params p
    LEFT JOIN histo_commune hc ON TRUE
    LEFT JOIN buffers_spatiaux bs ON TRUE;
    """
    params = {
        "code_insee": code_insee,
        "date_prediction": date_prediction
    }

    with get_conn() as conn:
        return pd.read_sql(query, conn, params=params)