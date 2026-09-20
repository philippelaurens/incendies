.
├── app
│   ├── mlflow
│   │   └── Dockerfile
│   └── streamlit
│       ├── app_old.py
│       ├── app_phil.py
│       ├── app.py
│       ├── Dockerfile
│       ├── models
│       │   ├── lightgbm.skops
│       │   └── xgb_model.joblib
│       ├── popups.py
│       └── requirements.txt
├── data
│   ├── bdiff_data_clean
│   │   ├── incendies_metropole_corse.parquet
│   │   └── incendies.parquet
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
│   ├── df_dataset.parquet
│   ├── geo_data_clean
│   │   ├── communes_metropole_corse.parquet
│   │   └── communes-metropole.parquet
│   ├── geo_data_raw
│   │   ├── communes-france-2025.csv
│   │   └── communes-france-2026.csv
│   └── spatio_temp
│       └── df_spatio_temp.parquet
├── docker-compose.yml
├── documentation
│   ├── csv2mysql
│   │   ├── incendies.pdf
│   │   ├── incendies.png
│   │   └── Mep.txt
│   └── mysql2postgis
│       └── postgis_creation.txt
├── figures
│   ├── distribution_mensuelle_nb_incendies.png
│   ├── evolution_annuelle_nb_incendies_surfaces_2011-2025.png
│   ├── output.png
│   └── surface_ha—Log.png
├── init
│   ├── 01-schema.sql
│   ├── 02-ddl.sql
│   └── 03-data.sql
├── legacy
│   ├── csv2mysql
│   │   └── incendies-database.ipynb
│   ├── feat_eng.ipynb
│   ├── mlflow.db
│   ├── mlflow.db.backup
│   ├── model_daily_samples.ipynb
│   ├── model_monthly.ipynb
│   └── tables_to_migrate.py
├── notebooks
│   ├── db_daily.ipynb
│   ├── eda.ipynb
│   ├── feat_eng_daily.ipynb
│   ├── mlruns
│   │   └── 1
│   │       └── models
│   │           ├── m-102f2cdd19274b0b81d9b579f1728bb5
│   │           │   └── artifacts
│   │           │       ├── conda.yaml
│   │           │       ├── MLmodel
│   │           │       ├── model.ubj
│   │           │       ├── python_env.yaml
│   │           │       └── requirements.txt
│   │           ├── m-1531186433e646a2878be4b61dc77e6f
│   │           │   └── artifacts
│   │           │       ├── conda.yaml
│   │           │       ├── MLmodel
│   │           │       ├── model.skops
│   │           │       ├── python_env.yaml
│   │           │       └── requirements.txt
│   │           ├── m-4d85e991cefb4abeb93f611a663d2586
│   │           │   └── artifacts
│   │           │       ├── conda.yaml
│   │           │       ├── MLmodel
│   │           │       ├── model.skops
│   │           │       ├── python_env.yaml
│   │           │       └── requirements.txt
│   │           ├── m-53ed01edd9fb43ac98831146fdaf5d80
│   │           │   └── artifacts
│   │           │       ├── conda.yaml
│   │           │       ├── MLmodel
│   │           │       ├── model.ubj
│   │           │       ├── python_env.yaml
│   │           │       └── requirements.txt
│   │           ├── m-6fa81b31116f431ea97d25807333e7f9
│   │           │   └── artifacts
│   │           │       ├── conda.yaml
│   │           │       ├── MLmodel
│   │           │       ├── model.ubj
│   │           │       ├── python_env.yaml
│   │           │       └── requirements.txt
│   │           ├── m-9c5fed9ee7564c73b0daffdf05b51b5e
│   │           │   └── artifacts
│   │           │       ├── conda.yaml
│   │           │       ├── MLmodel
│   │           │       ├── model.ubj
│   │           │       ├── python_env.yaml
│   │           │       └── requirements.txt
│   │           ├── m-b21572804c3442cea47bcc0806c4959a
│   │           │   └── artifacts
│   │           │       ├── conda.yaml
│   │           │       ├── MLmodel
│   │           │       ├── model.skops
│   │           │       ├── python_env.yaml
│   │           │       └── requirements.txt
│   │           ├── m-b3b955667123449a8e80f5fce434ac6e
│   │           │   └── artifacts
│   │           │       ├── conda.yaml
│   │           │       ├── MLmodel
│   │           │       ├── model.skops
│   │           │       ├── python_env.yaml
│   │           │       └── requirements.txt
│   │           └── m-eeeb01b9412149439c3185e3f1efbe67
│   │               └── artifacts
│   │                   ├── conda.yaml
│   │                   ├── MLmodel
│   │                   ├── model.ubj
│   │                   ├── python_env.yaml
│   │                   └── requirements.txt
│   ├── model_daily.ipynb
│   ├── prep_bdiff.ipynb
│   ├── prep_communes.ipynb
│   ├── table_c_j past.ipynb
│   └── table_c_j.ipynb
├── pyproject.toml
├── README.md
├── scripts
│   └── maj.py
├── src
│   ├── __pycache__
│   │   ├── config.cpython-311.pyc
│   │   └── config.cpython-312.pyc
│   ├── config.py
│   ├── create_db_commune.ipynb
│   ├── create_db_incendie.ipynb
│   ├── db.py
│   └── extract_daily_grid.py
├── structure.md
├── utils
│   ├── __pycache__
│   │   ├── analysis_utils.cpython-311.pyc
│   │   └── cleaning_utils.cpython-311.pyc
│   ├── analysis_utils.py
│   ├── cleaning_utils.py
│   ├── dataset_utils.py
│   └── feature_utils.py
└── uv.lock

45 directories, 118 files
