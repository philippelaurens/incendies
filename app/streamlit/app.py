import math
from datetime import UTC, datetime

import folium
import pandas as pd
import psycopg
import streamlit as st
from folium.plugins import HeatMap
from streamlit_folium import st_folium

from src.config import (
    AVAILABLE_YEARS,
    HEATMAP_CONFIG,
    HOST,
    MAP_CENTER,
    MAP_ZOOM,
    MONTH_NAMES,
    NAME,
    PASSWORD,
    PORT,
    TILES_SERVER,
    USER,
)

SEASONS = {
    "Hiver": (12, 1, 2),
    "Printemps": (3, 4, 5),
    "Été": (6, 7, 8),
    "Automne": (9, 10, 11),
}
VEGETATION_FILTERS = {
    "Forêt": "COALESCE(i.surface_foret, 0) > 0",
    "Maquis / garrigue": "COALESCE(i.surface_maquis_garrigues, 0) > 0",
    "Autres milieux naturels": "COALESCE(i.autres_surfaces_naturelles, 0) > 0",
}
ORIGIN_FILTERS = {
    "Naturelle": "n.nom ILIKE 'Naturelle%'",
    "Accidentelle": "(n.nom ILIKE 'Accidentelle%' OR n.nom ILIKE 'Involontaire%')",
    "Malveillante": "n.nom ILIKE 'Malveillance%'",
}


def get_conn():
    return psycopg.connect(
        host=HOST,
        port=PORT,
        user=USER,
        password=PASSWORD,
        dbname=NAME,
        options="-c search_path=incendies,public",
    )


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


def selected_months(selected_month_names, selected_seasons):
    months = {MONTH_NAMES.index(month) + 1 for month in selected_month_names}
    season_months = {
        month for season in selected_seasons for month in SEASONS[season]
    }
    return sorted(months & season_months)


def add_tile_layers(map_object):
    for name, config in TILES_SERVER.items():
        arguments = {"tiles": config["tiles"], "name": name}
        if config["attr"]:
            arguments["attr"] = config["attr"]
        folium.TileLayer(**arguments).add_to(map_object)


def build_heatmap(incendies):
    map_object = folium.Map(location=MAP_CENTER, zoom_start=MAP_ZOOM, tiles=None)
    add_tile_layers(map_object)
    if not incendies.empty:
        max_log_surface = max(math.log1p(value) for value in incendies["surface_ha"])
        heat_data = [
            [
                row.latitude,
                row.longitude,
                math.log1p(row.surface_ha) / max_log_surface if max_log_surface else 0,
            ]
            for row in incendies.itertuples()
        ]
        HeatMap(heat_data, **HEATMAP_CONFIG).add_to(map_object)
    folium.LayerControl(position="topright", collapsed=True).add_to(map_object)
    return map_object


def display_statistics(incendies):
    st.subheader("Statistiques descriptives")
    col_count, col_surface, col_average = st.columns(3)
    col_count.metric("Incendies", f"{len(incendies):,}".replace(",", " "))
    col_surface.metric("Surface brûlée", f"{incendies.surface_ha.sum():,.0f} ha".replace(",", " "))
    col_average.metric("Surface moyenne", f"{incendies.surface_ha.mean():,.1f} ha".replace(",", " "))

    annual = incendies.groupby("annee", as_index=False).agg(
        incendies=("surface_ha", "size"),
        surface_brulee_ha=("surface_ha", "sum"),
    )
    st.markdown("#### Évolution temporelle")
    st.line_chart(annual, x="annee", y="surface_brulee_ha", y_label="Surface brûlée (ha)")

    left, right = st.columns(2)
    with left:
        st.markdown("#### Causes par région")
        st.bar_chart(pd.crosstab(incendies["region"], incendies["origine"]))
    with right:
        st.markdown("#### Saisonnalité")
        monthly = incendies.groupby("mois", as_index=False).size()
        monthly["mois"] = monthly["mois"].map(lambda month: MONTH_NAMES[month - 1])
        st.bar_chart(monthly, x="mois", y="size", y_label="Nombre d'incendies")

    st.markdown("#### Hotspots géographiques")
    hotspots = (
        incendies.groupby("region", as_index=False)
        .agg(incendies=("surface_ha", "size"), surface_brulee_ha=("surface_ha", "sum"))
        .sort_values("surface_brulee_ha", ascending=False)
        .head(10)
    )
    hotspots["surface_brulee_ha"] = hotspots["surface_brulee_ha"].round(1)
    st.dataframe(hotspots, hide_index=True, use_container_width=True)


