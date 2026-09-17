import os
from pathlib import Path
from dotenv import load_dotenv
import pandas as pd

#  ==================  Arborescence des répertoires ==========================
ROOT_DIR = Path(__file__).parent.parent
DATA_DIR = ROOT_DIR / "data"

BDIFF_RAW_DIR = DATA_DIR / "bdiff_data_raw"
BDIFF_CLEAN_DIR = DATA_DIR / "bdiff_data_clean"

GEO_DATA_RAW_DIR = DATA_DIR / "geo_data_raw"
GEO_DATA_CLEAN_DIR = DATA_DIR / "geo_data_clean"

SPATIO_TEMP_DATA_DIR = DATA_DIR / "spatio_temp"

DATA_PROCESSED_DIR = DATA_DIR / "data_processed"

FIGURES_DIR = ROOT_DIR / "figures"


#  ================== split train/val/test ===================================
SPLIT_TRAIN_END  = pd.Timestamp('2022-12-31')
SPLIT_VAL_START  = pd.Timestamp('2023-01-01')
SPLIT_VAL_YEAR = 2023
SPLIT_TEST_START = pd.Timestamp('2024-01-01')






#  ================== Base de données ========================================
load_dotenv(ROOT_DIR / ".env")

# Paramètres PostgreSQL / PostGIS
HOST = os.getenv("POSTGRES_HOST")
PORT = int(os.getenv("POSTGRES_PORT"))
USER = os.getenv("POSTGRES_USER")
PASSWORD = os.getenv("POSTGRES_PASSWORD")
NAME = os.getenv("POSTGRES_DB", "incendies")
DB_URL = f"postgresql+psycopg2://{USER}:{PASSWORD}@{HOST}:{PORT}/{NAME}"



#  ================== UI ====================================================

# Centrage sur la France métropolitaine
LAT_MIN, LAT_MAX = 41.3, 51.1
LON_MIN, LON_MAX = -5.5, 9.8

MAP_CENTER = [46.5, 2.5]
MAP_ZOOM = 6


# mois
MONTH_NAMES = ["Jan","Fev","Mar","Avr","Mai","Juin","Juil","Aout","Sep","Oct","Nov","Dec"]
AVAILABLE_YEARS = [y for y in range(2006, 2026)]


# Paramétrage de l'affichage des cartes
FIRE_GRADIENT = {
    # Orange clair (faible densité)
    0.2: '#ffaa00',
    # Orange vif (densité moyenne)
    0.5: '#ff5500',
    # Violet / Pourpre (forte densité)
    0.8: '#9900cc',
    # Violet très foncé / Indigo (très forte densité)
    1.0: '#4b0082'
    }

HEATMAP_CONFIG = {
     'radius': 10,
     'blur': 5,
     # Conserve la visibilité des points au zoom
     'min_opacity': 0.85,
     # Maintient l'intensité jusqu'au zoom maximal
     'max_zoom': 18,
     'gradient': FIRE_GRADIENT
    }

TILES_SERVER = {
    "OpenStreetMap": {
        'tiles' : 'OpenStreetMap',
        'attr': None
    },
    'Esri Satellite': {
        'tiles' : 'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}',
        'attr': 'Esri World imagery'
    },
    'CartDB Voyager': {
        'tiles' : 'https://{s}.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}{r}.png',
        'attr': 'CARTO'
    },
    'OpenTopoMap': {
        'tiles' : 'https://{s}.tile.opentopomap.org/{z}/{x}/{y}.png',
        'attr': 'OpenTopoMap'
    }
}

MAP_TITLE_TEMPLATE ="""
<div style="
    position: fixed;
    top: 12px;
    left: 60px;
    z-index: 9999;
    font-family: 'Helvetica Neue', Arial, sans-serif;
    font-size: 16px;
    font-weight: 700;
    color: darkorange;
    background-color: rgba(255, 255, 255, 0.85);
    padding: 8px 14px;
    border-radius: 6px;
    box-shadow: 0 2px 6px rgba(0,0,0,0.2);
    border: 1px solid #cccccc;
">
    {title}
</div>
"""

def add_map_title(map_object, title):
    """Add a title to a folium map object."""
    title_html = MAP_TITLE_TEMPLATE.format(title=title)
    map_object.get_root().html.add_child(folium.Element(title_html))

print(AVAILABLE_YEARS)
