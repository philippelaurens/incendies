"""Export reproductible et traçabilité des datasets du projet incendies."""

import hashlib
import json
from datetime import UTC, datetime
from pathlib import Path
from typing import Any

import pandas as pd


def sha256_file(path: Path, chunk_size: int = 1024 * 1024) -> str:
    """Calcule le SHA-256 d'un fichier par blocs."""
    digest = hashlib.sha256()
    with path.open("rb") as file:
        for chunk in iter(lambda: file.read(chunk_size), b""):
            digest.update(chunk)
    return digest.hexdigest()


def export_versioned_dataset(
    dataset: pd.DataFrame,
    output_path: Path,
    *,
    dataset_name: str,
    dataset_version: str,
    target: str,
    granularity: str,
    source_files: list[str],
) -> dict[str, Any]:
    """Exporte un Parquet et ses métadonnées JSON associées."""
    output_path.parent.mkdir(parents=True, exist_ok=True)
    dataset.to_parquet(output_path, index=False)
    metadata = {
        "dataset_name": dataset_name,
        "dataset_version": dataset_version,
        "created_at": datetime.now(UTC).isoformat(),
        "granularity": granularity,
        "target": target,
        "n_rows": len(dataset),
        "n_columns": len(dataset.columns),
        "columns": dataset.columns.tolist(),
        "source_files": source_files,
        "sha256": sha256_file(output_path),
    }
    metadata_path = output_path.with_suffix(".metadata.json")
    metadata_path.write_text(
        json.dumps(metadata, ensure_ascii=True, indent=2),
        encoding="utf-8",
    )
    return metadata