st.set_page_config(page_title="Incendies", layout="wide")
st.title("Terre, Vent, Feu, Eau, Data")

historical_tab, forecast_tab = st.tabs(
    ["Cartographie & Analyse Historique", "Prévision & aide à la décision"]
)

with historical_tab:
    st.header("Cartographie interactive des incendies")
    st.caption("La heatmap est pondérée par la surface brûlée, sans afficher de marqueurs individuels.")
    try:
        min_surface, max_surface = get_surface_bounds()
    except psycopg.Error as error:
        st.error(f"Impossible de charger les données de la base : {error}")
    else:
        with st.sidebar:
            st.header("Filtres historiques")
            years = st.multiselect("Années", AVAILABLE_YEARS, default=AVAILABLE_YEARS)
            month_names = st.multiselect("Mois", MONTH_NAMES, default=MONTH_NAMES)
            seasons = st.multiselect("Saisons", list(SEASONS), default=list(SEASONS))
            surface_range = st.slider(
                "Surface brûlée (ha)", min_surface, max_surface, (min_surface, max_surface)
            )
            vegetation = st.multiselect("Type de végétation touché", list(VEGETATION_FILTERS))
            origins = st.multiselect("Origine", list(ORIGIN_FILTERS))

        months = selected_months(month_names, seasons)
        if not years or not months:
            st.info("Sélectionnez au moins une année et un mois correspondant aux saisons choisies.")
        else:
            try:
                incendies = get_incendies(years, months, *surface_range, vegetation, origins)
            except psycopg.Error as error:
                st.error(f"Impossible de charger les incendies : {error}")
            else:
                st.caption(f"{len(incendies):,} incendies correspondent aux filtres.".replace(",", " "))
                st_folium(build_heatmap(incendies), use_container_width=True, height=620)
                if incendies.empty:
                    st.info("Aucun incendie ne correspond aux filtres sélectionnés.")
                else:
                    display_statistics(incendies)

with forecast_tab:
    st.header("Prédiction des risques")
    st.caption(
        "Le score sera fourni par le modèle de clustering géo-temporel en cours de développement."
    )

    with st.expander("Variables prises en compte par le futur modèle", expanded=True):
        st.markdown(
            """
            - Historique des incendies de la commune et des communes voisines ;
            - jour et mois de l'année pour représenter la saisonnalité ;
            - surfaces de végétation par type, selon les définitions BDIFF.
            """
        )

    try:
        communes = get_communes()
    except psycopg.Error as error:
        st.error(f"Impossible de charger les communes : {error}")
    else:
        commune_options = communes.to_dict("records")
        with st.form("prediction_form"):
            selected_commune = st.selectbox(
                "Commune",
                commune_options,
                format_func=lambda commune: (
                    f"{commune['nom_standard']} ({commune['code_insee']}) — "
                    f"{commune['departement']}"
                ),
            )
            target_date = st.date_input(
                "Date à évaluer", value=datetime.now(UTC).date()
            )
            submitted = st.form_submit_button("Évaluer le risque")

        if submitted:
            st.subheader("Score de risque")
            st.info(
                "La requête est prête pour "
                f"{selected_commune['nom_standard']} le {target_date:%d/%m/%Y}. "
                "Le score apparaîtra ici lorsque le module de prédiction sera connecté."
            )
