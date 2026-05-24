"""
Generate synthetic collective action and cooperation data.

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


def generate_data(n: int = 600, seed: int = 606) -> pd.DataFrame:
    """Generate synthetic collective action and cooperation data."""
    rng = np.random.default_rng(seed)

    data = pd.DataFrame(
        {
            "unit_id": np.arange(1, n + 1),
            "incentive_alignment": rng.uniform(10, 95, n),
            "trust": rng.uniform(10, 95, n),
            "legitimacy": rng.uniform(10, 95, n),
            "norm_strength": rng.uniform(10, 95, n),
            "enforcement_credibility": rng.uniform(5, 95, n),
            "communication_quality": rng.uniform(10, 95, n),
            "coordination_quality": rng.uniform(10, 95, n),
            "perceived_fairness": rng.uniform(5, 95, n),
            "free_riding_pressure": rng.uniform(5, 95, n),
            "burden_inequality": rng.uniform(5, 95, n),
            "hypocrisy_visibility": rng.uniform(5, 95, n),
            "scale_complexity": rng.uniform(5, 95, n),
        }
    )

    data["cooperation_raw"] = (
        0.12 * data["incentive_alignment"]
        + 0.13 * data["trust"]
        + 0.12 * data["legitimacy"]
        + 0.11 * data["norm_strength"]
        + 0.10 * data["enforcement_credibility"]
        + 0.11 * data["communication_quality"]
        + 0.11 * data["coordination_quality"]
        + 0.10 * data["perceived_fairness"]
        - 0.12 * data["free_riding_pressure"]
        - 0.07 * data["burden_inequality"]
        - 0.06 * data["hypocrisy_visibility"]
        - 0.05 * data["scale_complexity"]
        + rng.normal(0, 6, n)
    )

    data["cooperation_score"] = rescale(data["cooperation_raw"], 0, 100)
    data["high_cooperation"] = (data["cooperation_score"] >= 60).astype(int)
    data["fragile_cooperation"] = (
        (data["cooperation_score"] >= 60)
        & (data["trust"] < 40)
    ).astype(int)
    data["high_burden_cooperation"] = (
        (data["cooperation_score"] >= 60)
        & (data["burden_inequality"] > 65)
        & (data["perceived_fairness"] < 40)
    ).astype(int)

    return data


def main() -> None:
    data = generate_data()
    processed_path = PROCESSED_DIR / "collective_action_synthetic_data.csv"
    synthetic_path = SYNTHETIC_DIR / "collective_action_synthetic_data.csv"

    data.to_csv(processed_path, index=False)
    data.to_csv(synthetic_path, index=False)

    print(f"Wrote {processed_path}")
    print(f"Wrote {synthetic_path}")


if __name__ == "__main__":
    main()
