import os
import joblib
import numpy as np
import streamlit as st

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