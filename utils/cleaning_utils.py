# utils.py
import pandas as pd
import numpy as np
import unicodedata
import re

# ===============================
# Fonctions de nettoyage et exploration de données
# ===============================

# Colonnes vides
def empty_columns(df: pd.DataFrame) -> list:
    """Retourne les colonnes dont toutes les valeurs sont NaN"""
    return df.columns[df.isna().all()].tolist()

# Colonnes avec une seule valeur unique (incluant NaN)
def unique_value_columns(df: pd.DataFrame) -> list:
    """Retourne les colonnes avec une seule valeur unique"""
    return df.columns[df.nunique(dropna=False) <= 1].tolist()

# Colonnes de type string / object
def string_columns(df: pd.DataFrame) -> list:
    """Retourne les colonnes de type string ou object"""
    return df.select_dtypes(include=['object', 'string']).columns.tolist()

# Colonnes booléennes ou True/False/NaN
def boolean_columns(df: pd.DataFrame) -> list:
    """Retourne les colonnes booléennes ou contenant seulement True/False/NaN"""
    bool_cols = []
    for col in df.columns:
        s = df[col].dropna().unique()
        if set(s).issubset({True, False}):
            bool_cols.append(col)
    return bool_cols

# Colonnes numériques
def numeric_columns(df: pd.DataFrame) -> list:
    """Retourne les colonnes numériques (int, float)"""
    return df.select_dtypes(include=['number']).columns.tolist()

# Colonnes avec beaucoup de NaN
def high_na_columns(df: pd.DataFrame, threshold: float = 0.5) -> list:
    """Retourne les colonnes avec plus de `threshold` proportion de NaN"""
    return df.columns[df.isna().mean() > threshold].tolist()

# Colonnes catégorielles avec trop de modalités
def high_cardinality_columns(df: pd.DataFrame, max_modalities: int = 20) -> list:
    """
    Retourne les colonnes object/string qui ont plus de `max_modalities` valeurs uniques
    """
    cat_cols = string_columns(df)
    high_card_cols = [col for col in cat_cols if df[col].nunique(dropna=True) > max_modalities]
    return high_card_cols

# Colonnes avec valeurs nulles ou équivalentes
def missing_like_columns(df: pd.DataFrame) -> list:
    """
    Colonnes contenant des valeurs manquantes explicites : NaN, None, '', 'na', 'null'
    """
    missing_vals = {np.nan, None, '', 'na', 'NA', 'null', 'NULL'}
    cols = []
    for col in df.columns:
        if df[col].isin(missing_vals).any():
            cols.append(col)
    return cols

# Supprimer colonnes et garder trace
def drop_columns(df: pd.DataFrame, cols: list, dropped: list = None) -> pd.DataFrame:
    """
    Supprime les colonnes et optionnellement ajoute à la liste `dropped`
    """
    if dropped is not None:
        dropped.extend(cols)
    return df.drop(columns=cols)

# Conversion booléen -> UInt8
def convert_bool_to_uint8(df: pd.DataFrame, cols: list, keep_na: bool = True) -> pd.DataFrame:
    """
    Convertit True/False/NaN en UInt8
    keep_na=True : True->1, False->0, NaN->NaN
    keep_na=False: True->1, False->0, NaN->0
    """
    for col in cols:
        if keep_na:
            df[col] = df[col].astype('boolean').astype('UInt8')
        else:
            df[col] = df[col].astype('boolean').fillna(False).astype('UInt8')
    return df

# Conversion texte en minuscules pour colonnes existantes
def lower_columns(df: pd.DataFrame, cols: list) -> pd.DataFrame:
    """
    Convertit en minuscules uniquement les colonnes existantes et typées string/object
    """
    # Colonnes existantes dans le DataFrame
    existing_cols = [c for c in cols if c in df.columns]

    # Filtrer pour ne garder que les colonnes string/object
    string_cols = [c for c in existing_cols if pd.api.types.is_string_dtype(df[c])]

    for col in string_cols:
        df[col] = df[col].str.lower()

    return df


