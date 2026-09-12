import pandas as pd
import numpy as np
import math
import matplotlib.pyplot as plt
import seaborn as sns
from typing import Dict, Tuple, Optional, Any, List, Iterable
from sklearn.model_selection import GridSearchCV, RandomizedSearchCV, cross_val_score
from sklearn.metrics import mean_absolute_error, mean_squared_error, r2_score


def select_existing_features(features: Iterable[str], columns: Iterable[str]) -> List[str]:
    """
    Filtre une liste de features pour ne conserver que celles présentes.

    Parameters
    ----------
    features : iterable
        Liste des colonnes souhaitées.
    columns : iterable
        Colonnes effectivement présentes (ex: X.columns).

    Returns
    -------
    list
        Liste filtrée dans l'ordre d'origine.
    """
    col_set = set(columns)
    return [c for c in features if c in col_set]


def top_correlated_features(
    X: pd.DataFrame,
    y: pd.Series,
    n: int = 6,
    numeric_only: bool = True,
) -> Tuple[pd.Series, List[str]]:
    """
    Calcule la corrélation des variables numériques avec une target.

    Parameters
    ----------
    X : pd.DataFrame
        Features d'entrée.
    y : pd.Series
        Target associée à X.
    n : int
        Nombre de variables les plus corrélées à retourner.
    numeric_only : bool
        Applique la corrélation uniquement aux colonnes numériques.

    Returns
    -------
    corr_target : pd.Series
        Corrélation de chaque variable numérique avec la target.
    top_cols : list
        Liste des n variables avec corrélation absolue maximale.
    """
    num_cols = X.select_dtypes(include=["number"]).columns
    df_corr = X[num_cols].copy()
    df_corr["target"] = y
    corr_target = df_corr.corr(numeric_only=numeric_only)["target"].drop("target")
    top_cols = (
        corr_target.abs().sort_values(ascending=False).head(n).index.tolist()
    )
    return corr_target, top_cols


def plot_numeric_histograms(
    X: pd.DataFrame,
    bins: int = 40,
    n_cols: int = 3,
    figsize_per_col: Tuple[int, int] = (5, 3),
) -> None:
    """
    Affiche les histogrammes de toutes les colonnes numériques.

    Parameters
    ----------
    X : pd.DataFrame
        Données d'entrée.
    bins : int
        Nombre de bins pour les histogrammes.
    n_cols : int
        Nombre de graphes par ligne.
    figsize_per_col : tuple
        Taille d'un subplot (largeur, hauteur).
    """
    num_cols = X.select_dtypes(include=["number"]).columns
    n_plots = len(num_cols)
    if n_plots == 0:
        return
    n_rows = math.ceil(n_plots / n_cols)
    plt.figure(figsize=(n_cols * figsize_per_col[0], n_rows * figsize_per_col[1]))
    for i, col in enumerate(num_cols, 1):
        plt.subplot(n_rows, n_cols, i)
        sns.histplot(X[col].dropna(), bins=bins)
        plt.xlabel("")   # masque axe X
        plt.ylabel("")   # masque axe Y
        plt.grid(True, alpha=0.3)
        plt.title(col)
    plt.tight_layout()
    plt.show()

def plot_qualitative(
    X: pd.DataFrame,
    top_n: int = 20,
    n_cols: int = 2,
    figsize_per_col: Tuple[int, int] = (6, 4),
    figsize: Optional[Tuple[int, int]] = None,
    height_per_row: int = 4,
) -> None:
    """
    Affiche des barplots pour les colonnes qualitatives.

    Parameters
    ----------
    X : pd.DataFrame
        Données d'entrée.
    top_n : int
        Nombre de modalités affichées par colonne.
    n_cols : int
        Nombre de graphes par ligne.
    figsize_per_col : tuple
        Taille d'un subplot (largeur, hauteur).
    """
    cat_cols = X.select_dtypes(include=["object", "category", "string", "bool"]).columns
    n_plots = len(cat_cols)
    if n_plots == 0:
        return

    n_rows = math.ceil(n_plots / n_cols)
    if figsize is None:
        figsize = (n_cols * figsize_per_col[0], n_rows * height_per_row)

    plt.figure(figsize=figsize)


    for i, col in enumerate(cat_cols, 1):
        plt.subplot(n_rows, n_cols, i)
        vc = X[col].astype("string").value_counts(dropna=False).head(top_n)
        sns.barplot(x=vc.values, y=vc.index, color="#439cc8")
        plt.xlabel("")
        plt.ylabel("")
        plt.title(col)
        plt.grid(True, axis="x", alpha=0.3)

    plt.tight_layout()
    plt.show()


