import os
import streamlit as st
import psycopg

import folium
from streamlit_folium import st_folium
from popups import site_popup

def get_conn():
    return psycopg.connect(
        host=os.environ["POSTGRES_HOST"],
        port=os.environ.get("POSTGRES_PORT", "5432"),
        user=os.environ["POSTGRES_USER"],
        password=os.environ["POSTGRES_PASSWORD"],
        dbname=os.environ["POSTGRES_DB"],
        options="-c search_path=incendies,public",
    )

st.title("Terre, Vent, Feu, Eau, Data")

with get_conn() as conn:
    with conn.cursor() as cur:
        cur.execute(
            """
            SELECT c.nom_standard, l.latitude, l.longitude, floor(random() * 10 + 1)::int AS valeur
            FROM incendies.commune c, incendies.localisation l
            WHERE c.localisation=l.id_localisation
            """
        )
        rows = cur.fetchall()

if rows:
    lats = [lat for _, lat, lon, _ in rows]
    lons = [lon for _, lat, lon, _ in rows]
    m = folium.Map(
        location=[sum(lats) / len(lats), sum(lons) / len(lons)],
        zoom_start=6,
    )
else:
    m = folium.Map(location=[46.7, 2.5], zoom_start=6)

for nom, lat, lon, valeur in rows:
    # folium.Marker(
    #     location=[lat, lon],
    #     popup=f"{nom} : {valeur}",
    #     tooltip=nom,
    # ).add_to(m)
    folium.CircleMarker(
        location=[lat, lon],
        radius=max(3, min(8, float(valeur) / 3)),
        color="#c1121f",
        fill=True,
        fill_color="#c1121f",
        fill_opacity=0.8,
        # popup=f"{nom} : {valeur}",
        popup=site_popup(nom, valeur, unite="mm"),
        tooltip=nom,
    ).add_to(m)

st_folium(m, width=800, height=600)
