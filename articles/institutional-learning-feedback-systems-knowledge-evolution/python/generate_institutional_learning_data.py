"""
Generate synthetic institutional learning data.

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


def generate_data(n: int = 650, seed: int = 1212) -> pd.DataFrame:
    """Generate synthetic institutional learning data."""
    rng = np.random.default_rng(seed)

    data = pd.DataFrame(
        {
            "unit_id": np.arange(1, n + 1),
            "feedback_quality": rng.uniform(10, 95, n),
            "memory_retention": rng.uniform(10, 95, n),
            "communication_openness": rng.uniform(10, 95, n),
            "interpretive_quality": rng.uniform(10, 95, n),
            "decision_revisability": rng.uniform(10, 95, n),
            "psychological_safety": rng.uniform(10, 95, n),
            "accountability_reach": rng.uniform(10, 95, n),
            "disconfirming_evidence": rng.uniform(5, 95, n),
            "institutional_inertia": rng.uniform(5, 95, n),
            "signal_distortion": rng.uniform(5, 95, n),
            "memory_decay": rng.uniform(5, 95, n),
            "defensive_routines": rng.uniform(5, 95, n),
            "power_protection": rng.uniform(5, 95, n),
            "feedback_delay": rng.uniform(5, 95, n),
        }
    )

    data["learning_raw"] = (
        0.13 * data["feedback_quality"]
        + 0.12 * data["memory_retention"]
        + 0.12 * data["communication_openness"]
        + 0.12 * data["interpretive_quality"]
        + 0.12 * data["decision_revisability"]
        + 0.12 * data["psychological_safety"]
        + 0.10 * data["accountability_reach"]
        + 0.06 * data["disconfirming_evidence"]
        - 0.12 * data["institutional_inertia"]
        - 0.10 * data["signal_distortion"]
        - 0.08 * data["memory_decay"]
        - 0.08 * data["defensive_routines"]
        - 0.08 * data["power_protection"]
        - 0.07 * data["feedback_delay"]
        + rng.normal(0, 6, n)
    )

    data["learning_capacity"] = rescale(data["learning_raw"], 0, 100)
    data["high_adaptation"] = (data["learning_capacity"] >= 60).astype(int)
    data["fragile_learning"] = (
        (data["learning_capacity"] >= 60)
        & (data["communication_openness"] < 40)
    ).astype(int)
    data["high_inertia_learning"] = (
        (data["learning_capacity"] >= 60)
        & (data["institutional_inertia"] > 65)
        & (data["signal_distortion"] > 65)
    ).astype(int)

    return data


def main() -> None:
    data = generate_data()
    processed_path = PROCESSED_DIR / "institutional_learning_synthetic_data.csv"
    synthetic_path = SYNTHETIC_DIR / "institutional_learning_synthetic_data.csv"

    data.to_csv(processed_path, index=False)
    data.to_csv(synthetic_path, index=False)

    print(f"Wrote {processed_path}")
    print(f"Wrote {synthetic_path}")


if __name__ == "__main__":
    main()
