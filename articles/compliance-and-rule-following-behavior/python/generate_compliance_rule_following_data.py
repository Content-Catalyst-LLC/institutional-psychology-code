"""
Generate synthetic compliance and rule-following data.

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


def generate_data(n: int = 650, seed: int = 1001) -> pd.DataFrame:
    """Generate synthetic compliance and rule-following data."""
    rng = np.random.default_rng(seed)

    data = pd.DataFrame(
        {
            "unit_id": np.arange(1, n + 1),
            "legitimacy": rng.uniform(10, 95, n),
            "fairness": rng.uniform(10, 95, n),
            "incentive_alignment": rng.uniform(10, 95, n),
            "norm_support": rng.uniform(10, 95, n),
            "enforcement_credibility": rng.uniform(5, 95, n),
            "communication_quality": rng.uniform(10, 95, n),
            "cognitive_clarity": rng.uniform(10, 95, n),
            "trust": rng.uniform(10, 95, n),
            "adaptive_learning": rng.uniform(10, 95, n),
            "compliance_burden": rng.uniform(5, 95, n),
            "selective_rule_application": rng.uniform(5, 95, n),
            "defensive_compliance": rng.uniform(5, 95, n),
            "hypocrisy_visibility": rng.uniform(5, 95, n),
            "norm_failure": rng.uniform(5, 95, n),
        }
    )

    data["compliance_raw"] = (
        0.13 * data["legitimacy"]
        + 0.13 * data["fairness"]
        + 0.11 * data["incentive_alignment"]
        + 0.11 * data["norm_support"]
        + 0.10 * data["enforcement_credibility"]
        + 0.11 * data["communication_quality"]
        + 0.12 * data["cognitive_clarity"]
        + 0.11 * data["trust"]
        + 0.09 * data["adaptive_learning"]
        - 0.11 * data["compliance_burden"]
        - 0.08 * data["selective_rule_application"]
        - 0.06 * data["defensive_compliance"]
        - 0.05 * data["hypocrisy_visibility"]
        - 0.05 * data["norm_failure"]
        + rng.normal(0, 6, n)
    )

    data["compliance_quality"] = rescale(data["compliance_raw"], 0, 100)
    data["high_compliance"] = (data["compliance_quality"] >= 60).astype(int)
    data["fragile_compliance"] = (
        (data["compliance_quality"] >= 60)
        & (data["legitimacy"] < 40)
    ).astype(int)
    data["high_burden_compliance"] = (
        (data["compliance_quality"] >= 60)
        & (data["compliance_burden"] > 65)
        & (data["selective_rule_application"] > 65)
    ).astype(int)

    return data


def main() -> None:
    data = generate_data()
    processed_path = PROCESSED_DIR / "compliance_rule_following_synthetic_data.csv"
    synthetic_path = SYNTHETIC_DIR / "compliance_rule_following_synthetic_data.csv"

    data.to_csv(processed_path, index=False)
    data.to_csv(synthetic_path, index=False)

    print(f"Wrote {processed_path}")
    print(f"Wrote {synthetic_path}")


if __name__ == "__main__":
    main()
