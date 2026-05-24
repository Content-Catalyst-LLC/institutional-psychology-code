"""
Generate synthetic institutional path dependence data.

This script creates synthetic institution-level data for methods demonstration.
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


def generate_data(n: int = 600, seed: int = 101) -> pd.DataFrame:
    """Generate synthetic institutional path-dependence data."""
    rng = np.random.default_rng(seed)

    data = pd.DataFrame(
        {
            "institution_id": np.arange(1, n + 1),
            "initial_conditions": rng.uniform(20, 95, n),
            "behavioral_reinforcement": rng.uniform(15, 95, n),
            "feedback_strength": rng.uniform(20, 95, n),
            "increasing_returns": rng.uniform(10, 95, n),
            "coordination_effects": rng.uniform(15, 95, n),
            "learning_effects": rng.uniform(20, 95, n),
            "legitimacy": rng.uniform(20, 95, n),
            "switching_costs": rng.uniform(10, 100, n),
            "complementarity": rng.uniform(15, 95, n),
            "disruption_pressure": rng.uniform(5, 90, n),
            "reform_capacity": rng.uniform(5, 95, n),
            "distributional_burden": rng.uniform(5, 95, n),
        }
    )

    data["path_dependence_raw"] = (
        0.08 * data["initial_conditions"]
        + 0.12 * data["behavioral_reinforcement"]
        + 0.12 * data["feedback_strength"]
        + 0.13 * data["increasing_returns"]
        + 0.11 * data["coordination_effects"]
        + 0.10 * data["learning_effects"]
        + 0.12 * data["legitimacy"]
        + 0.12 * data["switching_costs"]
        + 0.10 * data["complementarity"]
        - 0.12 * data["disruption_pressure"]
        - 0.05 * data["reform_capacity"]
        + rng.normal(0, 5, n)
    )

    data["path_dependence_score"] = rescale(data["path_dependence_raw"], 0, 100)
    data["lock_in"] = (data["path_dependence_score"] >= 60).astype(int)
    data["strong_lock_in"] = (data["path_dependence_score"] >= 75).astype(int)
    data["high_burden_lock_in"] = (
        (data["path_dependence_score"] >= 60)
        & (data["distributional_burden"] >= 65)
    ).astype(int)

    return data


def main() -> None:
    data = generate_data()
    processed_path = PROCESSED_DIR / "institutional_path_dependence_synthetic_data.csv"
    synthetic_path = SYNTHETIC_DIR / "institutional_path_dependence_synthetic_data.csv"

    data.to_csv(processed_path, index=False)
    data.to_csv(synthetic_path, index=False)

    print(f"Wrote {processed_path}")
    print(f"Wrote {synthetic_path}")


if __name__ == "__main__":
    main()
