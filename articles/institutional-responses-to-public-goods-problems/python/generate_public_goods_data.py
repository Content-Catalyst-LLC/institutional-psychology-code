"""
Generate synthetic public goods institution data.

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


def generate_data(n: int = 600, seed: int = 303) -> pd.DataFrame:
    """Generate synthetic public goods contribution and provision data."""
    rng = np.random.default_rng(seed)

    data = pd.DataFrame(
        {
            "unit_id": np.arange(1, n + 1),
            "trust": rng.uniform(10, 95, n),
            "legitimacy": rng.uniform(10, 95, n),
            "enforcement": rng.uniform(5, 95, n),
            "norm_strength": rng.uniform(10, 95, n),
            "coordination": rng.uniform(10, 95, n),
            "monitoring": rng.uniform(10, 95, n),
            "selective_incentives": rng.uniform(5, 95, n),
            "scale_complexity": rng.uniform(5, 95, n),
            "perceived_fairness": rng.uniform(5, 95, n),
            "capture_risk": rng.uniform(5, 90, n),
            "distributional_attention": rng.uniform(5, 95, n),
        }
    )

    data["contribution_rate"] = (
        0.15 * data["trust"]
        + 0.14 * data["legitimacy"]
        + 0.12 * data["enforcement"]
        + 0.11 * data["norm_strength"]
        + 0.10 * data["coordination"]
        + 0.10 * data["monitoring"]
        + 0.09 * data["selective_incentives"]
        + 0.08 * data["perceived_fairness"]
        - 0.12 * data["scale_complexity"]
        - 0.07 * data["capture_risk"]
        + rng.normal(0, 7, n)
    ).clip(0, 100)

    data["provision_quality_raw"] = (
        0.22 * data["contribution_rate"]
        + 0.13 * data["legitimacy"]
        + 0.12 * data["trust"]
        + 0.11 * data["coordination"]
        + 0.10 * data["monitoring"]
        + 0.08 * data["distributional_attention"]
        - 0.12 * data["scale_complexity"]
        - 0.08 * data["capture_risk"]
        + rng.normal(0, 5, n)
    )

    data["provision_quality"] = rescale(data["provision_quality_raw"], 0, 100)
    data["high_provision"] = (data["provision_quality"] >= 60).astype(int)
    data["fragile_public_good"] = (
        (data["provision_quality"] >= 60)
        & (data["legitimacy"] < 40)
    ).astype(int)
    data["high_burden_risk"] = (
        (data["provision_quality"] >= 60)
        & (data["distributional_attention"] < 35)
    ).astype(int)

    return data


def main() -> None:
    data = generate_data()
    processed_path = PROCESSED_DIR / "public_goods_synthetic_data.csv"
    synthetic_path = SYNTHETIC_DIR / "public_goods_synthetic_data.csv"

    data.to_csv(processed_path, index=False)
    data.to_csv(synthetic_path, index=False)

    print(f"Wrote {processed_path}")
    print(f"Wrote {synthetic_path}")


if __name__ == "__main__":
    main()
