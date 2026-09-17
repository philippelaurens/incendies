import pandas as pd

from sqlalchemy import create_engine, text
from src.config import URI

# Moteur SQLAlchemy unique réutilisable
engine = create_engine(URI)

def get_engine():
    """Retourne l'engine SQLAlchemy."""
    return engine

def read_query(sql_query: str, params: dict | None = None) -> pd.DataFrame:
    """Exécute un SELECT et retourne un DataFrame Pandas."""
    with engine.connect() as conn:
        return pd.read_sql(text(sql_query), conn, params=params)

def execute_query(sql_statement: str, params: dict | None = None) -> None:
    """Exécute une commande de modification (INSERT, UPDATE, DELETE, DDL)."""
    with engine.begin() as conn:
        conn.execute(text(sql_statement), params=params)

def save_dataframe(df: pd.DataFrame, table_name: str, if_exists: str = "append") -> None:
    """Écrit directement un DataFrame dans une table PostgreSQL."""
    df.to_sql(table_name, con=engine, if_exists=if_exists, index=False)
