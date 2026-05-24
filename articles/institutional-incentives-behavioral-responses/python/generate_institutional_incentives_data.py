"""
Generate synthetic institutional incentives and behavioral responses data.

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


def generate_data(n: int = 650, seed: int = 1111) -> pd.DataFrame:
    """Generate synthetic institutional incentive data."""
    rng = np.random.default_rng(seed)

    data = pd.DataFrame(
        {
            "unit_id": np.arange(1, n + 1),
            "value_alignment": rng.uniform(10, 95, n),
            "fairness": rng.uniform(10, 95, n),
            "information_quality": rng.uniform(10, 95, n),
            "legitimacy": rng.uniform(10, 95, n),
            "learning_support": rng.uniform(10, 95, n),
            "accountability": rng.uniform(10, 95, n),
            "bias_pressure": rng.uniform(5, 95, n),
            "metric_substitution": rng.uniform(5, 95, n),
            "reporting_distortion": rng.uniform(5, 95, n),
            "behavioral_burden": rng.uniform(5, 95, n),
            "short_termism": rng.uniform(5, 95, n),
            "status_inequality": rng.uniform(5, 95, n),
            "motivation_crowding": rng.uniform(5, 95, n),
        }
    )

    data["incentive_raw"] = (
        0.14 * data["value_alignment"]
        + 0.12 * data["fairness"]
        + 0.13 * data["information_quality"]
        + 0.12 * data["legitimacy"]
        + 0.12 * data["learning_support"]
        + 0.10 * data["accountability"]
        - 0.10 * data["bias_pressure"]
        - 0.12 * data["metric_substitution"]
        - 0.09 * data["reporting_distortion"]
        - 0.08 * data["behavioral_burden"]
        - 0.07 * data["short_termism"]
        - 0.06 * data["status_inequality"]
        - 0.05 * data["motivation_crowding"]
        + rng.normal(0, 6, n)
    )

    data["incentive_effectiveness"] = rescale(data["incentive_raw"], 0, 100)
    data["high_alignment"] = (data["incentive_effectiveness"] >= 60).astype(int)
    data["fragile_incentive_system"] = (
        (data["incentive_effectiveness"] >= 60)
        & (data["legitimacy"] < 40)
    ).astype(int)
    data["high_burden_incentive_system"] = (
        (data["incentive_effectiveness"] >= 60)
        & (data["behavioral_burden"] > 65)
        & (data["metric_substitution"] > 65)
    ).astype(int)

    return data


def main() -> None:
    data = generate_data()
    processed_path = PROCESSED_DIR / "institutional_incentives_synthetic_data.csv"
    synthetic_path = SYNTHETIC_DIR / "institutional_incentives_synthetic_data.csv"

    data.to_csv(processed_path, index=False)
    data.to_csv(synthetic_path, index=False)

    print(f"Wrote {processed_path}")
    print(f"Wrote {synthetic_path}")


if __name__ == "__main__":
    main()
