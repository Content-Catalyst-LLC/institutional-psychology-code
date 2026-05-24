"""
Generate synthetic institutional memory data.

This script creates synthetic unit-level data for methods demonstration.
It does not use real people, real institutions, confidential records,
employee data, regulated-entity data, or sensitive administrative information.
"""

from __future__ import annotations

from pathlib import Path
import numpy as np
import pandas as pd


ROOT = Path(__file__).resolve().parents[1]
PROCESSED_DIR = ROOT / "data" / "processed"
SYNTHETIC_DIR = ROOT / "data" / "synthetic"
PROCESSED_DIR.mkdir(parents=True, exist_ok=True)
SYNTHETIC_DIR.mkdir(parents=True, exist_ok=True)


def rescale(series: pd.Series, lower: float = 0.0, upper: float = 100.0) -> pd.Series:
    """Min-max rescale a numeric Series."""
    minimum = series.min()
    maximum = series.max()

    if maximum == minimum:
        return pd.Series(np.repeat((lower + upper) / 2, len(series)), index=series.index)

    return lower + (series - minimum) * (upper - lower) / (maximum - minimum)


def generate_data(n: int = 650, seed: int = 1313) -> pd.DataFrame:
    """Generate synthetic institutional memory data."""
    rng = np.random.default_rng(seed)

    data = pd.DataFrame(
        {
            "unit_id": np.arange(1, n + 1),
            "documented_retention": rng.uniform(10, 95, n),
            "tacit_transfer": rng.uniform(10, 95, n),
            "accessibility": rng.uniform(10, 95, n),
            "interpretive_use": rng.uniform(10, 95, n),
            "revisability": rng.uniform(10, 95, n),
            "technical_continuity": rng.uniform(10, 95, n),
            "metadata_quality": rng.uniform(10, 95, n),
            "distributed_integration": rng.uniform(10, 95, n),
            "memory_justice": rng.uniform(10, 95, n),
            "path_dependence_pressure": rng.uniform(5, 95, n),
            "loss_fragmentation": rng.uniform(5, 95, n),
            "selective_narration": rng.uniform(5, 95, n),
            "turnover_pressure": rng.uniform(5, 95, n),
            "key_person_dependency": rng.uniform(5, 95, n),
        }
    )

    data["memory_raw"] = (
        0.12 * data["documented_retention"]
        + 0.12 * data["tacit_transfer"]
        + 0.12 * data["accessibility"]
        + 0.12 * data["interpretive_use"]
        + 0.11 * data["revisability"]
        + 0.09 * data["technical_continuity"]
        + 0.08 * data["metadata_quality"]
        + 0.08 * data["distributed_integration"]
        + 0.08 * data["memory_justice"]
        - 0.11 * data["path_dependence_pressure"]
        - 0.11 * data["loss_fragmentation"]
        - 0.08 * data["selective_narration"]
        - 0.07 * data["turnover_pressure"]
        - 0.06 * data["key_person_dependency"]
        + rng.normal(0, 6, n)
    )

    data["memory_effectiveness"] = rescale(data["memory_raw"], 0, 100)
    data["high_resilience_memory"] = (data["memory_effectiveness"] >= 60).astype(int)
    data["fragile_memory"] = (
        (data["memory_effectiveness"] >= 60)
        & (data["documented_retention"] < 40)
        & (data["tacit_transfer"] < 40)
    ).astype(int)
    data["high_path_dependence_memory"] = (
        (data["memory_effectiveness"] >= 60)
        & (data["path_dependence_pressure"] > 65)
        & (data["revisability"] < 40)
    ).astype(int)

    return data


def main() -> None:
    data = generate_data()
    processed_path = PROCESSED_DIR / "institutional_memory_synthetic_data.csv"
    synthetic_path = SYNTHETIC_DIR / "institutional_memory_synthetic_data.csv"

    data.to_csv(processed_path, index=False)
    data.to_csv(synthetic_path, index=False)

    print(f"Wrote {processed_path}")
    print(f"Wrote {synthetic_path}")


if __name__ == "__main__":
    main()
