# incendies

## Objectif

prédiction du risque d'incendie

## Importation des données

Il faut commencer par importer les jeux de données ci-dessous :

- [BDIFF](https://bdiff.agriculture.gouv.fr/incendies)
- [Liste des communes de France 2026](https://www.data.gouv.fr/datasets/liste-des-communes-de-france-code-insee-codes-postaux-epci-population-superficie-62-indicateurs?resource_id=c63fd0b1-7987-46f6-b779-8b3ed889090c)

## Chemin de la donnée
data_raw > data_clean > data_processed

---
---
---

## Data prep

### bdiff.ipynb - Liste des incendies

analyse préliminiaire et nettoyage des données de [BDIFF](https://bdiff.agriculture.gouv.fr/incendies)

**input** : DATA_RAW_DIR    (/data/bdiff_data_raw/)<br>
**output** : DATA_CLEAN_DIR (/data/bdiff_data_clean/)

---


### communes.ipynb - Liste des communes (sans polygones)

analyse préliminiaire et nettoyage des données de [Liste des communes de France 2026](https://www.data.gouv.fr/datasets/liste-des-communes-de-france-code-insee-codes-postaux-epci-population-superficie-62-indicateurs)

[téléchargement direct](https://www.data.gouv.fr/datasets/liste-des-communes-de-france-code-insee-codes-postaux-epci-population-superficie-62-indicateurs?resource_id=c63fd0b1-7987-46f6-b779-8b3ed889090c)


**input** : GEO_DATA_RAW_DIR    (/data/geo_data_raw/)<br>
**output** : GEO_DATA_CLEAN_DIR (/data/geo_data_clean/)

---

### Sources inutilisée pour le moment (avec polygones)

[Liste des communes de France 2026 ... au format geojson](https://www.data.gouv.fr/datasets/liste-des-communes-de-france-code-insee-codes-postaux-epci-population-superficie-62-indicateurs?resource_id=d498e08d-8396-48ec-862e-867ac791bed4)

[téléchargement direct](https://www.data.gouv.fr/datasets/liste-des-communes-de-france-code-insee-codes-postaux-epci-population-superficie-62-indicateurs?resource_id=d498e08d-8396-48ec-862e-867ac791bed4)


## Data analyse

- feat_eng.ipynb
- eda.ipynb

...

---
---
---

## Définition de la target
...

## Modelisation

- Train : 2006–2021
- Validation : 2022
- Test final : 2023–2025
- Grid Search basé sur 2006–2021
- Mini train_grid : 361 570 lignes

## Pipeline actuel

Le notebook `feat_eng.ipynb` construit une grille mensuelle commune x mois et
ajoute les variables calendaires agrégées : week-ends, jours fériés, vacances
scolaires et jours non travaillés. Les scores historiques sont calculés de
manière causale, uniquement avec les mois précédents.

Le dataset versionné est exporté dans
`data/data_processed/incendies_features_v2.parquet`, avec son fichier de
métadonnées `incendies_features_v2.metadata.json` contenant notamment le hash
SHA-256.

Le notebook `modeling.ipynb` compare LightGBM et XGBoost par grille
d'hyperparamètres. La recherche utilise les données 2006-2021 pour
l'entraînement et 2022 pour la validation ; 2023-2025 reste le test hors
temps.
Chaque essai et le modèle final sont enregistrés dans MLflow, dans
l'expérience `Prediction_Risque_Incendies`.

## Consulter MLflow

Le projet utilise une base SQLite locale `mlflow.db` pour le tracking. Depuis
la racine du projet, lancer l'interface MLflow avec :

```bash
uv run mlflow ui \
	--backend-store-uri sqlite:///mlflow.db \
	--host 127.0.0.1 \
	--port 5000
```

Puis ouvrir [http://127.0.0.1:5000](http://127.0.0.1:5000) dans le navigateur.

Dans l'expérience `Prediction_Risque_Incendies`, consulter notamment :

- les paramètres des modèles et du dataset utilisé ;
- `pr_auc_validation` et `roc_auc_validation` pour comparer les essais ;
- les runs `grid_LightGBM` et `grid_XGBoost` ;
- le hash du dataset et la taille du mini train utilisé.

Pour arrêter l'interface, utiliser `Ctrl+C` dans le terminal qui l'exécute.

## structure du projets
...
