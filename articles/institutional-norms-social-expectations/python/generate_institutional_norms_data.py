"""
Generate synthetic institutional norms and social expectations data.

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


def generate_data(n: int = 520, seed: int = 1919) -> pd.DataFrame:
    """Generate synthetic institutional norms and social expectations data."""
    rng = np.random.default_rng(seed)

    data = pd.DataFrame(
        {
            "unit_id": np.arange(1, n + 1),
            "norm_repetition": rng.uniform(10, 95, n),
            "expectation_convergence": rng.uniform(10, 95, n),
            "internalization": rng.uniform(10, 95, n),
            "social_enforcement": rng.uniform(10, 95, n),
            "legitimacy_alignment": rng.uniform(10, 95, n),
            "trust_reinforcement": rng.uniform(10, 95, n),
            "role_clarity": rng.uniform(10, 95, n),
            "learning_capacity": rng.uniform(10, 95, n),
            "alternative_norm_visibility": rng.uniform(5, 95, n),
            "sanction_cost": rng.uniform(5, 95, n),
            "suppressive_pressure": rng.uniform(5, 95, n),
            "fragmentation_pressure": rng.uniform(5, 95, n),
            "unequal_normative_burden": rng.uniform(5, 95, n),
            "rigidity_pressure": rng.uniform(5, 95, n),
        }
    )

    data["normative_stability_raw"] = (
        0.13 * data["norm_repetition"]
        + 0.14 * data["expectation_convergence"]
        + 0.13 * data["internalization"]
        + 0.11 * data["social_enforcement"]
        + 0.13 * data["legitimacy_alignment"]
        + 0.11 * data["trust_reinforcement"]
        + 0.09 * data["role_clarity"]
        + 0.08 * data["learning_capacity"]
        - 0.13 * data["fragmentation_pressure"]
        - 0.10 * data["unequal_normative_burden"]
        - 0.08 * data["suppressive_pressure"]
        + rng.normal(0, 6, n)
    )

    data["normative_stability"] = rescale(data["normative_stability_raw"], 0, 100)
    data["high_coordination"] = (data["normative_stability"] >= 60).astype(int)

    data["fragile_normative_environment"] = (
        (data["normative_stability"] >= 60)
        & (data["expectation_convergence"] < 40)
        & (data["legitimacy_alignment"] < 40)
    ).astype(int)

    data["suppressive_norm_environment"] = (
        (data["social_enforcement"] > 70)
        & (data["suppressive_pressure"] > 65)
        & (data["learning_capacity"] < 40)
    ).astype(int)

    data["norm_change_readiness_raw"] = (
        0.16 * data["alternative_norm_visibility"]
        + 0.14 * data["learning_capacity"]
        + 0.12 * data["legitimacy_alignment"]
        - 0.15 * data["sanction_cost"]
        - 0.12 * data["rigidity_pressure"]
        - 0.10 * data["suppressive_pressure"]
        + rng.normal(0, 5, n)
    )

    data["norm_change_readiness"] = rescale(data["norm_change_readiness_raw"], 0, 100)

    return data


def main() -> None:
    data = generate_data()
    processed_path = PROCESSED_DIR / "institutional_norms_social_expectations_synthetic_data.csv"
    synthetic_path = SYNTHETIC_DIR / "institutional_norms_social_expectations_synthetic_data.csv"

    data.to_csv(processed_path, index=False)
    data.to_csv(synthetic_path, index=False)

    print(f"Wrote {processed_path}")
    print(f"Wrote {synthetic_path}")


if __name__ == "__main__":
    main()
