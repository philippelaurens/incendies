import sys
from pathlib import Path
import sqlite3
import pandas as pd
from sqlalchemy import create_engine

# Ajout de la racine au PATH pour trouver le module src
ROOT_DIR = Path.cwd()
sys.path.append(str(ROOT_DIR))
if str(ROOT_DIR.parent) not in sys.path:
    sys.path.append(str(ROOT_DIR.parent))

# Import dynamique de tes identifiants depuis .env via ton config.py
from src.config import USER, PASSWORD, HOST, PORT

# 1. Connexion à la base SQLite (source)
# Assure-toi que le chemin pointe bien vers mlflow.db (ajuste si besoin : ROOT_DIR / "mlflow.db")
sqlite_conn = sqlite3.connect("notebooks/mlflow.db")

# 2. Connexion à PostgreSQL (cible : base mlflow) avec tes vrais identifiants
MLFLOW_URI = f"postgresql+psycopg2://{USER}:{PASSWORD}@{HOST}:{PORT}/mlflow"
pg_engine = create_engine(MLFLOW_URI)

# 3. Ordre hiérarchique strict
tables_to_migrate = [
    "workspaces",
    "experiments",
    "runs",
    "logged_models",
    "inputs",
    "tags",
    "params",
    "metrics",
    "latest_metrics",
    "logged_model_params",
    "logged_model_metrics",
    "logged_model_tags"
]

def migrate_mlflow_data():
    with pg_engine.begin() as pg_conn:
        for table in tables_to_migrate:
            print(f"Migration de la table : {table}...")
            df = pd.read_sql(f"SELECT * FROM {table}", sqlite_conn)

            if not df.empty:
                df.to_sql(table, pg_conn, if_exists="append", index=False)
                print(f"  -> {len(df)} lignes insérées.")
            else:
                print("  -> Table vide, ignorée.")

if __name__ == "__main__":
    migrate_mlflow_data()
