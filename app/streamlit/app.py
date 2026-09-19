import os
import math
import numpy as np
import pandas as pd
import folium
import psycopg
import streamlit as st
from folium.plugins import HeatMap
from streamlit_folium import st_folium
from pathlib import Path

from datetime import datetime, UTC

import streamlit as st

from utils.db import get_liste_communes, fetch_donnees_commune, get_surface_bounds, get_incendies, get_communes
from utils.scores import calculer_score_histo, calculer_score_topo
from utils.model import load_artifact

from utils.config import MAP_CENTER, MAP_ZOOM, SEASONS, VEGETATION_FILTERS, ORIGIN_FILTERS, FIRE_GRADIENT, HEATMAP_CONFIG, TILES_SERVER, MAP_TITLE_TEMPLATE, MONTH_NAMES, AVAILABLE_YEARS


# Loading the artifact
model, threshold, feature_names = load_artifact()


# -----------------------------------------------------------------------------
# FONCTIONS : historical_tab
# -----------------------------------------------------------------------------

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


# -----------------------------------------------------------------------------
# FRONT
# -----------------------------------------------------------------------------

st.set_page_config(page_title="Incendies", layout="wide")
st.title("Terre, Vent, Feu, Eau, Data")

historical_tab, forecast_tab = st.tabs(
    ["Cartographie & Analyse Historique", "Prévision & aide à la décision"]
)

with historical_tab:

    try:
        min_surface, max_surface = get_surface_bounds()
    except psycopg.Error as error:
        st.error(f"Impossible de charger les données de la base : {error}")

    menu_col, content_col = st.columns([1, 3])    

    with menu_col:
        st.subheader("Filtres historiques")

        sel_col, _ = st.columns([3, 1]) 
        with sel_col:        
            years = st.multiselect("Années", AVAILABLE_YEARS, default=AVAILABLE_YEARS)
            month_names = st.multiselect("Mois", MONTH_NAMES, default=MONTH_NAMES)
            seasons = st.multiselect("Saisons", list(SEASONS), default=list(SEASONS))

            surface_range = st.slider(
                "Surface brûlée (ha)", min_surface, max_surface, (min_surface, max_surface)
            )

            vegetation = st.multiselect("Type de végétation touché", list(VEGETATION_FILTERS))
            origins = st.multiselect("Origine", list(ORIGIN_FILTERS))

    with content_col:
        st.subheader("Cartographie interactive des incendies")
        st.caption("La heatmap est pondérée par la surface brûlée, sans afficher de marqueurs individuels.")

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

    menu_col, content_col = st.columns([1, 3])

    proba = None

    with menu_col:
        st.subheader("Sélection Territoriale")

        sel_col, _ = st.columns([3, 1]) 
        with sel_col:
            
            try:
                df_communes = get_liste_communes()
                options_communes = dict(zip(df_communes["code_insee"], df_communes["nom_standard"]))
                selected_code_insee = st.selectbox(
                    "Choisir une commune",
                    options=list(options_communes.keys()),
                    format_func=lambda x: f"{options_communes[x]} ({x})",
                )
            except Exception as e:
                st.error(f"Erreur de connexion SQL : {e}")
                st.stop()

            selected_date = st.date_input("Date d'évaluation", pd.to_datetime("today"))     

            if st.button("🔍 Prédire à partir de la BDD", type="primary"):
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

    with content_col:

        if proba is None:

            st.subheader("Prêt à sonder le risque ?")

            st.markdown("Choisis une commune de la région Provence-Alpes-Côte d'Azur : " \
                "des calanques de Marseille aux sommets du Mercantour, en passant par les garrigues du Luberon " \
                "et les collines varoises."
            )

            st.markdown("Notre modèle passera en revue l'historique des incendies, le relief, la végétation " \
                "et la saison pour estimer, en quelques secondes, le risque du jour. " \
                "Commence à taper le nom de ta ville, elle est sûrement dans la liste."
            )

            with st.expander("Variables prises en compte par le futur modèle", expanded=True):
                st.markdown(
                    """
                    - Historique des incendies de la commune et des communes voisines ;
                    - jour et mois de l'année pour représenter la saisonnalité ;
                    - surfaces de végétation par type, selon les définitions BDIFF.
                    """
                )

        else:

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


