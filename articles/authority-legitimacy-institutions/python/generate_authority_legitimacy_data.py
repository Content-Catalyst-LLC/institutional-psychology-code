"""
Generate synthetic authority-legitimacy and voluntary-compliance data.

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


def generate_data(n: int = 520, seed: int = 1818) -> pd.DataFrame:
    """Generate synthetic authority-legitimacy data."""
    rng = np.random.default_rng(seed)

    data = pd.DataFrame(
        {
            "unit_id": np.arange(1, n + 1),
            "formal_authority_clarity": rng.uniform(10, 95, n),
            "procedural_legitimacy": rng.uniform(10, 95, n),
            "outcome_legitimacy": rng.uniform(10, 95, n),
            "trust": rng.uniform(10, 95, n),
            "rule_clarity": rng.uniform(10, 95, n),
            "social_recognition": rng.uniform(10, 95, n),
            "accountability": rng.uniform(10, 95, n),
            "repair_capacity": rng.uniform(10, 95, n),
            "fairness": rng.uniform(10, 95, n),
            "shared_norm_support": rng.uniform(10, 95, n),
            "arbitrariness_pressure": rng.uniform(5, 95, n),
            "visible_inconsistency": rng.uniform(5, 95, n),
            "unequal_burden": rng.uniform(5, 95, n),
            "opacity_pressure": rng.uniform(5, 95, n),
            "enforcement_coercion_pressure": rng.uniform(5, 95, n),
        }
    )

    data["authority_legitimacy_raw"] = (
        0.11 * data["formal_authority_clarity"]
        + 0.14 * data["procedural_legitimacy"]
        + 0.12 * data["outcome_legitimacy"]
        + 0.13 * data["trust"]
        + 0.11 * data["rule_clarity"]
        + 0.11 * data["social_recognition"]
        + 0.12 * data["accountability"]
        + 0.10 * data["repair_capacity"]
        + 0.10 * data["fairness"]
        - 0.14 * data["arbitrariness_pressure"]
        - 0.10 * data["visible_inconsistency"]
        - 0.09 * data["unequal_burden"]
        - 0.08 * data["opacity_pressure"]
        + rng.normal(0, 6, n)
    )

    data["authority_legitimacy_strength"] = rescale(data["authority_legitimacy_raw"], 0, 100)

    data["voluntary_compliance_raw"] = (
        0.20 * data["authority_legitimacy_strength"]
        + 0.13 * data["trust"]
        + 0.12 * data["fairness"]
        + 0.11 * data["shared_norm_support"]
        + 0.10 * data["rule_clarity"]
        + 0.08 * data["repair_capacity"]
        - 0.12 * data["enforcement_coercion_pressure"]
        - 0.10 * data["arbitrariness_pressure"]
        - 0.08 * data["unequal_burden"]
        + rng.normal(0, 6, n)
    )

    data["voluntary_compliance"] = rescale(data["voluntary_compliance_raw"], 0, 100)
    data["high_legitimacy"] = (data["authority_legitimacy_strength"] >= 60).astype(int)
    data["high_voluntary_compliance"] = (data["voluntary_compliance"] >= 60).astype(int)
    data["fragile_legitimacy_environment"] = (
        (data["authority_legitimacy_strength"] >= 60)
        & (data["procedural_legitimacy"] < 40)
        & (data["trust"] < 40)
    ).astype(int)
    data["high_arbitrariness_environment"] = (
        (data["arbitrariness_pressure"] > 70)
        & (data["visible_inconsistency"] > 65)
        & (data["repair_capacity"] < 40)
    ).astype(int)

    return data


def main() -> None:
    data = generate_data()
    processed_path = PROCESSED_DIR / "authority_legitimacy_institutions_synthetic_data.csv"
    synthetic_path = SYNTHETIC_DIR / "authority_legitimacy_institutions_synthetic_data.csv"

    data.to_csv(processed_path, index=False)
    data.to_csv(synthetic_path, index=False)

    print(f"Wrote {processed_path}")
    print(f"Wrote {synthetic_path}")


if __name__ == "__main__":
    main()
