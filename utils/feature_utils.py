"""Fonctions de construction des variables calendaires du projet incendies."""

import holidays
import pandas as pd
from vacances_scolaires_france import SchoolHolidayDates


def build_monthly_calendar_features(
    start_year: int,
    end_year: int,
) -> pd.DataFrame:
    """Construit les indicateurs calendaires agrégés au niveau année-mois.

    Les indicateurs sont calculés sur tous les jours du calendrier et non sur
    les seuls jours où un incendie a été observé.
    """
    if end_year < start_year:
        raise ValueError("end_year doit être supérieur ou égal à start_year")

    dates = pd.date_range(f"{start_year}-01-01", f"{end_year}-12-31", freq="D")
    calendar = pd.DataFrame({"date": dates})
    french_holidays = holidays.France(years=range(start_year, end_year + 1))
    school_holidays = SchoolHolidayDates()

    calendar["annee"] = calendar["date"].dt.year.astype("int16")
    calendar["mois"] = calendar["date"].dt.month.astype("int8")
    calendar["is_weekend"] = calendar["date"].dt.dayofweek >= 5
    calendar["is_ferie"] = calendar["date"].dt.date.map(
        lambda day: day in french_holidays
    )
    calendar["is_holiday"] = calendar["date"].dt.date.map(
        lambda day: school_holidays.is_holiday(day)
    )
    calendar["is_day_off"] = calendar["is_weekend"] | calendar["is_ferie"]
    calendar["is_holy_or_off"] = calendar["is_day_off"] | calendar["is_holiday"]

    monthly = calendar.groupby(["annee", "mois"], as_index=False).agg(
        nb_jours_dans_mois=("date", "size"),
        nb_jours_weekend=("is_weekend", "sum"),
        nb_jours_feries=("is_ferie", "sum"),
        nb_jours_vacances=("is_holiday", "sum"),
        nb_jours_off=("is_day_off", "sum"),
        nb_jours_holy_or_off=("is_holy_or_off", "sum"),
    )
    monthly["ratio_jours_off"] = monthly["nb_jours_off"] / monthly["nb_jours_dans_mois"]
    monthly["ratio_jours_vacances"] = (
        monthly["nb_jours_vacances"] / monthly["nb_jours_dans_mois"]
    )
    return monthly


def add_monthly_calendar_features(
    dataset: pd.DataFrame,
    start_year: int | None = None,
    end_year: int | None = None,
) -> pd.DataFrame:
    """Ajoute les variables calendaires à une grille contenant année et mois."""
    required_columns = {"annee", "mois"}
    missing_columns = required_columns.difference(dataset.columns)
    if missing_columns:
        raise ValueError(f"Colonnes absentes : {sorted(missing_columns)}")

    start = start_year or int(dataset["annee"].min())
    end = end_year or int(dataset["annee"].max())
    calendar = build_monthly_calendar_features(start, end)
    result = dataset.merge(
        calendar, on=["annee", "mois"], how="left", validate="many_to_one"
    )
    return result
