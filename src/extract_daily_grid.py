# src/extract_daily_grid.py
import sys
from pathlib import Path
import pandas as pd

# Ajout de la racine du projet au PATH
sys.path.append(str(Path(__file__).resolve().parent.parent))

from src.config import DATA_PROCESSED_DIR
from src.db import read_query

def extract_and_sample_daily_grid():
    """
    Extrait tous les événements positifs quotidiens et échantillonne
    les jours négatifs sans feu directement dans PostgreSQL (schéma incendies).
    """
    DATA_PROCESSED_DIR.mkdir(parents=True, exist_ok=True)
    output_file = DATA_PROCESSED_DIR / "daily_grid_sampled_raw.parquet"

    query = """
    SET search_path TO incendies, public;

    WITH feux_positifs AS (
        -- 1. Tous les départs de feu réels au pas journalier (Y = 1)
        SELECT
            i.code_insee,
            i.date_premiere_alerte::date AS date_jour,
            1::smallint AS target_occurrence,
            COUNT(i.id_incendie)::smallint AS nb_incendies,
            (SUM(i.surface_parcourue) / 10000.0)::float AS surface_brulee_ha
        FROM incendie i
        WHERE i.date_premiere_alerte >= '2006-01-01'
        GROUP BY i.code_insee, i.date_premiere_alerte::date
    ),
    distinct_commune_annee AS (
        -- Communes ayant brûlé, ventilées par année
        SELECT DISTINCT
            code_insee,
            EXTRACT(year FROM date_jour)::int AS annee
        FROM feux_positifs
    ),
    negatifs_communes_feux AS (
        -- 2. Génération de dates aléatoires sans feu pour les communes à risque
        SELECT
            dca.code_insee,
            (make_date(dca.annee, 1, 1) + (floor(random() * 364))::int * '1 day'::interval)::date AS date_jour,
            0::smallint AS target_occurrence,
            0::smallint AS nb_incendies,
            0.0::float AS surface_brulee_ha
        FROM distinct_commune_annee dca
        CROSS JOIN generate_series(1, 15)
        WHERE random() < 0.15
    ),
    communes_sans_feu AS (
        -- Communes témoins n'ayant jamais brûlé depuis 2006
        SELECT c.code_insee
        FROM commune c
        WHERE NOT EXISTS (SELECT 1 FROM feux_positifs fp WHERE fp.code_insee = c.code_insee)
    ),
    negatifs_temoins AS (
        -- 3. Échantillon de dates pour un sous-ensemble de communes témoins
        SELECT
            csf.code_insee,
            ('2006-01-01'::date + (floor(random() * 7300))::int * '1 day'::interval)::date AS date_jour,
            0::smallint AS target_occurrence,
            0::smallint AS nb_incendies,
            0.0::float AS surface_brulee_ha
        FROM communes_sans_feu csf
        CROSS JOIN generate_series(1, 5)
        WHERE random() < 0.05
    ),
    negatifs_filtres AS (
        -- Exclusion des collisions éventuelles avec les feux réels
        SELECT n.*
        FROM (
            SELECT * FROM negatifs_communes_feux
            UNION ALL
            SELECT * FROM negatifs_temoins
        ) n
        LEFT JOIN feux_positifs fp
            ON n.code_insee = fp.code_insee AND n.date_jour = fp.date_jour
        WHERE fp.code_insee IS NULL
    ),
    grille_unifiee AS (
        -- Dédoublonnage des dates et rassemblement Positifs + Négatifs
        SELECT * FROM feux_positifs
        UNION ALL
        SELECT DISTINCT ON (code_insee, date_jour) * FROM negatifs_filtres
    )
    -- Jointure finale avec commune et localisation (sur id_localisation et grille_densite sur c)
    SELECT
        g.code_insee,
        g.date_jour,
        g.target_occurrence,
        g.nb_incendies,
        g.surface_brulee_ha,
        c.nom_standard,
        c.departement,
        c.region,
        c.population,
        c.superficie_hectare,
        c.densite,
        c.altitude_moyenne,
        c.altitude_minimale,
        c.altitude_maximale,
        c.grille_densite,
        l.latitude,
        l.longitude
    FROM grille_unifiee g
    JOIN commune c ON g.code_insee = c.code_insee
    LEFT JOIN localisation l ON c.localisation = l.id_localisation;
    """

    print("Exécution de la requête d'extraction et d'échantillonnage SQL...")
    df_daily = read_query(query)

    print(f"Extraction terminée : {df_daily.shape[0]:,} lignes récupérées.")
    print("Distribution de la cible (target_occurrence) :")
    print(df_daily['target_occurrence'].value_counts(normalize=False))
    print(df_daily['target_occurrence'].value_counts(normalize=True) * 100)

    # Conversion date et export Parquet
    df_daily['date_jour'] = pd.to_datetime(df_daily['date_jour'])
    df_daily.to_parquet(output_file, index=False)
    print(f"Fichier Parquet brut enregistré avec succès : {output_file}")

if __name__ == "__main__":
    extract_and_sample_daily_grid()
