import numpy as np
import pandas as pd


def calculer_score_histo(df: pd.DataFrame) -> pd.Series:
    term_30j = np.log1p(df["nb_incendies_30j"])
    term_90j = np.log1p(df["nb_incendies_90j"])
    term_365j = np.log1p(df["nb_incendies_365j"])
    term_surf_5a = np.log1p(df["surface_totale_5a"])

    y_t_365 = (df["nb_incendies_365j"] > 0).astype(int)

    return (
        0.25 * term_30j
        + 0.20 * term_90j
        + 0.15 * term_365j
        + 0.25 * term_surf_5a
        + 0.15 * y_t_365
    )


def calculer_score_topo(df: pd.DataFrame) -> pd.Series:
    term_10k = np.log1p(df["buffer_10km"])
    term_20k = np.log1p(df["buffer_20km"])
    term_50k = np.log1p(df["buffer_50km"])

    # Somme de :
    # - la surface_parcourue - surf(j) - des feux de toutes les communes cj dans un rayon de 50 km de la commune c
    # - divisée par
    # - la distance² séparant cj de c
    surface = 0

    return (
        0.50 * term_10k
        + 0.25 * term_20k
        + 0.25 * term_50k
        + 0.00 * surface
    )