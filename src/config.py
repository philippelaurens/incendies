from pathlib import Path

ROOT_DIR = Path(__file__).parent.parent

DATA = ROOT_DIR / "data"

BDIFF_RAW_DIR = DATA / "bdiff_data_raw"
BDIFF_CLEAN_DIR = DATA / "bdiff_data_clean"

GEO_DATA_RAW_DIR = DATA / "geo_data_raw"
GEO_DATA_CLEAN_DIR = DATA / "geo_data_clean"

DATA_PROCESSED_DIR = DATA / "data_processed"

FIGURES_DIR = ROOT_DIR / "figures"

