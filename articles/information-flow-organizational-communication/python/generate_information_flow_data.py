"""
Generate synthetic information flow and organizational communication data.

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


def generate_data(n: int = 650, seed: int = 1414) -> pd.DataFrame:
    """Generate synthetic information-flow data."""
    rng = np.random.default_rng(seed)

    data = pd.DataFrame(
        {
            "unit_id": np.arange(1, n + 1),
            "signal_quality": rng.uniform(10, 95, n),
            "communication_quality": rng.uniform(10, 95, n),
            "interpretive_integration": rng.uniform(10, 95, n),
            "feedback_usability": rng.uniform(10, 95, n),
            "memory_retention": rng.uniform(10, 95, n),
            "openness": rng.uniform(10, 95, n),
            "escalation_access": rng.uniform(10, 95, n),
            "trust": rng.uniform(10, 95, n),
            "community_voice": rng.uniform(10, 95, n),
            "digital_transparency": rng.uniform(10, 95, n),
            "distortion_loss": rng.uniform(5, 95, n),
            "overload": rng.uniform(5, 95, n),
            "siloing": rng.uniform(5, 95, n),
            "suppression_pressure": rng.uniform(5, 95, n),
            "metric_tunnel_vision": rng.uniform(5, 95, n),
        }
    )

    data["information_raw"] = (
        0.12 * data["signal_quality"]
        + 0.12 * data["communication_quality"]
        + 0.12 * data["interpretive_integration"]
        + 0.11 * data["feedback_usability"]
        + 0.10 * data["memory_retention"]
        + 0.11 * data["openness"]
        + 0.09 * data["escalation_access"]
        + 0.08 * data["trust"]
        + 0.07 * data["community_voice"]
        + 0.07 * data["digital_transparency"]
        - 0.12 * data["distortion_loss"]
        - 0.09 * data["overload"]
        - 0.08 * data["siloing"]
        - 0.08 * data["suppression_pressure"]
        - 0.07 * data["metric_tunnel_vision"]
        + rng.normal(0, 6, n)
    )

    data["information_effectiveness"] = rescale(data["information_raw"], 0, 100)
    data["high_integration"] = (data["information_effectiveness"] >= 60).astype(int)
    data["fragile_communication"] = (
        (data["information_effectiveness"] >= 60)
        & (data["openness"] < 40)
        & (data["distortion_loss"] > 65)
    ).astype(int)
    data["high_overload_system"] = (
        (data["information_effectiveness"] >= 60)
        & (data["overload"] > 70)
        & (data["metric_tunnel_vision"] > 65)
    ).astype(int)

    return data


def main() -> None:
    data = generate_data()
    processed_path = PROCESSED_DIR / "information_flow_synthetic_data.csv"
    synthetic_path = SYNTHETIC_DIR / "information_flow_synthetic_data.csv"

    data.to_csv(processed_path, index=False)
    data.to_csv(synthetic_path, index=False)

    print(f"Wrote {processed_path}")
    print(f"Wrote {synthetic_path}")


if __name__ == "__main__":
    main()
