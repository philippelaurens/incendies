from pathlib import Path
import joblib
import streamlit as st

MODEL_PATH = Path(__file__).parent / 'models' / 'xgb_model.joblib'

@st.cache_resource
def load_model():
    if not MODEL_PATH.exists():
        st.error(f"Modèle introuvable : {MODEL_PATH}")
        st.stop()
    return joblib.load(MODEL_PATH)

artifact = load_model()
model = artifact['model']
threshold = artifact['threshold']
feature_cols = artifact['feature_cols']

def predict(df: pd.DataFrame) -> pd.DataFrame:
    X = df[feature_cols]                       # mêmes colonnes, même ordre qu'à l'entraînement
    proba = model.predict_proba(X)[:, 1]
    out = df.copy()
    out['proba_feu'] = proba
    out['alerte'] = (proba >= threshold).astype(int)
    return out
