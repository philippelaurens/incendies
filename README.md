# incendies

## Goal :  Fire risks prediction
Develop an app that returns the fire risk for selected city at a selected time
## Workflow

- [Data import](data-import)
- import des données communes
- dataprep - nettoyage
- [Analysis and feature engineering](analysis-and-feature-engineering)
- [spatio-temporal split]()
- [PostgreSQL database creation, with PostGIS extension](DataBase-creation)
- containerization
	- incendies-app---------------UI
	- incendies-mlflow------------tracking ML
	- postgis/postgis:17-3.5------DB
- [Target definition](target-definition)
- modelization on a data sample
- selected model training on the whole dataset
-

## Data import

First thing's first, import the datasets :

- Fires - [BDIFF](https://bdiff.agriculture.gouv.fr/incendies)
- Cities - [Liste des communes de France 2026](https://www.data.gouv.fr/datasets/liste-des-communes-de-france-code-insee-codes-postaux-epci-population-superficie-62-indicateurs?resource_id=c63fd0b1-7987-46f6-b779-8b3ed889090c)

## Data path

dataflow : `data/*_raw` > `data/*_clean` > `data/*_processed`.

---
---
---

## Data prep

### `prep_bdiff.ipynb` - Fires list

Preliminary analysis and data cleaning of [BDIFF](https://bdiff.agriculture.gouv.fr/incendies)

**input** : DATA_RAW_DIR    (/data/bdiff_data_raw/)<br>
**output** : DATA_CLEAN_DIR (/data/bdiff_data_clean/)

---


### `prep_communes.ipynb` -Cities list (without polygones)

Preliminary analysis and data cleaning of [Liste des communes de France 2026](https://www.data.gouv.fr/datasets/liste-des-communes-de-france-code-insee-codes-postaux-epci-population-superficie-62-indicateurs)

[direct download](https://www.data.gouv.fr/datasets/liste-des-communes-de-france-code-insee-codes-postaux-epci-population-superficie-62-indicateurs?resource_id=c63fd0b1-7987-46f6-b779-8b3ed889090c)


**input** : GEO_DATA_RAW_DIR    (/data/geo_data_raw/)<br>
**output** : GEO_DATA_CLEAN_DIR (/data/geo_data_clean/)

---

### Unused but useful data (with polygones)

[Liste des communes de France 2026 ... au format geojson](https://www.data.gouv.fr/datasets/liste-des-communes-de-france-code-insee-codes-postaux-epci-population-superficie-62-indicateurs?resource_id=d498e08d-8396-48ec-862e-867ac791bed4)

[direct download](https://www.data.gouv.fr/datasets/liste-des-communes-de-france-code-insee-codes-postaux-epci-population-superficie-62-indicateurs?resource_id=d498e08d-8396-48ec-862e-867ac791bed4)


## Analysis and feature engineering

### `eda.ipynb` - Analyse exploratoire

Descriptive analysis of fires data after data cleaning :<br>
- annual evolution
- monthly saisonality
- burnt surfaces distribution
- working versus holiday period comparison
- cartes géographiques et
- cartes d'intensité pondérées par la surface brûlée.

**Input** : `data/bdiff_data_clean/incendies.parquet`,
`data/geo_data_clean/communes_metropole_corse.parquet` et
`data/spatio_temp/df_spatio_temp.parquet`.<br>
**Output** : interactive map, graphs, tables...

### `feat_eng.ipynb` - features engineering and modelization

**Creation of features:**
- spatio-temporal city/day level aggregation grid `city x day`
- spatial cyclic and temporal contagion related features
	

**Postponed feature ideas :**
- gliding temporal windows
- risk scores computed from previous months
- spatial contagion indices within 30 km.


`commune_jour` table update (after import)

**Input** : the cleaned dataset from fires and cities dataprep<br>

**Outputs** :
- monthly :`data/data_processed/incendies_features_v2.parquet` andr `incendies_features_v2.metadata.json`

- **Sortie historique** : `data/spatio_temp/df_spatio_temp.parquet`.


---
---
---

## Target Definition

La cible principale est `target_occurrence` : `1` si au moins un incendie est
observé dans une commune pendant un mois, `0` sinon. Le dataset contient aussi
`nb_incendies`, `surface_brulee_ha` et `target_log_surface` pour les analyses et
extensions de modélisation.

## DataBase creation


## Modelisation

The split dates sont définies dans la cellule 3 de
[notebooks/modeling.ipynb](notebooks/modeling.ipynb) :

- Train : 2006–2022 inclus
- Validation : 2023
- Test final hors temps : 2024 et années suivantes
- Grid Search sur un sous-échantillon stratifié du train, avec ratio maximal de
	10 négatifs pour 1 positif
- Réentraînement final sur l'ensemble du train

## Pipeline actuel

Le notebook `feat_eng.ipynb` construit une grille mensuelle `commune x année x
mois` et ajoute les variables calendaires agrégées : week-ends, jours fériés,
vacances scolaires et jours non travaillés. Les scores historiques et les
variables de risque sont calculés de manière causale, uniquement avec les mois
précédents.

Le dataset versionné est exporté dans
`data/data_processed/incendies_features_v2.parquet`, avec son fichier de
métadonnées `incendies_features_v2.metadata.json` contenant notamment le hash
SHA-256.

Le notebook `modeling.ipynb` compare LightGBM et XGBoost par grille
d'hyperparamètres. La recherche utilise le train sous-échantillonné et la
validation 2023. Le meilleur modèle est ensuite réentraîné sur tout le train et
évalué sur 2023 puis sur le test hors temps.
Chaque essai et le modèle final sont enregistrés dans MLflow, dans
l'expérience `Prediction_Risque_Incendies`.

## MLflow tracking tool consultation

The project uses a containerized Postgres Database `mlflow.db` to track the machine learning process.<br>

TheMLFlow UI is acessible with a internet browser at [http://127.0.0.1:5000](http://127.0.0.1:5000)


Within the experiment `Prediction_Risque_Incendies`, one can access to  :

- models parameters
- dataset
- `pr_auc_validation` and `roc_auc_validation` metrics
- models runs (`grid_LightGBM` and `grid_XGBoost`)
- datasets hash
- train size

Pour arrêter l'interface, utiliser `Ctrl+C` dans le terminal qui l'exécute.

## Project structure

```text
data/            raw, cleaned and processed data
init/            database initialization scripts
notebooks/       Data prep, EDA, feature engineering and modelisation
src/             Configurationand constants
utils/           cleaning, analyse and feature engineering functions
app/streamlit/   Application
```