def plot_missing_bar(
    X: pd.DataFrame,
    top_n: Optional[int] = None,
    figsize: Tuple[int, int] = (8, 4),
) -> None:
    """
    Affiche un bar plot du % de valeurs manquantes par colonne.

    Parameters
    ----------
    X : pd.DataFrame
        Données d'entrée.
    top_n : int | None
        Affiche uniquement les top_n colonnes les plus manquantes.
    figsize : tuple
        Taille de la figure.
    """
    missing_pct = (X.isna().mean() * 100).sort_values(ascending=False)
    if top_n is not None:
        missing_pct = missing_pct.head(top_n)

    plt.figure(figsize=figsize)
    sns.barplot(x=missing_pct.values, y=missing_pct.index, color="#439cc8")
    plt.xlabel("% de valeurs manquantes")
    plt.ylabel("Colonnes")
    plt.title("Taux de valeurs manquantes par colonne")
    plt.grid(True, alpha=0.3)
    plt.tight_layout()
    plt.show()


def plot_scatter_vs_target(
    X: pd.DataFrame,
    y: pd.Series,
    cols: Iterable[str],
    transform_y: Optional[str] = None,
    figsize: Tuple[int, int] = (15, 10),
    alpha: float = 0.2,
    s: int = 10,
) -> None:
    """
    Trace des scatter plots de variables vs la target.

    Parameters
    ----------
    X : pd.DataFrame
        Features d'entrée.
    y : pd.Series
        Target associée à X.
    cols : iterable
        Colonnes à visualiser.
    transform_y : {"log1p", None}
        Applique $\log(1+y)$ à la target si "log1p".
    figsize : tuple
        Taille de la figure.
    alpha : float
        Transparence des points.
    s : int
        Taille des points.
    """
    if transform_y == "log1p":
        y_vals = np.log1p(y.values)
    else:
        y_vals = y.values

    cols = list(cols)
    if not cols:
        return

    n_rows = math.ceil(len(cols) / 3)
    plt.figure(figsize=figsize)
    for i, col in enumerate(cols, 1):
        plt.subplot(n_rows, 3, i)
        mask = X[col].notna()
        sns.scatterplot(x=X.loc[mask, col], y=y_vals[mask], s=s, alpha=alpha)
        plt.title(f"{transform_y + ' ' if transform_y else ''}target vs {col}")
    plt.tight_layout()
    plt.show()


def plot_corr_heatmap(
    df: pd.DataFrame,
    method: str = "pearson",
    title: str = "Heatmap des corrélations",
    figsize: Tuple[int, int] = (12, 10),
    annot: bool = True,
    fmt: str = ".2f",
    vmin: float = -1,
    vmax: float = 1,
    cmap: str = "coolwarm",
) -> None:
    """
    Affiche une heatmap de corrélation pour les colonnes numériques.

    Parameters
    ----------
    df : pd.DataFrame
        Données d'entrée.
    title : str
        Titre du graphique.
    figsize : tuple
        Taille de la figure.
    annot : bool
        Afficher les valeurs numériques dans la heatmap.
    fmt : str
        Format des annotations.
    vmin, vmax : float
        Bornes de l'échelle de couleur.
    cmap : str
        Palette de couleurs.
    """
    corr = df.select_dtypes(include=[np.number]).corr(method=method)
    plt.figure(figsize=figsize)
    sns.heatmap(corr, annot=annot, fmt=fmt, vmin=vmin, vmax=vmax, cmap=cmap)
    plt.title(title)
    plt.tight_layout()
    plt.show()


