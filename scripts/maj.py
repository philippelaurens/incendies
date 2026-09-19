"""Met à jour les historiques de la table incendies.commune_jour.

Les compteurs sont calculés uniquement à partir des incendies antérieurs à
chaque date de référence afin d'éviter toute fuite temporelle.
"""

import sys
from pathlib import Path

from sqlalchemy import create_engine, text

project_root = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(project_root))

from src.config import URI

CREATE_VIEW_SQL = text("""
    CREATE OR REPLACE VIEW incendies.v_commune_paca AS
    SELECT *
    FROM incendies.commune
    WHERE region = 17;
""")

HISTORY_UPDATE_SQL = text("""
    WITH calcul_incendies AS (
        SELECT
            c.id_commune,
            COUNT(*) FILTER (
                WHERE i.date_premiere_alerte::date >= :date_jour - INTERVAL '30 days'
            ) AS nb_30j,
            COUNT(*) FILTER (
                WHERE i.date_premiere_alerte::date >= :date_jour - INTERVAL '90 days'
            ) AS nb_90j,
            COUNT(*) AS nb_365j
        FROM incendies.v_commune_paca c
        JOIN incendies.incendie i ON i.code_insee = c.code_insee
            AND i.date_premiere_alerte::date >= :date_jour - INTERVAL '365 days'
            AND i.date_premiere_alerte::date < :date_jour
        GROUP BY c.id_commune
    )
    UPDATE incendies.commune_jour cj
    SET
        nb_incendies_30j = COALESCE(calc.nb_30j, 0),
        nb_incendies_90j = COALESCE(calc.nb_90j, 0),
        nb_incendies_365j = COALESCE(calc.nb_365j, 0)
    FROM incendies.v_commune_paca c
    LEFT JOIN calcul_incendies calc ON calc.id_commune = c.id_commune
    WHERE cj.id_commune = c.id_commune
      AND cj.date_jour = :date_jour;
""")

SURFACE_UPDATE_SQL = text("""
    WITH calcul_surface AS (
        SELECT
            c.id_commune,
            COALESCE(SUM(i.surface_parcourue), 0) AS surface_totale_5a
        FROM incendies.v_commune_paca c
        LEFT JOIN incendies.incendie i
            ON i.code_insee = c.code_insee
            AND i.date_premiere_alerte::date >= :date_jour - INTERVAL '1825 days'
            AND i.date_premiere_alerte::date < :date_jour
        GROUP BY c.id_commune
    )
    UPDATE incendies.commune_jour cj
    SET surface_totale_5a = calc.surface_totale_5a
    FROM calcul_surface calc
    WHERE cj.id_commune = calc.id_commune
      AND cj.date_jour = :date_jour;
""")

BUFFER_UPDATE_SQL = {
    "10": text("""
        WITH calcul_incendies AS (
            SELECT
                c.id_commune,
                COALESCE(COUNT(i.id_incendie), 0) AS feux_du_jour
            FROM incendies.v_commune_paca c
            LEFT JOIN incendies.mv_communes_voisines_10km v
                ON v.ref_commune = c.id_commune
            LEFT JOIN incendies.incendie i
                ON i.code_insee = v.code_insee
                AND i.date_premiere_alerte::date >= :date_jour - INTERVAL '30 days'
                AND i.date_premiere_alerte::date < :date_jour
            GROUP BY c.id_commune
        )
        UPDATE incendies.commune_jour cj
        SET buffer_10km = calc.feux_du_jour
        FROM calcul_incendies calc
        WHERE cj.id_commune = calc.id_commune
          AND cj.date_jour = :date_jour;
    """),
    "20": text("""
        WITH calcul_incendies AS (
            SELECT
                c.id_commune,
                COALESCE(COUNT(i.id_incendie), 0) AS feux_du_jour
            FROM incendies.v_commune_paca c
            LEFT JOIN incendies.mv_communes_voisines_20km v
                ON v.ref_commune = c.id_commune
            LEFT JOIN incendies.incendie i
                ON i.code_insee = v.code_insee
                AND i.date_premiere_alerte::date >= :date_jour - INTERVAL '30 days'
                AND i.date_premiere_alerte::date < :date_jour
            GROUP BY c.id_commune
        )
        UPDATE incendies.commune_jour cj
        SET buffer_20km = calc.feux_du_jour
        FROM calcul_incendies calc
        WHERE cj.id_commune = calc.id_commune
          AND cj.date_jour = :date_jour;
    """),
    "50": text("""
        WITH calcul_incendies AS (
            SELECT
                c.id_commune,
                COALESCE(COUNT(i.id_incendie), 0) AS feux_du_jour
            FROM incendies.v_commune_paca c
            LEFT JOIN incendies.mv_communes_voisines_50km v
                ON v.ref_commune = c.id_commune
            LEFT JOIN incendies.incendie i
                ON i.code_insee = v.code_insee
                AND i.date_premiere_alerte::date >= :date_jour - INTERVAL '30 days'
                AND i.date_premiere_alerte::date < :date_jour
            GROUP BY c.id_commune
        )
        UPDATE incendies.commune_jour cj
        SET buffer_50km = calc.feux_du_jour
        FROM calcul_incendies calc
        WHERE cj.id_commune = calc.id_commune
          AND cj.date_jour = :date_jour;
    """),
}

DATES_SQL = text("""
    SELECT date_jour
    FROM incendies.commune_jour
    GROUP BY date_jour
    ORDER BY date_jour;
""")


def main() -> None:
    """Recalcule toutes les variables historiques pour toutes les dates."""
    engine = create_engine(URI)

    with engine.begin() as connection:
        connection.execute(
            text(
                "CREATE INDEX IF NOT EXISTS idx_incendie_date_insee ON incendies.incendie (date_premiere_alerte, code_insee);"
            )
        )
        connection.execute(CREATE_VIEW_SQL)
        dates = [row.date_jour for row in connection.execute(DATES_SQL)]

        total_dates = len(dates)
        for index, date_jour in enumerate(dates, start=1):
            connection.execute(HISTORY_UPDATE_SQL, {"date_jour": date_jour})
            connection.execute(SURFACE_UPDATE_SQL, {"date_jour": date_jour})
            for buffer_sql in BUFFER_UPDATE_SQL.values():
                connection.execute(buffer_sql, {"date_jour": date_jour})
            if index == 1 or index == total_dates or index % 250 == 0:
                print(f"Dates traitées : {index}/{total_dates}")

    print("Mise à jour terminée.")


if __name__ == "__main__":
    main()