# Créer colonne catégorielle selon mots-clés
def add_type_column(df: pd.DataFrame, col_source: str, mapping: dict, col_dest: str = 'type') -> pd.DataFrame:
    """
    Crée une nouvelle colonne selon un mapping de mots-clés dans la colonne source
    mapping = {'piso': 'piso', 'casa': 'casa o chalet', ...}
    """
    df[col_dest] = None
    for key, value in mapping.items():
        mask = df[col_source].str.contains(key, na=False)
        df.loc[mask & df[col_dest].isna(), col_dest] = value
    return df

# Imputation simple pour colonnes numériques
def impute_numeric(df: pd.DataFrame, cols: list = None, strategy: str = 'median') -> pd.DataFrame:
    """
    Impute les valeurs manquantes des colonnes numériques
    strategy: 'mean', 'median', 'zero'
    """
    if cols is None:
        cols = numeric_columns(df)
    for col in cols:
        if strategy == 'median':
            df[col] = df[col].fillna(df[col].median())
        elif strategy == 'mean':
            df[col] = df[col].fillna(df[col].mean())
        elif strategy == 'zero':
            df[col] = df[col].fillna(0)
    return df

# Imputation simple pour colonnes catégorielles
def impute_categorical(df: pd.DataFrame, cols: list = None, fill_value: str = 'missing') -> pd.DataFrame:
    """Remplit les valeurs manquantes des colonnes object/string par fill_value"""
    if cols is None:
        cols = string_columns(df)
    for col in cols:
        df[col] = df[col].fillna(fill_value)
    return df

# --- Taux de remplissage ---
def fill_rate(df):
    """
    Calcule le taux de remplissage (%) par colonne : 100 * (nb de valeurs non nulles / nb total de lignes).
    Retourne une Series indexée par nom de colonne.
    """
    return df.count() / len(df) * 100

# --- Suppression de colonnes ---
dropped_cols = []
def delete(df: pd.DataFrame, col: str, dropped: list = None) -> pd.DataFrame:
    """
    Supprime une colonne d'un DataFrame et l'ajoute à la liste `dropped` si fournie.
    Attention : la fonction retourne un nouveau DataFrame, il faut le réaffecter.
    """
    if dropped is not None:
        dropped.append(col)
    return df.drop(columns=[col])



# --- Normalisation des accents et de la casse ---
def normalize_string(text):
    """
    Convertit une chaîne en minuscules et supprime les accents/caractères diacritiques,
    tout en protégeant les booléens (True/False) et les NaN.
    """

    # 1. Protection contre les NaN et None
    if pd.isna(text) or text is None:
        return text

    text_str = str(text)

    # 2. **PROTECTION BOOLÉENNE (NOUVEAU)**
    # Nous vérifions si la chaîne (en ignorant la casse) est 'true' ou 'false'
    if text_str.lower() in ['true', 'false']:
        # On peut soit laisser la chaîne telle quelle, soit la convertir en booléen Python natif.
        # Nous la laissons en chaîne pour le moment, mais non modifiée.
        return text

    # 3. Traitement standard du texte (minuscules et accents)

    # Convertir en minuscules (UNIQUEMENT les chaînes qui ne sont pas True/False)
    text_str_lower = text_str.lower()

    # Décomposer les caractères (NFD)
    normalized = unicodedata.normalize('NFD', text_str_lower)

    # Retirer les marques d'accent
    text_no_accents = re.sub(r'[\u0300-\u036f]', '', normalized)

    return text_no_accents


def normalize_text_columns_cells(df):
    """
    Applique la normalisation à toutes les colonnes de type 'object' ou 'string' d'un DataFrame.
    parcourt et modifie les données à l'intérieur des colonnes (les lignes du tableau)
    ne modifie pas les noms des colonnes (les en-têtes).
    """
    string_cols = df.select_dtypes(include=['object', 'string']).columns.tolist()

    print(f"Normalisation des colonnes de texte : {string_cols}")

    for col in string_cols:
        # Utiliser la fonction sécurisée
        df[col] = df[col].apply(normalize_string)

    return df


