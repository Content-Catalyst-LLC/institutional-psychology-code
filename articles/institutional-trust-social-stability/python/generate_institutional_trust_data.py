"""
Generate synthetic institutional trust and social stability data.

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


def generate_data(n: int = 520, seed: int = 1717) -> pd.DataFrame:
    """Generate synthetic institutional trust data."""
    rng = np.random.default_rng(seed)

    data = pd.DataFrame(
        {
            "unit_id": np.arange(1, n + 1),
            "consistency": rng.uniform(10, 95, n),
            "competence": rng.uniform(10, 95, n),
            "fairness": rng.uniform(10, 95, n),
            "transparency": rng.uniform(10, 95, n),
            "accountability": rng.uniform(10, 95, n),
            "integrity": rng.uniform(10, 95, n),
            "recognition_voice": rng.uniform(10, 95, n),
            "repair_capacity": rng.uniform(10, 95, n),
            "legitimacy": rng.uniform(10, 95, n),
            "voluntary_compliance": rng.uniform(10, 95, n),
            "cooperation_capacity": rng.uniform(10, 95, n),
            "learning_repair": rng.uniform(10, 95, n),
            "arbitrariness_pressure": rng.uniform(5, 95, n),
            "visible_violation_pressure": rng.uniform(5, 95, n),
            "fragmentation_pressure": rng.uniform(5, 95, n),
            "administrative_burden": rng.uniform(5, 95, n),
        }
    )

    data["trust_raw"] = (
        0.11 * data["consistency"]
        + 0.12 * data["competence"]
        + 0.14 * data["fairness"]
        + 0.10 * data["transparency"]
        + 0.13 * data["accountability"]
        + 0.12 * data["integrity"]
        + 0.09 * data["recognition_voice"]
        + 0.09 * data["repair_capacity"]
        - 0.13 * data["arbitrariness_pressure"]
        - 0.11 * data["visible_violation_pressure"]
        - 0.08 * data["administrative_burden"]
        + rng.normal(0, 6, n)
    )

    data["trust_score"] = rescale(data["trust_raw"], 0, 100)

    data["stability_raw"] = (
        0.18 * data["trust_score"]
        + 0.14 * data["legitimacy"]
        + 0.13 * data["voluntary_compliance"]
        + 0.12 * data["cooperation_capacity"]
        + 0.10 * data["learning_repair"]
        + 0.08 * data["repair_capacity"]
        - 0.12 * data["arbitrariness_pressure"]
        - 0.10 * data["fragmentation_pressure"]
        - 0.08 * data["visible_violation_pressure"]
        + rng.normal(0, 6, n)
    )

    data["social_stability"] = rescale(data["stability_raw"], 0, 100)
    data["high_trust"] = (data["trust_score"] >= 60).astype(int)
    data["high_stability"] = (data["social_stability"] >= 60).astype(int)
    data["fragile_trust_environment"] = (
        (data["trust_score"] >= 60)
        & (data["fairness"] < 40)
        & (data["accountability"] < 40)
    ).astype(int)
    data["high_distrust_pressure"] = (
        (data["arbitrariness_pressure"] > 70)
        & (data["visible_violation_pressure"] > 65)
        & (data["repair_capacity"] < 40)
    ).astype(int)

    return data


def main() -> None:
    data = generate_data()
    processed_path = PROCESSED_DIR / "institutional_trust_social_stability_synthetic_data.csv"
    synthetic_path = SYNTHETIC_DIR / "institutional_trust_social_stability_synthetic_data.csv"

    data.to_csv(processed_path, index=False)
    data.to_csv(synthetic_path, index=False)

    print(f"Wrote {processed_path}")
    print(f"Wrote {synthetic_path}")


if __name__ == "__main__":
    main()
