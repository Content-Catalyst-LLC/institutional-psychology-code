"""
Generate synthetic institutional change and behavioral adaptation data.

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


def generate_data(n: int = 600, seed: int = 202) -> pd.DataFrame:
    """Generate synthetic institutional adaptation data."""
    rng = np.random.default_rng(seed)

    data = pd.DataFrame(
        {
            "institution_id": np.arange(1, n + 1),
            "feedback_quality": rng.uniform(15, 95, n),
            "adaptive_capacity": rng.uniform(20, 95, n),
            "legitimacy": rng.uniform(15, 95, n),
            "incentive_alignment": rng.uniform(10, 95, n),
            "normative_support": rng.uniform(10, 95, n),
            "governance_capacity": rng.uniform(15, 95, n),
            "path_dependence": rng.uniform(15, 95, n),
            "behavioral_flexibility": rng.uniform(10, 95, n),
            "coordination_quality": rng.uniform(10, 95, n),
            "environmental_change": rng.uniform(5, 95, n),
            "distributional_attention": rng.uniform(5, 95, n),
            "transition_burden": rng.uniform(5, 95, n),
        }
    )

    data["change_raw"] = (
        0.13 * data["feedback_quality"]
        + 0.14 * data["adaptive_capacity"]
        + 0.10 * data["legitimacy"]
        + 0.10 * data["incentive_alignment"]
        + 0.09 * data["normative_support"]
        + 0.12 * data["governance_capacity"]
        + 0.10 * data["behavioral_flexibility"]
        + 0.08 * data["coordination_quality"]
        + 0.06 * data["environmental_change"]
        + 0.05 * data["distributional_attention"]
        - 0.12 * data["path_dependence"]
        - 0.05 * data["transition_burden"]
        + rng.normal(0, 6, n)
    )

    data["change_score"] = rescale(data["change_raw"], 0, 100)
    data["successful_adaptation"] = (data["change_score"] >= 58).astype(int)
    data["high_transition_burden"] = (data["transition_burden"] >= 65).astype(int)
    data["fragile_adaptation"] = (
        (data["successful_adaptation"] == 1)
        & (data["legitimacy"] < 45)
    ).astype(int)

    return data


def main() -> None:
    data = generate_data()
    processed_path = PROCESSED_DIR / "institutional_change_adaptation_synthetic_data.csv"
    synthetic_path = SYNTHETIC_DIR / "institutional_change_adaptation_synthetic_data.csv"

    data.to_csv(processed_path, index=False)
    data.to_csv(synthetic_path, index=False)

    print(f"Wrote {processed_path}")
    print(f"Wrote {synthetic_path}")


if __name__ == "__main__":
    main()
