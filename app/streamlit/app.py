from pathlib import Path
import os
import joblib
import numpy as np
import pandas as pd
import psycopg
import streamlit as st

# -----------------------------------------------------------------------------
# CONNEXION BASE DE DONNÉES
# -----------------------------------------------------------------------------
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
# FONCTIONS DES SCORES D'EXPLICABILITÉ
# -----------------------------------------------------------------------------
def calculer_score_histo(df: pd.DataFrame) -> pd.Series:
    term_30j = np.log1p(df["nb_incendies_30j"])
    term_90j = np.log1p(df["nb_incendies_90j"])
    term_365j = np.log1p(df["nb_incendies_365j"])
    term_surf_5a = np.log1p(df["surface_totale_5a"])
    y_t_365 = df["y_t_365"] if "y_t_365" in df.columns else 0
    return (
        0.25 * term_30j
        + 0.20 * term_90j
        + 0.15 * term_365j
        + 0.25 * term_surf_5a
        + 0.15 * y_t_365
    )


def calculer_score_topo(df: pd.DataFrame) -> pd.Series:
    term_10k = np.log1p(df["buffer_10km"])
    term_20k = np.log1p(df["buffer_20km"])
    term_50k = np.log1p(df["buffer_50km"])
    terme_gravitaire = (
        df["terme_gravitaire_50km"] if "terme_gravitaire_50km" in df.columns else 0
    )
    return (
        0.25 * term_10k
        + 0.25 * term_20k
        + 0.25 * term_50k
        + 0.25 * terme_gravitaire
        + 1e-6
    )

import json
from pathlib import Path

import pandas as pd
import streamlit as st

GEOJSON_PATH = Path(__file__).parent / 'assets' / 'departements.geojson'

DEPTS_PACA = {
    '04': 'Alpes-de-Haute-Provence',
    '05': 'Hautes-Alpes',
    '06': 'Alpes-Maritimes',
    '13': 'Bouches-du-Rhône',
    '83': 'Var',
    '84': 'Vaucluse',
}

@st.cache_data
def load_geojson():
    with open(GEOJSON_PATH, encoding='utf-8') as f:
        data = json.load(f)
    data['features'] = [
        ft for ft in data['features']
        if ft['properties']['code'] in DEPTS_PACA
    ]
    return data

def carte_departements(selected: str | None = None):
    geojson = load_geojson()
    df = pd.DataFrame({
        'code': list(DEPTS_PACA),
        'departement': list(DEPTS_PACA.values()),
    })
    df['selection'] = (df['code'] == selected).astype(int)

    fig = px.choropleth_map(
        df,
        geojson=geojson,
        locations='code',
        featureidkey='properties.code',
        color='selection',
        color_continuous_scale=[(0, '#dbe4ee'), (1, '#e4572e')],
        hover_name='departement',
        map_style='carto-positron',
        center={'lat': 43.95, 'lon': 6.05},
        zoom=6.6,
        opacity=0.65,
    )
    fig.update_traces(marker_line_width=2, marker_line_color='#1f2d3d')
    fig.update_coloraxes(showscale=False)
    fig.update_layout(margin=dict(l=0, r=0, t=0, b=0), height=500)
    return fig

st.plotly_chart(carte_departements(selected='06'), use_container_width=True)

# -----------------------------------------------------------------------------
# CHARGEMENT ET SÉCURISATION DU MODÈLE (CACHÉ)
# -----------------------------------------------------------------------------
@st.cache_resource
def load_artifact():
    # Adaptation du chemin selon l'exécution depuis la racine ou le dossier streamlit
    possible_paths = ['models/xgb_model.joblib', 'xgb_model.joblib']
    model_path = next((p for p in possible_paths if os.path.exists(p)), None)

    if model_path is None:
        st.error("❌ Fichier `xgb_model.joblib` introuvable.")
        st.stop()

    artifact = joblib.load(model_path)
    model = artifact["model"]

    # Sécurisation de l'extraction des features
    if "features" in artifact:
        feature_names = artifact["features"]
    elif hasattr(model, "feature_names_in_"):
        feature_names = list(model.feature_names_in_)
    else:
        st.error("❌ Impossible de déterminer les variables du modèle.")
        st.stop()

    # Sécurisation de l'extraction du seuil (gestion ndarray/float)
    raw_thresh = artifact.get("threshold", 0.3875)
    if isinstance(raw_thresh, (np.ndarray, list)):
        threshold = float(raw_thresh[0])
    else:
        threshold = float(raw_thresh)

    return model, threshold, feature_names


