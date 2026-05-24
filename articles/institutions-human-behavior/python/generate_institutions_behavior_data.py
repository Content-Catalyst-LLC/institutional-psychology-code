"""
Generate synthetic institutions and human behavior data.

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


def generate_data(n: int = 520, seed: int = 2020) -> pd.DataFrame:
    """Generate synthetic institutions and human behavior data."""
    rng = np.random.default_rng(seed)

    data = pd.DataFrame(
        {
            "unit_id": np.arange(1, n + 1),
            "normative_stability": rng.uniform(10, 95, n),
            "legitimacy_strength": rng.uniform(10, 95, n),
            "incentive_alignment": rng.uniform(10, 95, n),
            "information_quality": rng.uniform(10, 95, n),
            "memory_retention": rng.uniform(10, 95, n),
            "learning_capacity": rng.uniform(10, 95, n),
            "trust_reinforcement": rng.uniform(10, 95, n),
            "role_clarity": rng.uniform(10, 95, n),
            "repair_capacity": rng.uniform(10, 95, n),
            "administrative_burden": rng.uniform(5, 95, n),
            "opacity_pressure": rng.uniform(5, 95, n),
            "historical_harm_pressure": rng.uniform(5, 95, n),
            "fragmentation_pressure": rng.uniform(5, 95, n),
        }
    )

    data["institutional_strength_raw"] = (
        0.13 * data["normative_stability"]
        + 0.14 * data["legitimacy_strength"]
        + 0.11 * data["incentive_alignment"]
        + 0.12 * data["information_quality"]
        + 0.11 * data["memory_retention"]
        + 0.13 * data["learning_capacity"]
        + 0.12 * data["trust_reinforcement"]
        + 0.08 * data["role_clarity"]
        + 0.08 * data["repair_capacity"]
        - 0.12 * data["fragmentation_pressure"]
        - 0.08 * data["opacity_pressure"]
        - 0.08 * data["administrative_burden"]
        - 0.07 * data["historical_harm_pressure"]
        + rng.normal(0, 6, n)
    )

    data["institutional_strength"] = rescale(data["institutional_strength_raw"], 0, 100)

    data["behavioral_alignment_raw"] = (
        0.18 * data["institutional_strength"]
        + 0.13 * data["legitimacy_strength"]
        + 0.12 * data["normative_stability"]
        + 0.12 * data["incentive_alignment"]
        + 0.12 * data["trust_reinforcement"]
        + 0.10 * data["role_clarity"]
        - 0.11 * data["fragmentation_pressure"]
        - 0.08 * data["opacity_pressure"]
        - 0.08 * data["administrative_burden"]
        + rng.normal(0, 6, n)
    )

    data["behavioral_alignment"] = rescale(data["behavioral_alignment_raw"], 0, 100)
    data["high_institutional_alignment"] = (data["institutional_strength"] >= 60).astype(int)
    data["high_behavioral_alignment"] = (data["behavioral_alignment"] >= 60).astype(int)

    data["fragile_institutional_environment"] = (
        (data["institutional_strength"] >= 60)
        & (data["legitimacy_strength"] < 40)
        & (data["normative_stability"] < 40)
    ).astype(int)

    data["high_fragmentation_environment"] = (
        (data["fragmentation_pressure"] > 70)
        & (data["opacity_pressure"] > 65)
        & (data["repair_capacity"] < 40)
    ).astype(int)

    return data


def main() -> None:
    data = generate_data()
    processed_path = PROCESSED_DIR / "institutions_human_behavior_synthetic_data.csv"
    synthetic_path = SYNTHETIC_DIR / "institutions_human_behavior_synthetic_data.csv"

    data.to_csv(processed_path, index=False)
    data.to_csv(synthetic_path, index=False)

    print(f"Wrote {processed_path}")
    print(f"Wrote {synthetic_path}")


if __name__ == "__main__":
    main()
