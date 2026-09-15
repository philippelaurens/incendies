# incendies

## Objectif

prédiction du risque d'incendie

## Importation des données

Il faut commencer par importer les jeux de données ci-dessous :

- [BDIFF](https://bdiff.agriculture.gouv.fr/incendies)
- [Liste des communes de France 2026](https://www.data.gouv.fr/datasets/liste-des-communes-de-france-code-insee-codes-postaux-epci-population-superficie-62-indicateurs?resource_id=c63fd0b1-7987-46f6-b779-8b3ed889090c)

## Chemin des données

Les données suivent le flux : `data/*_raw` > `data/*_clean` > `data/*_processed`.

---
---
---

## Data prep

### `prep_bdiff.ipynb` - Liste des incendies

analyse préliminiaire et nettoyage des données de [BDIFF](https://bdiff.agriculture.gouv.fr/incendies)

**input** : DATA_RAW_DIR    (/data/bdiff_data_raw/)<br>
**output** : DATA_CLEAN_DIR (/data/bdiff_data_clean/)

---


### `prep_communes.ipynb` - Liste des communes (sans polygones)

analyse préliminiaire et nettoyage des données de [Liste des communes de France 2026](https://www.data.gouv.fr/datasets/liste-des-communes-de-france-code-insee-codes-postaux-epci-population-superficie-62-indicateurs)

[téléchargement direct](https://www.data.gouv.fr/datasets/liste-des-communes-de-france-code-insee-codes-postaux-epci-population-superficie-62-indicateurs?resource_id=c63fd0b1-7987-46f6-b779-8b3ed889090c)


**input** : GEO_DATA_RAW_DIR    (/data/geo_data_raw/)<br>
**output** : GEO_DATA_CLEAN_DIR (/data/geo_data_clean/)

---

### Sources inutilisée pour le moment (avec polygones)

[Liste des communes de France 2026 ... au format geojson](https://www.data.gouv.fr/datasets/liste-des-communes-de-france-code-insee-codes-postaux-epci-population-superficie-62-indicateurs?resource_id=d498e08d-8396-48ec-862e-867ac791bed4)

[téléchargement direct](https://www.data.gouv.fr/datasets/liste-des-communes-de-france-code-insee-codes-postaux-epci-population-superficie-62-indicateurs?resource_id=d498e08d-8396-48ec-862e-867ac791bed4)


## Analyse et feature engineering

### `eda.ipynb` - Analyse exploratoire

Analyse descriptive des incendies après nettoyage : évolution annuelle,
saisonnalité mensuelle, distribution des surfaces brûlées, comparaison des
périodes travaillées et non travaillées, ainsi que cartes géographiques et
cartes d'intensité pondérées par la surface brûlée.

**Input** : `data/bdiff_data_clean/incendies.parquet`,
`data/geo_data_clean/communes_metropole_corse.parquet` et
`data/spatio_temp/df_spatio_temp.parquet`.<br>
**Output** : tableaux d'analyse, graphiques et cartes interactives.

### `feat_eng.ipynb` - Construction des variables de modélisation

Construction d'une grille complète `commune x année x mois`, puis création des
variables cibles et explicatives :

- variables temporelles et cycliques ;
- variables calendaires agrégées au niveau commune-mois ;
- historiques communaux décalés et fenêtres glissantes ;
- scores de risque calculés causalement à partir des mois précédents ;
- indice de contagion spatiale dans un rayon de 30 km à `M-1`.

**Input** : les deux datasets nettoyés issus de la préparation BDIFF et communes.<br>
**Output principal** : `data/data_processed/incendies_features_v2.parquet` et son
fichier `incendies_features_v2.metadata.json`.<br>
**Sortie historique** : `data/spatio_temp/df_spatio_temp.parquet`.


---
---
---

## Définition de la cible

La cible principale est `target_occurrence` : `1` si au moins un incendie est
observé dans une commune pendant un mois, `0` sinon. Le dataset contient aussi
`nb_incendies`, `surface_brulee_ha` et `target_log_surface` pour les analyses et
extensions de modélisation.

## Modelisation

Les dates de split sont définies dans la cellule 3 de
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

## Structure du projet

```text
data/                 Données brutes, nettoyées et transformées
notebooks/            Préparation, EDA, feature engineering et modélisation
src/                  Configuration et accès aux données
utils/                Fonctions de nettoyage, analyse et feature engineering
app/streamlit/        Application de visualisation
init/                 Scripts d'initialisation de la base de données
```
