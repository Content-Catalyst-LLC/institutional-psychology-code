"""
Generate synthetic behavioral governance data.

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


def generate_data(n: int = 650, seed: int = 707) -> pd.DataFrame:
    """Generate synthetic behavioral governance data."""
    rng = np.random.default_rng(seed)

    data = pd.DataFrame(
        {
            "unit_id": np.arange(1, n + 1),
            "incentive_alignment": rng.uniform(10, 95, n),
            "legitimacy": rng.uniform(10, 95, n),
            "norm_support": rng.uniform(10, 95, n),
            "cognitive_interpretability": rng.uniform(10, 95, n),
            "trust": rng.uniform(10, 95, n),
            "coordination_quality": rng.uniform(10, 95, n),
            "enforcement_credibility": rng.uniform(5, 95, n),
            "adaptive_learning": rng.uniform(10, 95, n),
            "perceived_fairness": rng.uniform(5, 95, n),
            "behavioral_burden": rng.uniform(5, 95, n),
            "hypocrisy_visibility": rng.uniform(5, 95, n),
            "power_asymmetry": rng.uniform(5, 95, n),
        }
    )

    data["governance_raw"] = (
        0.11 * data["incentive_alignment"]
        + 0.13 * data["legitimacy"]
        + 0.10 * data["norm_support"]
        + 0.11 * data["cognitive_interpretability"]
        + 0.12 * data["trust"]
        + 0.11 * data["coordination_quality"]
        + 0.10 * data["enforcement_credibility"]
        + 0.11 * data["adaptive_learning"]
        + 0.10 * data["perceived_fairness"]
        - 0.10 * data["behavioral_burden"]
        - 0.07 * data["hypocrisy_visibility"]
        - 0.06 * data["power_asymmetry"]
        + rng.normal(0, 6, n)
    )

    data["governance_effectiveness"] = rescale(data["governance_raw"], 0, 100)
    data["high_governance"] = (data["governance_effectiveness"] >= 60).astype(int)
    data["fragile_governance"] = (
        (data["governance_effectiveness"] >= 60)
        & (data["trust"] < 40)
    ).astype(int)
    data["high_burden_governance"] = (
        (data["governance_effectiveness"] >= 60)
        & (data["behavioral_burden"] > 65)
        & (data["perceived_fairness"] < 40)
    ).astype(int)

    return data


def main() -> None:
    data = generate_data()
    processed_path = PROCESSED_DIR / "behavioral_governance_synthetic_data.csv"
    synthetic_path = SYNTHETIC_DIR / "behavioral_governance_synthetic_data.csv"

    data.to_csv(processed_path, index=False)
    data.to_csv(synthetic_path, index=False)

    print(f"Wrote {processed_path}")
    print(f"Wrote {synthetic_path}")


if __name__ == "__main__":
    main()