def export_train_test_feather(
    X_train: pd.DataFrame,
    X_test: pd.DataFrame,
    y_train: pd.Series,
    y_test: pd.Series,
    output_dir: str = "data_model",
    target_name: str = "log_buy_price",
    transform_y: Optional[str] = None,
    drop_cols: Optional[List[str]] = None,
) -> None:
    """
    Exporte X/y train/test au format Feather.

    Parameters
    ----------
    X_train, X_test : pd.DataFrame
        Jeux de features.
    y_train, y_test : pd.Series
        Targets associées.
    output_dir : str
        Dossier de sortie.
    target_name : str
        Nom de la target exportée.
    transform_y : {"log1p", None}
        Applique $\log(1+y)$ si "log1p".
    drop_cols : list | None
        Colonnes à retirer de X_train avant export.
    """
    import os

    os.makedirs(output_dir, exist_ok=True)

    X_train_final = X_train.drop(columns=drop_cols or [], errors="ignore").reset_index(drop=True)
    X_test_final = X_test.reset_index(drop=True)

    if transform_y == "log1p":
        y_train_final = pd.Series(np.log1p(y_train.values), name=target_name).reset_index(drop=True)
        y_test_final = pd.Series(np.log1p(y_test.values), name=target_name).reset_index(drop=True)
    else:
        y_train_final = pd.Series(y_train.values, name=target_name).reset_index(drop=True)
        y_test_final = pd.Series(y_test.values, name=target_name).reset_index(drop=True)

    X_train_final.to_feather(f"{output_dir}/X_train.feather")
    X_test_final.to_feather(f"{output_dir}/X_test.feather")
    y_train_final.to_frame().to_feather(f"{output_dir}/y_train.feather")
    y_test_final.to_frame().to_feather(f"{output_dir}/y_test.feather")


def _drop_high_na(
    X: pd.DataFrame,
    threshold: float,
    stats: Dict[str, Any],
) -> pd.DataFrame:
    """Supprime les colonnes dont le taux de NA dépasse un seuil."""
    if "cols_to_drop" not in stats:
        cols_to_drop = X.columns[X.isna().mean() > threshold]
        stats["cols_to_drop"] = list(cols_to_drop)
    return X.drop(columns=stats.get("cols_to_drop", []), errors="ignore")


def _fill_bin_with_mode(
    X: pd.DataFrame,
    cols: List[str],
    stats: Dict[str, Any],
) -> pd.DataFrame:
    """Impute les colonnes binaires avec le mode (appris sur train)."""
    cols = [c for c in cols if c in X.columns]
    if "bin_modes" not in stats:
        stats["bin_modes"] = {}
        for c in cols:
            if len(X[c].mode()) > 0:
                stats["bin_modes"][c] = X[c].mode()[0]
    for c in cols:
        if c in stats.get("bin_modes", {}):
            X[c] = X[c].fillna(stats["bin_modes"][c])
    return X


def _fill_numeric_with_median(
    X: pd.DataFrame,
    cols: List[str],
    stats: Dict[str, Any],
    key: str,
) -> pd.DataFrame:
    """Impute les colonnes numériques avec leur médiane (apprise sur train)."""
    if key not in stats:
        stats[key] = {}
        for c in cols:
            if c in X.columns:
                X[c] = pd.to_numeric(X[c], errors="coerce")
                stats[key][c] = X[c].median()
    for c in cols:
        if c in X.columns:
            X[c] = pd.to_numeric(X[c], errors="coerce")
            if c in stats.get(key, {}):
                X[c] = X[c].fillna(stats[key][c])
    return X


def _replace_and_median(
    X: pd.DataFrame,
    col: str,
    stats: Dict[str, Any],
    replace_map: Optional[Dict[Any, Any]] = None,
    invalid_below: Optional[float] = None,
    key: Optional[str] = None,
) -> pd.DataFrame:
    """Nettoie une colonne (replace/invalid) puis impute par médiane."""
    if col not in X.columns:
        return X
    if replace_map:
        X[col] = X[col].replace(replace_map)
    X[col] = pd.to_numeric(X[col], errors="coerce")
    if invalid_below is not None:
        X.loc[X[col] < invalid_below, col] = np.nan
    median_key = key or f"{col}_median"
    if median_key not in stats:
        stats[median_key] = X[col].median()
    X[col] = X[col].fillna(stats[median_key])
    return X


