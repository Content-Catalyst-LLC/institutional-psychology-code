"""
Generate synthetic cognitive bias and institutional decision-making data.

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


def generate_data(n: int = 650, seed: int = 1515) -> pd.DataFrame:
    """Generate synthetic institutional bias and decision-quality data."""
    rng = np.random.default_rng(seed)

    data = pd.DataFrame(
        {
            "unit_id": np.arange(1, n + 1),
            "overconfidence": rng.uniform(5, 95, n),
            "anchoring_pressure": rng.uniform(5, 95, n),
            "confirmation_pressure": rng.uniform(5, 95, n),
            "conformity_pressure": rng.uniform(5, 95, n),
            "filtering_distortion": rng.uniform(5, 95, n),
            "path_lock_in": rng.uniform(5, 95, n),
            "metric_tunnel_vision": rng.uniform(5, 95, n),
            "power_protection": rng.uniform(5, 95, n),
            "dissent_capacity": rng.uniform(10, 95, n),
            "corrective_review": rng.uniform(10, 95, n),
            "information_quality": rng.uniform(10, 95, n),
            "feedback_openness": rng.uniform(10, 95, n),
            "psychological_safety": rng.uniform(10, 95, n),
            "justice_voice": rng.uniform(10, 95, n),
        }
    )

    data["bias_pressure_raw"] = (
        0.12 * data["overconfidence"]
        + 0.11 * data["anchoring_pressure"]
        + 0.11 * data["confirmation_pressure"]
        + 0.11 * data["conformity_pressure"]
        + 0.12 * data["filtering_distortion"]
        + 0.10 * data["path_lock_in"]
        + 0.09 * data["metric_tunnel_vision"]
        + 0.08 * data["power_protection"]
        - 0.12 * data["dissent_capacity"]
        - 0.11 * data["corrective_review"]
        - 0.11 * data["information_quality"]
        - 0.10 * data["feedback_openness"]
        - 0.08 * data["psychological_safety"]
        - 0.07 * data["justice_voice"]
        + rng.normal(0, 6, n)
    )

    data["institutional_bias_pressure"] = rescale(data["bias_pressure_raw"], 0, 100)

    data["decision_quality_raw"] = (
        0.14 * data["dissent_capacity"]
        + 0.14 * data["corrective_review"]
        + 0.14 * data["information_quality"]
        + 0.13 * data["feedback_openness"]
        + 0.11 * data["psychological_safety"]
        + 0.10 * data["justice_voice"]
        - 0.13 * data["overconfidence"]
        - 0.13 * data["conformity_pressure"]
        - 0.14 * data["filtering_distortion"]
        - 0.12 * data["path_lock_in"]
        - 0.10 * data["metric_tunnel_vision"]
        - 0.09 * data["power_protection"]
        + rng.normal(0, 6, n)
    )

    data["decision_quality"] = rescale(data["decision_quality_raw"], 0, 100)
    data["high_resilience_decision"] = (data["decision_quality"] >= 60).astype(int)
    data["fragile_judgment"] = (
        (data["decision_quality"] >= 60)
        & (data["dissent_capacity"] < 40)
        & (data["filtering_distortion"] > 65)
    ).astype(int)
    data["high_bias_environment"] = (
        (data["institutional_bias_pressure"] >= 65)
        & (data["corrective_review"] < 40)
        & (data["feedback_openness"] < 40)
    ).astype(int)

    return data


def main() -> None:
    data = generate_data()
    processed_path = PROCESSED_DIR / "cognitive_bias_institutional_decision_making_synthetic_data.csv"
    synthetic_path = SYNTHETIC_DIR / "cognitive_bias_institutional_decision_making_synthetic_data.csv"

    data.to_csv(processed_path, index=False)
    data.to_csv(synthetic_path, index=False)

    print(f"Wrote {processed_path}")
    print(f"Wrote {synthetic_path}")


if __name__ == "__main__":
    main()
