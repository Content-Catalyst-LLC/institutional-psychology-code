"""
Generate synthetic decision-quality data for institutional systems.

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


def generate_data(n: int = 700, seed: int = 1616) -> pd.DataFrame:
    """Generate synthetic institutional decision-quality data."""
    rng = np.random.default_rng(seed)

    data = pd.DataFrame(
        {
            "unit_id": np.arange(1, n + 1),
            "bounded_rationality_pressure": rng.uniform(5, 95, n),
            "organizational_structure_quality": rng.uniform(10, 95, n),
            "incentive_alignment": rng.uniform(10, 95, n),
            "information_flow_effectiveness": rng.uniform(10, 95, n),
            "legitimacy": rng.uniform(10, 95, n),
            "uncertainty_management": rng.uniform(10, 95, n),
            "corrective_capacity": rng.uniform(10, 95, n),
            "justice_voice": rng.uniform(10, 95, n),
            "memory_quality": rng.uniform(10, 95, n),
            "feedback_openness": rng.uniform(10, 95, n),
            "bias_distortion": rng.uniform(5, 95, n),
            "power_protection": rng.uniform(5, 95, n),
            "metric_fixation": rng.uniform(5, 95, n),
            "siloing": rng.uniform(5, 95, n),
            "premature_closure": rng.uniform(5, 95, n),
        }
    )

    data["decision_quality_raw"] = (
        0.12 * data["organizational_structure_quality"]
        + 0.12 * data["incentive_alignment"]
        + 0.13 * data["information_flow_effectiveness"]
        + 0.11 * data["legitimacy"]
        + 0.11 * data["uncertainty_management"]
        + 0.13 * data["corrective_capacity"]
        + 0.09 * data["justice_voice"]
        + 0.08 * data["memory_quality"]
        + 0.08 * data["feedback_openness"]
        - 0.13 * data["bounded_rationality_pressure"]
        - 0.11 * data["bias_distortion"]
        - 0.09 * data["power_protection"]
        - 0.08 * data["metric_fixation"]
        - 0.07 * data["siloing"]
        - 0.07 * data["premature_closure"]
        + rng.normal(0, 6, n)
    )

    data["decision_quality"] = rescale(data["decision_quality_raw"], 0, 100)
    data["high_quality_decision"] = (data["decision_quality"] >= 60).astype(int)
    data["fragile_decision_environment"] = (
        (data["decision_quality"] >= 60)
        & (data["corrective_capacity"] < 40)
        & (data["information_flow_effectiveness"] < 45)
    ).astype(int)
    data["high_distortion_environment"] = (
        (data["bias_distortion"] > 70)
        & (data["power_protection"] > 65)
        & (data["feedback_openness"] < 40)
    ).astype(int)

    return data


def main() -> None:
    data = generate_data()
    processed_path = PROCESSED_DIR / "decision_making_institutional_systems_synthetic_data.csv"
    synthetic_path = SYNTHETIC_DIR / "decision_making_institutional_systems_synthetic_data.csv"

    data.to_csv(processed_path, index=False)
    data.to_csv(synthetic_path, index=False)

    print(f"Wrote {processed_path}")
    print(f"Wrote {synthetic_path}")


if __name__ == "__main__":
    main()
