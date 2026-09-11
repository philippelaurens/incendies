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

### eda.ipynb

...

---
---
---

## Définition de la target
...

## Modelisation
...

## structure du projets
...