def normalize_columns_names(df):
    """
    Nettoie et normalise les noms de colonnes d'un DataFrame en format snake_case.
    Idéal pour l'exportation vers une base de données comme PostgreSQL.

    Paramètres :
    df (pandas.DataFrame) : Le DataFrame dont on veut nettoyer les colonnes.

    Retourne :
    pandas.DataFrame : Le DataFrame avec les noms de colonnes modifiés.
    """
    nouveaux_noms = []

    for col in df.columns:
        # Convertit en chaîne de caractères pour éviter les erreurs
        col = str(col)

        # Supprime les accents
        # NFKD sépare les caractères de leurs accents, puis on encode en ASCII pour ignorer les accents
        col = unicodedata.normalize('NFKD', col).encode('ASCII', 'ignore').decode('utf-8')

        # Met tout en minuscules
        col = col.lower()

        # Remplace les espaces et les tirets par des underscores
        col = re.sub(r'[ -]+', '_', col)

        # Supprime tous les caractères qui ne sont pas des lettres, des chiffres ou des underscores
        col = re.sub(r'[^a-z0-9_]', '', col)

        # Retire les underscores en début ou fin de nom s'il y en a
        col = col.strip('_')

        nouveaux_noms.append(col)

    # Appliquer la nouvelle liste de noms au DataFrame
    df.columns = nouveaux_noms
    print(f"Nouveaux noms de colonnes : {df.columns.tolist()}")

    return df


def optimize_numeric_column(df, column_name):
    """
    Optimise la mémoire d'une colonne numérique en convertissant les faux floats
    (entiers contenant des NaN) vers des types entiers 'Nullable' (Int8, Int16, etc.).
    """
    poids_avant = df[column_name].memory_usage(deep=True) / 1024

    # 1. On isole les valeurs réelles (sans les NaN) pour analyser le contenu
    valeurs_reelles = df[column_name].dropna()

    # Si la colonne est entièrement vide, on passe à la suivante
    if len(valeurs_reelles) == 0:
        return df

    # 2. On vérifie si toutes les valeurs réelles sont de parfaits entiers
    # (ex: 15.0 == 15 -> Vrai)
    est_entier = (valeurs_reelles == valeurs_reelles.astype(int)).all()

    if est_entier:
        # On trouve le minimum et le maximum pour choisir la taille mémoire idéale
        v_min = valeurs_reelles.min()
        v_max = valeurs_reelles.max()

        # 3. On choisit le type d'entier "Nullable" (avec MAJUSCULE) approprié
        if v_min > np.iinfo(np.int8).min and v_max < np.iinfo(np.int8).max:
            df[column_name] = df[column_name].astype('Int8')
        elif v_min > np.iinfo(np.int16).min and v_max < np.iinfo(np.int16).max:
            df[column_name] = df[column_name].astype('Int16')
        elif v_min > np.iinfo(np.int32).min and v_max < np.iinfo(np.int32).max:
            df[column_name] = df[column_name].astype('Int32')
        else:
            df[column_name] = df[column_name].astype('Int64')

    else:
        # 4. Si ce sont de vrais nombres à virgule, on les réduit en float32
        df[column_name] = pd.to_numeric(df[column_name], downcast='float')

    # Affichage des résultats
    # poids_apres = df[column_name].memory_usage(deep=True) / 1024
    # nouveau_type = df[column_name].dtype
    # print(f"{column_name} : {poids_avant:.2f} KB -> {poids_apres:.2f} KB (Type: {nouveau_type})")

    return df


# ===============================
# Exemple rapide d'utilisation
# ===============================
if __name__ == "__main__":
    # df = pd.DataFrame({
    #     'a': [1,1,1,None],
    #     'b': [None,None,None,None],
    #     'c': [True, False, True, None],
    #     'd': ['Hello', 'World', None, 'Test'],
    #     'e': ['na', 'NA', '', None, 'valid']
    # })
    df = pd.read_csv("raw_data/houses_Madrid.csv", index_col=1)

    print("Empty cols:", empty_columns(df))
    print("Unique value cols:", unique_value_columns(df))
    print("Bool cols:", boolean_columns(df))
    print("String cols:", string_columns(df))
    print("High NA cols:", high_na_columns(df))
    print("High cardinality cols:", high_cardinality_columns(df, max_modalities=2))
    print("Missing-like cols:", missing_like_columns(df))