def clean_data(
    X: pd.DataFrame,
    config: Dict[str, Any],
    stats: Optional[Dict[str, Any]] = None,
) -> Tuple[pd.DataFrame, Dict[str, Any]]:
    """
    Cleaning configurable et réutilisable.

    Parameters
    ----------
    X : pd.DataFrame
        Données d'entrée.
    config : dict
        Paramètres de nettoyage (exemple ci-dessous).
    stats : dict | None
        Statistiques apprises sur le train pour répliquer sur le test.

    Config attendu (exemple) :
    {
        "drop_na_threshold": 0.40,
        "binary_cols": [...],
        "floor_col": "floor",
        "floor_replace": {"bajo": 0},
        "numeric_median_cols": ["sq_mt_built", "n_bathrooms"],
        "rent_col": "rent_price",
        "rent_invalid_below": 0,
    }

    Returns
    -------
    X_clean : pd.DataFrame
        Données nettoyées.
    stats : dict
        Statistiques apprises pour réutilisation sur d'autres jeux.
    """
    X = X.copy()
    stats = {} if stats is None else dict(stats)

    threshold = config.get("drop_na_threshold")
    if threshold is not None:
        X = _drop_high_na(X, threshold=threshold, stats=stats)

    bin_cols = config.get("binary_cols", [])
    if bin_cols:
        X = _fill_bin_with_mode(X, cols=bin_cols, stats=stats)

    floor_col = config.get("floor_col")
    if floor_col:
        X = _replace_and_median(
            X,
            col=floor_col,
            stats=stats,
            replace_map=config.get("floor_replace"),
            key=config.get("floor_median_key", "floor_median"),
        )

    num_cols = config.get("numeric_median_cols", [])
    if num_cols:
        X = _fill_numeric_with_median(
            X,
            cols=num_cols,
            stats=stats,
            key=config.get("numeric_median_key", "num_medians"),
        )

    rent_col = config.get("rent_col")
    if rent_col:
        X = _replace_and_median(
            X,
            col=rent_col,
            stats=stats,
            invalid_below=config.get("rent_invalid_below"),
            key=config.get("rent_median_key", "rent_median"),
        )

    return X, stats


def evaluate_model(
        algo,
        param_grid,
        X_train,
        y_train,
        X_test,
        y_test,
        search_type='grid',
        scoring='r2',
        cv=5):
    """
    Entraine un modele avec GridSearchCV ou RandomizedSearchCV et affiche les résultats
    prédit les valeurs de test et calcule les métriques

    :parma algo: instance de l'algorithme à utiliser
    :param param_grid: dictionnaire des paramètres à testerNone si vide)
    :param X_train: features d'entrainement
    :param y_train: target d'entrainement
    :param X_test: features de test
    :param y_test: target de test
    :param search_type: type de recherche, 'grid' pour GridSearchCV, 'random' pour RandomizedSearchCV
    :param scoring: métrique d'évaluation
    :param cv: nombre de folds pour la validation croisée
    :return: dict des meilleurs paramètres, R2, RMSE, MAE, les résultats et le modele
    """
    # Si la param grid est vide, entrainement sans optimisation
    if param_grid is None:
        algo.fit(X_train, y_train)
        best_model = algo
        best_params = algo.get_params()
        cv_results = cross_val_score(best_model,
                                      X_train, y_train,
                                      cv=cv,
                                      scoring=scoring)
    else:
        # Choisir le type de recherche d'hyperparamètres
        if search_type == 'grid':
            search = GridSearchCV(algo,
                                  param_grid,
                                  cv=cv,
                                  scoring=scoring)
        elif search_type == 'random':
            search = RandomizedSearchCV(algo,
                                        param_grid,
                                        cv=cv,
                                        scoring=scoring)
        else:
            raise ValueError("search_type doit être 'grid' ou 'random'")

        # Entrainement et optimisation
        search.fit(X_train, y_train)
        best_model = search.best_estimator_
        best_params = search.best_params_
        cv_results = search.cv_results_

        # Prédiction avec le meilleur modele
        y_pred = best_model.predict(X_test)

        # Calcul des métriques
        r2 = r2_score(y_test, y_pred)
        rmse = mean_squared_error(y_test, y_pred) ** 0.5
        mae = mean_absolute_error(y_test, y_pred)

        # Affichage des résultats
        print(f"Modèle : {algo.__class__.__name__}")
        print(f"Meilleurs paramètres : {best_params}")
        print(f"R2 (sur le test): {r2:.4f}")
        print(f"RMSE : {rmse:.4f}")
        print(f"MAE : {mae:.4f}")

        return {
            "best_params": best_params,
            "r2": r2,
            "rmse": rmse,
            "mae": mae,
            "cv_results": cv_results,
            "best_model": best_model
        }


