"""
Generate synthetic social norms and institutional cooperation data.

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


def generate_data(n: int = 600, seed: int = 505) -> pd.DataFrame:
    """Generate synthetic social norms and institutional cooperation data."""
    rng = np.random.default_rng(seed)

    data = pd.DataFrame(
        {
            "unit_id": np.arange(1, n + 1),
            "descriptive_norm": rng.uniform(10, 95, n),
            "injunctive_norm": rng.uniform(10, 95, n),
            "trust": rng.uniform(10, 95, n),
            "legitimacy": rng.uniform(10, 95, n),
            "sanction_intensity": rng.uniform(5, 95, n),
            "transmission_strength": rng.uniform(10, 95, n),
            "institutional_reinforcement": rng.uniform(10, 95, n),
            "norm_conflict": rng.uniform(5, 95, n),
            "hypocrisy_visibility": rng.uniform(5, 95, n),
            "unequal_enforcement": rng.uniform(5, 95, n),
            "performative_compliance": rng.uniform(5, 95, n),
            "distributional_attention": rng.uniform(5, 95, n),
        }
    )

    data["cooperation_raw"] = (
        0.14 * data["descriptive_norm"]
        + 0.14 * data["injunctive_norm"]
        + 0.13 * data["trust"]
        + 0.12 * data["legitimacy"]
        + 0.10 * data["sanction_intensity"]
        + 0.11 * data["transmission_strength"]
        + 0.12 * data["institutional_reinforcement"]
        - 0.13 * data["norm_conflict"]
        - 0.08 * data["hypocrisy_visibility"]
        - 0.07 * data["unequal_enforcement"]
        - 0.05 * data["performative_compliance"]
        + 0.04 * data["distributional_attention"]
        + rng.normal(0, 6, n)
    )

    data["cooperation_score"] = rescale(data["cooperation_raw"], 0, 100)
    data["high_norm_compliance"] = (data["cooperation_score"] >= 60).astype(int)
    data["fragile_norm_environment"] = (
        (data["cooperation_score"] >= 60)
        & (data["trust"] < 40)
    ).astype(int)
    data["high_burden_norm_environment"] = (
        (data["cooperation_score"] >= 60)
        & (data["unequal_enforcement"] > 65)
        & (data["distributional_attention"] < 40)
    ).astype(int)

    return data


def main() -> None:
    data = generate_data()
    processed_path = PROCESSED_DIR / "social_norms_institutional_cooperation_synthetic_data.csv"
    synthetic_path = SYNTHETIC_DIR / "social_norms_institutional_cooperation_synthetic_data.csv"

    data.to_csv(processed_path, index=False)
    data.to_csv(synthetic_path, index=False)

    print(f"Wrote {processed_path}")
    print(f"Wrote {synthetic_path}")


if __name__ == "__main__":
    main()
