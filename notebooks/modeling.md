# %%
import sys
from pathlib import Path

# adds parent file of the current directory
# to the paths in which Python looks for modules to import
# in the current Python process
sys.path.append(str(Path.cwd().parent))

import lightgbm as lgb
import pandas as pd
import xgboost as xgb
from sklearn.metrics import average_precision_score, roc_auc_score

from src.config import DATA

# %%
# Chargement instantané des 2,3 millions de lignes
df_dataset = pd.read_parquet(DATA / "df_dataset.parquet")

print(f"Dataset chargé avec succès : {df_dataset.shape}")
# vérifie que la taille et les types sont déjà optimisés
print(df_dataset.info())

# %% [markdown]
# * **Train (2011–2021)** : 11 années complètes pour que le modèle apprenne les motifs réguliers de risque.
#
# * **Validation (2022)** : L'année 2022 a été exceptionnelle en termes de sécheresse et de mégafeux en France ; c'est un excellent crash-test pour régler le seuil de décision et les hyperparamètres.
#
# * **Test (2023–2025)** : Évaluation finale "hors du temps" (*out-of-time*) pour simuler les conditions réelles de prédiction future.

# %%

# -----------------------------------------------------------------------------
# 2. DÉFINITION DES FEATURES (X) ET DE LA TARGET (y)
# -----------------------------------------------------------------------------

# Colonnes à exclure des variables explicatives X
cols_to_exclude = [
    "code_insee",
    "annee",
    "mois",
    "target_occurrence",
    "nb_incendies",
    "surface_brulee_ha",
    "target_log_surface",
]

features = [col for col in df_dataset.columns if col not in cols_to_exclude]
target = "target_occurrence"

print(f"Nombre de features sélectionnées ({len(features)}) : {features}")

# -----------------------------------------------------------------------------
# 3. SPLIT TEMPOREL (TRAIN / VALIDATION / TEST)
# -----------------------------------------------------------------------------

# Masques temporels
mask_train = df_dataset["annee"] <= 2021
mask_val = df_dataset["annee"] == 2022
mask_test = df_dataset["annee"] >= 2023

# Création des sous-ensembles
X_train, y_train = (
    df_dataset.loc[mask_train, features],
    df_dataset.loc[mask_train, target],
)
X_val, y_val = df_dataset.loc[mask_val, features], df_dataset.loc[mask_val, target]
X_test, y_test = df_dataset.loc[mask_test, features], df_dataset.loc[mask_test, target]

# -----------------------------------------------------------------------------
# 4. VÉRIFICATION DE LA DISTRIBUTION ET DES VOLUMES
# -----------------------------------------------------------------------------


def print_split_stats(name, X, y):
    total = len(y)
    positives = y.sum()
    rate = (positives / total) * 100
    print(f"--- {name} ---")
    print(f"  Lignes    : {total:,}".replace(",", " "))
    print(f"  Incendies : {positives:,} ({rate:.2f}%)".replace(",", " "))


print_split_stats("TRAIN (2011–2021)", X_train, y_train)
print_split_stats("VAL   (2022)", X_val, y_val)
print_split_stats("TEST  (2023–2025)", X_test, y_test)

# %%
# -----------------------------------------------------------------------------
# 1. PRISE EN COMPTE DU DÉSÉQUILIBRE DE CLASSE
# -----------------------------------------------------------------------------

# Calcul du ratio négatifs / positifs pour équilibrer le poids des erreurs
ratio_pos_weight = (len(y_train) - y_train.sum()) / y_train.sum()
print(
    f"Poids attribué à la classe positive (scale_pos_weight) : {ratio_pos_weight:.2f}"
)

# -----------------------------------------------------------------------------
# 2. INSTANCIATION ET ENTRAÎNEMENT DU MODÈLE
# -----------------------------------------------------------------------------

model_lgb = lgb.LGBMClassifier(
    n_estimators=300,
    learning_rate=0.05,
    max_depth=6,
    num_leaves=31,
    scale_pos_weight=ratio_pos_weight,
    random_state=42,
    n_jobs=-1,
)

# Entraînement avec arrêt précoce (early stopping) sur l'année de validation (2022)
model_lgb.fit(
    X_train,
    y_train,
    eval_set=[(X_val, y_val)],
    callbacks=[lgb.early_stopping(stopping_rounds=30, verbose=False)],
)

# -----------------------------------------------------------------------------
# 3. ÉVALUATION DES PERFORMANCES (ROC-AUC &amp; PR-AUC)
# -----------------------------------------------------------------------------

# Probabilités prédites pour la classe 1 (présence d'incendie)
y_val_pred_proba = model_lgb.predict_proba(X_val)[:, 1]
y_test_pred_proba = model_lgb.predict_proba(X_test)[:, 1]