def eval_model_apart(
        algo,
        param_grid,
        X_train,
        y_train,
        X_test,
        y_test,
        search_type='grid',
        scoring='r2',
        cv=5):
    """
    Variante de evaluate_model qui corrige la transformation log1p
    et affiche RMSE/MAE en euros.
    Compatible avec matrices sparse (scipy >= 1.13).
    """
    from scipy.sparse import issparse

    # Si la param grid est vide, entrainement sans optimisation
    if param_grid is None:
        algo.fit(X_train, y_train)
        best_model = algo
        best_params = algo.get_params()
        cv_results = cross_val_score(best_model,
                                      X_train, y_train,
                                      cv=cv,
                                      scoring=scoring)
        # Prédiction avec le meilleur modele
        y_pred = best_model.predict(X_test)
    else:
        # Choisir le type de recherche d'hyperparamètres
        if search_type == 'grid':
            search = GridSearchCV(algo,
                                  param_grid,
                                  cv=cv,
                                  scoring=scoring)
        elif search_type == 'random':
            search = RandomizedSearchCV(algo,
                                        param_grid,
                                        cv=cv,
                                        scoring=scoring)
        else:
            raise ValueError("search_type doit être 'grid' ou 'random'")

        # Entrainement et optimisation
        search.fit(X_train, y_train)
        best_model = search.best_estimator_
        best_params = search.best_params_
        cv_results = search.cv_results_

        # Prédiction avec le meilleur modele
        y_pred = best_model.predict(X_test)

    # Calcul des métriques (y en log1p -> conversion en euros)
    r2 = r2_score(y_test, y_pred)
    max_log = np.log(np.finfo(np.float64).max)
    y_test_safe = np.nan_to_num(np.asarray(y_test, dtype=float), nan=0.0, posinf=max_log, neginf=-max_log)
    y_pred_safe = np.nan_to_num(np.asarray(y_pred, dtype=float), nan=0.0, posinf=max_log, neginf=-max_log)
    y_test_safe = np.clip(y_test_safe, a_min=None, a_max=max_log)
    y_pred_safe = np.clip(y_pred_safe, a_min=None, a_max=max_log)
    y_test_eur = np.expm1(y_test_safe)
    y_pred_eur = np.expm1(y_pred_safe)
    rmse = mean_squared_error(y_test_eur, y_pred_eur) ** 0.5
    mae = mean_absolute_error(y_test_eur, y_pred_eur)
    # Conversion en k€ pour la lisibilité
    rmse_k = rmse / 1000.0
    mae_k = mae / 1000.0

    # Affichage des résultats
    print(f"Modèle : {algo.__class__.__name__}")
    print(f"Meilleurs paramètres : {best_params}")
    print(f"R2 (sur le test, log): {r2:.4f}")
    print(f"RMSE : {rmse:.2f}€")
    print(f"MAE : {mae:.2f} €")
    print(f"RMSE : {rmse_k:.2f} k€")
    print(f"MAE  : {mae_k:.2f} k€")

    return {
        "best_params": best_params,
        "r2": r2,
        "rmse": rmse,
        "mae": mae,
        "cv_results": cv_results,
        "best_model": best_model
    }
