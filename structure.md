.
├── README.md
├── __pycache__
│   └── config.cpython-311.pyc
├── app
│   ├── mlflow
│   │   └── Dockerfile
│   └── streamlit
│       ├── Dockerfile
│       ├── __pycache__
│       │   └── app.cpython-311.pyc
│       ├── app.py
│       ├── popups.py
│       └── requirements.txt
├── consignes
│   └── a_faire.md
├── data
│   ├── bdiff_data_clean
│   │   └── incendies.parquet
│   ├── bdiff_data_processed
│   ├── bdiff_data_raw
│   │   ├── Incendies1971.csv
│   │   ├── Incendies1976.csv
│   │   ├── Incendies1981.csv
│   │   ├── Incendies1986.csv
│   │   ├── Incendies1991.csv
│   │   ├── Incendies1996.csv
│   │   ├── Incendies2001.csv
│   │   ├── Incendies2006.csv
│   │   ├── Incendies2011.csv
│   │   ├── Incendies2016.csv
│   │   └── Incendies2021.csv
│   ├── data_processed
│   │   ├── incendies_features_v2.metadata.json
│   │   └── incendies_features_v2.parquet
│   ├── df_dataset.parquet
│   ├── geo_data_clean
│   │   ├── communes.parquet
│   │   └── communes_metropole_corse.parquet
│   ├── geo_data_processed
│   ├── geo_data_raw
│   │   ├── communes-france-2025.csv
│   │   └── communes-france-avec-polygon-2026.geojson
│   └── spatio_temp
│       └── df_spatio_temp.parquet
├── docker-compose.yml
├── documentation
│   ├── csv2mysql
│   │   ├── Mep.txt
│   │   ├── incendies.pdf
│   │   └── incendies.png
│   └── mysql2postgis
│       └── postgis_creation.txt
├── figures
│   ├── carte_incendies.html
│   ├── distribution_mensuelle_nb_incendies.png
│   ├── evolution_annuelle_nb_incendies_surfaces_2011-2025.png
│   ├── output.png
│   └── surface_ha—Log.png
├── init
│   ├── 01-schema.sql
│   ├── 02-ddl.sql
│   └── 03-data.sql
├── mlflow.db
├── notebooks
│   ├── csv2mysql
│   │   └── incendies-database.ipynb
│   ├── db_daily.ipynb
│   ├── eda.ipynb
│   ├── feat_eng.ipynb
│   ├── feat_eng_daily.ipynb
│   ├── mlflow.db
│   ├── mlflow.db.backup
│   ├── mlruns
│   │   └── 1
│   │       └── models
│   │           └── m-4f58fe63d8da4385bfc301d0d9b648e0
│   │               └── artifacts
│   │                   ├── MLmodel
│   │                   ├── conda.yaml
│   │                   ├── model.skops
│   │                   ├── python_env.yaml
│   │                   └── requirements.txt
│   ├── model_daily.ipynb
│   ├── model_daily_samples.ipynb
│   ├── model_monthly.ipynb
│   ├── prep_bdiff.ipynb
│   ├── prep_communes.ipynb
│   ├── table_c_j.ipynb
│   └── tables_to_migrate.py
├── pyproject.toml
├── scripts
├── src
│   ├── __pycache__
│   │   ├── config.cpython-311.pyc
│   │   └── db.cpython-311.pyc
│   ├── config.py
│   ├── create_db_commune.ipynb
│   ├── create_db_incendie.ipynb
│   ├── db.py
│   └── extract_daily_grid.py
├── structure.md
├── temp
│   ├── brouillon.py
│   └── consulte_la_bdd.py
├── utils
│   ├── __pycache__
│   │   ├── analysis_utils.cpython-311.pyc
│   │   ├── cleaning_utils.cpython-311.pyc
│   │   ├── dataset_utils.cpython-311.pyc
│   │   └── feature_utils.cpython-311.pyc
│   ├── analysis_utils.py
│   ├── cleaning_utils.py
│   ├── dataset_utils.py
│   └── feature_utils.py
└── uv.lock

34 directories, 82 files