# Calcul des scores
roc_val = roc_auc_score(y_val, y_val_pred_proba)
pr_val = average_precision_score(y_val, y_val_pred_proba)

roc_test = roc_auc_score(y_test, y_test_pred_proba)
pr_test = average_precision_score(y_test, y_test_pred_proba)

print("n=== PERFORMANCES DU MODÈLE LIGHTGBM BASELINE ===")
print(
    f"Validation (2022)      | ROC-AUC : {roc_val:.4f} | PR-AUC (Average Precision) : {pr_val:.4f}"
)
print(
    f"Test       (2023–2025) | ROC-AUC : {roc_test:.4f} | PR-AUC (Average Precision) : {pr_test:.4f}"
)

# -----------------------------------------------------------------------------
# 4. IMPORTANCE DES FEATURES
# -----------------------------------------------------------------------------

df_importance = pd.DataFrame(
    {"Feature": features, "Importance": model_lgb.feature_importances_}
).sort_values(by="Importance", ascending=False)

plt.figure(figsize=(10, 6))
sns.barplot(data=df_importance.head(12), x="Importance", y="Feature", palette="viridis")
plt.title(
    "Top 12 des variables les plus importantes (LightGBM)",
    fontsize=12,
    fontweight="bold",
)
plt.xlabel("Importance (Gain / Fréquence de split)")
plt.ylabel("")
plt.tight_layout()

# %% [markdown]
# ###  XGBOOST

# %%
# -----------------------------------------------------------------------------
# 1. INSTANCIATION ET ENTRAÎNEMENT XGBOOST
# -----------------------------------------------------------------------------

model_xgb = xgb.XGBClassifier(
    n_estimators=300,
    learning_rate=0.05,
    max_depth=6,
    scale_pos_weight=ratio_pos_weight,
    tree_method="hist",
    random_state=42,
    n_jobs=-1,
    early_stopping_rounds=30,
)

# Entraînement avec évaluation sur l'année de validation (2022)
model_xgb.fit(X_train, y_train, eval_set=[(X_val, y_val)], verbose=False)

# -----------------------------------------------------------------------------
# 2. PRÉDICTIONS ET CALCUL DES SCORES
# -----------------------------------------------------------------------------

y_val_pred_xgb = model_xgb.predict_proba(X_val)[:, 1]
y_test_pred_xgb = model_xgb.predict_proba(X_test)[:, 1]

roc_val_xgb = roc_auc_score(y_val, y_val_pred_xgb)
pr_val_xgb = average_precision_score(y_val, y_val_pred_xgb)

roc_test_xgb = roc_auc_score(y_test, y_test_pred_xgb)
pr_test_xgb = average_precision_score(y_test, y_test_pred_xgb)

# -----------------------------------------------------------------------------
# 3. TABLEAU COMPARATIF DES PERFORMANCES
# -----------------------------------------------------------------------------

df_comparaison = pd.DataFrame(
    {
        "Modèle": ["LightGBM", "XGBoost"],
        "ROC-AUC (Val 2022)": [roc_val, roc_val_xgb],
        "PR-AUC (Val 2022)": [pr_val, pr_val_xgb],
        "ROC-AUC (Test 2023–2025)": [roc_test, roc_test_xgb],
        "PR-AUC (Test 2023–2025)": [pr_test, pr_test_xgb],
    }
)

print("=== TABLEAU COMPARATIF DES MODÈLES BASELINE ===")
print(df_comparaison.to_string(index=False, float_format=lambda x: f"{x:.4f}"))

# -----------------------------------------------------------------------------
# 4. COMPARAISON GRAPHIQUE DES IMPORTANCES DE FEATURES
# -----------------------------------------------------------------------------

df_imp_xgb = pd.DataFrame(
    {"Feature": features, "Importance_XGB": model_xgb.feature_importances_}
).sort_values(by="Importance_XGB", ascending=False)

df_imp_lgb = pd.DataFrame(
    {
        "Feature": features,
        "Importance_LGB": model_lgb.feature_importances_
        / model_lgb.feature_importances_.sum(),
    }
)

df_imp_merge = pd.merge(df_imp_xgb, df_imp_lgb, on="Feature")

plt.figure(figsize=(10, 6))
sns.barplot(
    data=df_imp_merge.head(10), x="Importance_XGB", y="Feature", palette="magma"
)
plt.title(
    "Top 10 des variables les plus importantes (XGBoost)",
    fontsize=12,
    fontweight="bold",
)
plt.xlabel("Importance normalisée")
plt.ylabel("")
plt.tight_layout()

# %%
