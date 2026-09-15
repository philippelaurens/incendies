import os
from pathlib import Path
from dotenv import load_dotenv

# Arborescence des répertoires
ROOT_DIR = Path(__file__).parent.parent

DATA_DIR = ROOT_DIR / "data"

BDIFF_RAW_DIR = DATA_DIR / "bdiff_data_raw"
BDIFF_CLEAN_DIR = DATA_DIR / "bdiff_data_clean"

GEO_DATA_RAW_DIR = DATA_DIR / "geo_data_raw"
GEO_DATA_CLEAN_DIR = DATA_DIR / "geo_data_clean"

SPATIO_TEMP_DATA_DIR = DATA_DIR / "spatio_temp"

DATA_PROCESSED_DIR = DATA_DIR / "data_processed"

FIGURES_DIR = ROOT_DIR / "figures"


# Base de données
load_dotenv(ROOT_DIR / ".env")

# Paramètres PostgreSQL / PostGIS
DB_USER = os.getenv("POSTGRES_USER", "postgres")
DB_PASSWORD = os.getenv("POSTGRES_PASSWORD", "postgres")
DB_HOST = os.getenv("POSTGRES_HOST", "localhost")
DB_PORT = os.getenv("POSTGRES_PORT", "5433")
DB_NAME = os.getenv("POSTGRES_DB", "incendies")

DATABASE_URL = f"postgresql+psycopg2://{DB_USER}:{DB_PASSWORD}@{DB_HOST}:{DB_PORT}/{DB_NAME}"

