"""
Generate synthetic crisis, reform, and institutional transformation data.

This script creates synthetic case-level data for methods demonstration.
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


def generate_data(n: int = 600, seed: int = 123) -> pd.DataFrame:
    """Generate synthetic institutional crisis/reform data."""
    rng = np.random.default_rng(seed)

    data = pd.DataFrame(
        {
            "case_id": np.arange(1, n + 1),
            "crisis_severity": rng.uniform(20, 100, n),
            "feedback_breakdown": rng.uniform(15, 100, n),
            "legitimacy_failure": rng.uniform(10, 100, n),
            "adaptive_capacity": rng.uniform(20, 95, n),
            "reform_window": rng.uniform(10, 95, n),
            "coalition_strength": rng.uniform(5, 95, n),
            "coordination_quality": rng.uniform(10, 95, n),
            "learning_rate": rng.uniform(15, 90, n),
            "governance_alignment": rng.uniform(10, 95, n),
            "power_concentration": rng.uniform(5, 95, n),
            "capture_risk": rng.uniform(5, 90, n),
            "distributional_attention": rng.uniform(5, 95, n),
        }
    )

    data["transformation_raw"] = (
        0.15 * data["crisis_severity"]
        + 0.11 * data["feedback_breakdown"]
        + 0.14 * data["legitimacy_failure"]
        + 0.10 * data["adaptive_capacity"]
        + 0.12 * data["reform_window"]
        + 0.12 * data["coalition_strength"]
        + 0.08 * data["coordination_quality"]
        + 0.06 * data["learning_rate"]
        + 0.06 * data["governance_alignment"]
        + 0.05 * data["distributional_attention"]
        - 0.07 * data["capture_risk"]
        - 0.04 * np.abs(data["power_concentration"] - 50)
        + rng.normal(0, 6, n)
    )

    data["transformation_score"] = rescale(data["transformation_raw"], 0, 100)
    data["major_reform"] = (data["transformation_score"] >= 60).astype(int)
    data["deep_transformation"] = (data["transformation_score"] >= 75).astype(int)
    data["high_capture_risk"] = (data["capture_risk"] >= 65).astype(int)
    data["low_distributional_attention"] = (data["distributional_attention"] < 35).astype(int)

    return data


def main() -> None:
    data = generate_data()
    processed_path = PROCESSED_DIR / "crisis_reform_synthetic_data.csv"
    synthetic_path = SYNTHETIC_DIR / "crisis_reform_synthetic_data.csv"

    data.to_csv(processed_path, index=False)
    data.to_csv(synthetic_path, index=False)

    print(f"Wrote {processed_path}")
    print(f"Wrote {synthetic_path}")


if __name__ == "__main__":
    main()
