from pathlib import Path

ROOT_DIR = Path(__file__).parent.parent

DATA_DIR = ROOT_DIR / "data"

BDIFF_RAW_DIR = DATA_DIR / "bdiff_data_raw"
BDIFF_CLEAN_DIR = DATA_DIR / "bdiff_data_clean"

GEO_DATA_RAW_DIR = DATA_DIR / "geo_data_raw"
GEO_DATA_CLEAN_DIR = DATA_DIR / "geo_data_clean"

SPATIO_TEMP_DATA_DIR = DATA_DIR / "spatio_temp"

DATA_PROCESSED_DIR = DATA_DIR / "data_processed"

FIGURES_DIR = ROOT_DIR / "figures"

