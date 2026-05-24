"""
Generate synthetic regulatory accountability data.

This script creates synthetic unit-level data for methods demonstration.
It does not use real people, real institutions, confidential records,
regulated-entity data, or sensitive administrative information.
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


def generate_data(n: int = 650, seed: int = 808) -> pd.DataFrame:
    """Generate synthetic regulatory accountability data."""
    rng = np.random.default_rng(seed)

    data = pd.DataFrame(
        {
            "unit_id": np.arange(1, n + 1),
            "oversight_strength": rng.uniform(10, 95, n),
            "legitimacy": rng.uniform(10, 95, n),
            "incentive_alignment": rng.uniform(10, 95, n),
            "enforcement_credibility": rng.uniform(5, 95, n),
            "information_quality": rng.uniform(10, 95, n),
            "adaptive_learning": rng.uniform(10, 95, n),
            "accountability_reach": rng.uniform(5, 95, n),
            "capture_pressure": rng.uniform(5, 95, n),
            "regulatory_burden": rng.uniform(5, 95, n),
            "evasion_pressure": rng.uniform(5, 95, n),
            "hypocrisy_visibility": rng.uniform(5, 95, n),
            "unequal_accountability": rng.uniform(5, 95, n),
        }
    )

    data["accountability_raw"] = (
        0.13 * data["oversight_strength"]
        + 0.13 * data["legitimacy"]
        + 0.11 * data["incentive_alignment"]
        + 0.12 * data["enforcement_credibility"]
        + 0.13 * data["information_quality"]
        + 0.11 * data["adaptive_learning"]
        + 0.11 * data["accountability_reach"]
        - 0.12 * data["capture_pressure"]
        - 0.08 * data["regulatory_burden"]
        - 0.07 * data["evasion_pressure"]
        - 0.06 * data["hypocrisy_visibility"]
        - 0.06 * data["unequal_accountability"]
        + rng.normal(0, 6, n)
    )

    data["accountability_effectiveness"] = rescale(data["accountability_raw"], 0, 100)
    data["high_accountability"] = (data["accountability_effectiveness"] >= 60).astype(int)
    data["fragile_regulation"] = (
        (data["accountability_effectiveness"] >= 60)
        & (data["legitimacy"] < 40)
    ).astype(int)
    data["high_burden_regulation"] = (
        (data["accountability_effectiveness"] >= 60)
        & (data["regulatory_burden"] > 65)
        & (data["unequal_accountability"] > 65)
    ).astype(int)

    return data


def main() -> None:
    data = generate_data()
    processed_path = PROCESSED_DIR / "regulatory_accountability_synthetic_data.csv"
    synthetic_path = SYNTHETIC_DIR / "regulatory_accountability_synthetic_data.csv"

    data.to_csv(processed_path, index=False)
    data.to_csv(synthetic_path, index=False)

    print(f"Wrote {processed_path}")
    print(f"Wrote {synthetic_path}")


if __name__ == "__main__":
    main()
