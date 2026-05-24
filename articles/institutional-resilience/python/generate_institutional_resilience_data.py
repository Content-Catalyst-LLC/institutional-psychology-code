"""
Generate synthetic institutional resilience data.

This script creates synthetic institutional-level data for methods demonstration.
It does not use real people, real agencies, or confidential administrative records.
"""

from __future__ import annotations

from pathlib import Path
import numpy as np
import pandas as pd


ROOT = Path(__file__).resolve().parents[1]
PROCESSED_DIR = ROOT / "data" / "processed"
PROCESSED_DIR.mkdir(parents=True, exist_ok=True)


def rescale(series: pd.Series, lower: float = 0.0, upper: float = 100.0) -> pd.Series:
    """Min-max rescale a numeric pandas Series."""
    minimum = series.min()
    maximum = series.max()

    if maximum == minimum:
        return pd.Series(np.repeat((lower + upper) / 2, len(series)), index=series.index)

    return lower + (series - minimum) * (upper - lower) / (maximum - minimum)


def generate_data(n: int = 500, seed: int = 42) -> pd.DataFrame:
    """Generate synthetic institutional resilience data."""
    rng = np.random.default_rng(seed)

    data = pd.DataFrame(
        {
            "institution_id": np.arange(1, n + 1),
            "robustness": rng.uniform(40, 95, n),
            "adaptive_capacity": rng.uniform(30, 95, n),
            "recovery_capacity": rng.uniform(35, 95, n),
            "transformational_capacity": rng.uniform(20, 90, n),
            "legitimacy": rng.uniform(25, 95, n),
            "trust": rng.uniform(20, 95, n),
            "feedback_quality": rng.uniform(15, 95, n),
            "learning_rate": rng.uniform(20, 90, n),
            "redundancy": rng.uniform(10, 85, n),
            "modularity": rng.uniform(15, 90, n),
            "coordination": rng.uniform(20, 95, n),
            "shock_intensity": rng.uniform(10, 100, n),
        }
    )

    data["resilience_raw"] = (
        0.10 * data["robustness"]
        + 0.12 * data["adaptive_capacity"]
        + 0.10 * data["recovery_capacity"]
        + 0.08 * data["transformational_capacity"]
        + 0.12 * data["legitimacy"]
        + 0.10 * data["trust"]
        + 0.10 * data["feedback_quality"]
        + 0.08 * data["learning_rate"]
        + 0.07 * data["redundancy"]
        + 0.05 * data["modularity"]
        + 0.08 * data["coordination"]
        - 0.10 * data["shock_intensity"]
    )

    data["resilience_index"] = rescale(data["resilience_raw"], 0, 100)

    noise = rng.normal(0, 7, n)
    data["continuity_score"] = (
        0.35 * data["resilience_index"]
        + 0.25 * data["legitimacy"]
        + 0.20 * data["trust"]
        + 0.20 * data["coordination"]
        - 0.30 * data["shock_intensity"]
        + noise
    ).clip(0, 100)

    data["maintained_core_function"] = (data["continuity_score"] >= 55).astype(int)
    data["failure_flag"] = (data["continuity_score"] < 40).astype(int)

    return data


def main() -> None:
    data = generate_data()
    output_path = PROCESSED_DIR / "institutional_resilience_synthetic_data.csv"
    data.to_csv(output_path, index=False)
    print(f"Wrote {output_path}")


if __name__ == "__main__":
    main()