model, threshold, feature_names = load_artifact()

# -----------------------------------------------------------------------------
# COMMUNES
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


# -----------------------------------------------------------------------------
# 2. SELECTION EN BARRE LATÉRALE
# -----------------------------------------------------------------------------
st.sidebar.header("🗺️ Sélection Territoriale")

try:
    df_communes = get_liste_communes()
    options_communes = dict(
        zip(df_communes["code_insee"], df_communes["nom_standard"])
    )

    selected_code_insee = st.sidebar.selectbox(
        "Choisir une commune",
        options=list(options_communes.keys()),
        format_func=lambda x: f"{options_communes[x]} ({x})",
    )
except Exception as e:
    st.sidebar.error(f"Erreur de connexion SQL : {e}")
    st.stop()

selected_date = st.sidebar.date_input("Date d'évaluation", pd.to_datetime("today"))


# -----------------------------------------------------------------------------
# 3. EXTRACTION & PRÉPARATION EN TEMPS RÉEL
# -----------------------------------------------------------------------------
proba = None

if st.sidebar.button("🔍 Prédire à partir de la BDD", type="primary"):
    with st.spinner("Chargement des données SQL..."):
        df_raw = fetch_donnees_commune(
            selected_code_insee, selected_date.strftime("%Y-%m-%d")
        )

    if df_raw.empty:
        st.warning("Aucune donnée trouvée pour cette commune.")
    else:
        # 1. Encodage temporel et trigonométrique
        date_dt = pd.to_datetime(selected_date)
        day_of_year = date_dt.dayofyear
        month = date_dt.month

        df_raw["jour_semaine"] = int(df_raw["jour_semaine"].iloc[0])
        df_raw["sin_jour_annee"] = np.sin(2 * np.pi * day_of_year / 365.25)
        df_raw["cos_jour_annee"] = np.cos(2 * np.pi * day_of_year / 365.25)

        df_raw["saison_ete"] = 1 if month in [6, 7, 8] else 0
        df_raw["saison_automne"] = 1 if month in [9, 10, 11] else 0
        df_raw["saison_hiver"] = 1 if month in [12, 1, 2] else 0
        df_raw["saison_printemps"] = 1 if month in [3, 4, 5] else 0

        # 2. Ajout des scores d'explicabilité
        df_raw["score_histo"] = calculer_score_histo(df_raw)
        df_raw["score_topo"] = calculer_score_topo(df_raw)

        # 3. Inférence avec alignement strict des 20 colonnes
        X_pred = df_raw[feature_names]
        proba = float(model.predict_proba(X_pred)[:, 1][0])
        is_alert = proba >= threshold
else:
    st.subheader("Prêt à sonder le risque ?")

    st.markdown("Choisis une commune de la région Provence-Alpes-Côte d'Azur : " \
        "des calanques de Marseille aux sommets du Mercantour, en passant par les garrigues du Luberon " \
        "et les collines varoises."
    )

    st.markdown("Notre modèle passera en revue l'historique des incendies, le relief, la végétation " \
        "et la saison pour estimer, en quelques secondes, le risque du jour. " \
        "Commence à taper le nom de ta ville, elle est sûrement dans la liste."
    )
# -------------------------------------------------------------------------
# 4. AFFICHAGE DES RÉSULTATS
# -------------------------------------------------------------------------
if(proba is not None):

    st.subheader(
        f"Résultat pour {options_communes[selected_code_insee]} au"
        f" {selected_date.strftime('%d/%m/%Y')}"
    )

    col1, col2 = st.columns(2)
    with col1:
        st.metric(
            label="Score de Risque calculé",
            value=f"{proba:.1%}",
            delta=f"Seuil : {threshold:.1%}",
        )
        if is_alert:
            st.error("🚨 **ALERTE RISQUE ÉLEVÉ** — Vigilance requise.")
        else:
            st.success("✅ **RISQUE FAIBLE / MODÉRÉ**")

    with col2:
        st.metric("Score Historique (Shisto)", f"{df_raw['score_histo'].iloc[0]:.2f}")
        st.metric("Score Topologique (Stopo)", f"{df_raw['score_topo'].iloc[0]:.2f}")