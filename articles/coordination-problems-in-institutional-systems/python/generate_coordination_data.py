"""
Generate synthetic institutional coordination data.

This script creates synthetic unit-level data for methods demonstration.
It does not use real people, real institutions, confidential records, or
sensitive administrative data.
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


def generate_data(n: int = 600, seed: int = 404) -> pd.DataFrame:
    """Generate synthetic institutional coordination data."""
    rng = np.random.default_rng(seed)

    data = pd.DataFrame(
        {
            "unit_id": np.arange(1, n + 1),
            "trust": rng.uniform(10, 95, n),
            "information_quality": rng.uniform(10, 95, n),
            "communication_clarity": rng.uniform(10, 95, n),
            "focal_salience": rng.uniform(5, 95, n),
            "authority_signal": rng.uniform(5, 95, n),
            "norm_strength": rng.uniform(10, 95, n),
            "learning_capacity": rng.uniform(10, 95, n),
            "uncertainty": rng.uniform(5, 95, n),
            "adaptation_burden": rng.uniform(5, 95, n),
            "competing_standards": rng.uniform(5, 95, n),
            "competing_authority": rng.uniform(5, 95, n),
            "distributional_attention": rng.uniform(5, 95, n),
        }
    )

    data["coordination_raw"] = (
        0.14 * data["trust"]
        + 0.14 * data["information_quality"]
        + 0.13 * data["communication_clarity"]
        + 0.12 * data["focal_salience"]
        + 0.10 * data["authority_signal"]
        + 0.10 * data["norm_strength"]
        + 0.09 * data["learning_capacity"]
        - 0.13 * data["uncertainty"]
        - 0.07 * data["adaptation_burden"]
        - 0.06 * data["competing_standards"]
        - 0.05 * data["competing_authority"]
        + 0.04 * data["distributional_attention"]
        + rng.normal(0, 6, n)
    )

    data["coordination_quality"] = rescale(data["coordination_raw"], 0, 100)
    data["high_alignment"] = (data["coordination_quality"] >= 60).astype(int)
    data["fragile_coordination"] = (
        (data["coordination_quality"] >= 60)
        & (data["trust"] < 40)
    ).astype(int)
    data["high_burden_coordination"] = (
        (data["coordination_quality"] >= 60)
        & (data["adaptation_burden"] > 65)
        & (data["distributional_attention"] < 40)
    ).astype(int)

    return data


def main() -> None:
    data = generate_data()
    processed_path = PROCESSED_DIR / "coordination_problems_synthetic_data.csv"
    synthetic_path = SYNTHETIC_DIR / "coordination_problems_synthetic_data.csv"

    data.to_csv(processed_path, index=False)
    data.to_csv(synthetic_path, index=False)

    print(f"Wrote {processed_path}")
    print(f"Wrote {synthetic_path}")


if __name__ == "__main__":
    main()
