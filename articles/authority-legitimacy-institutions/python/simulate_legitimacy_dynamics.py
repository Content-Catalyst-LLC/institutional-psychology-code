"""
Dynamic simulation of authority-legitimacy and voluntary compliance.

This is a synthetic demonstration for institutional psychology research.
It should not be used for automated decisions about real people, workers,
students, communities, agencies, firms, or institutions.
"""

from __future__ import annotations

from pathlib import Path
import numpy as np
import pandas as pd


ROOT = Path(__file__).resolve().parents[1]
OUTPUT_DIR = ROOT / "outputs" / "tables"
OUTPUT_DIR.mkdir(parents=True, exist_ok=True)


def clamp(value: float, lower: float = 0.0, upper: float = 1.0) -> float:
    """Keep a value within a defined range."""
    return max(lower, min(upper, value))


def initialize_units(n_units: int = 260, seed: int = 1818) -> pd.DataFrame:
    """Initialize synthetic authority-legitimacy units."""
    rng = np.random.default_rng(seed)

    return pd.DataFrame(
        {
            "unit_id": np.arange(1, n_units + 1),
            "procedural_legitimacy": rng.uniform(0.20, 0.90, n_units),
            "outcome_legitimacy": rng.uniform(0.20, 0.90, n_units),
            "trust": rng.uniform(0.20, 0.90, n_units),
            "rule_clarity": rng.uniform(0.20, 0.90, n_units),
            "social_recognition": rng.uniform(0.20, 0.90, n_units),
            "accountability": rng.uniform(0.20, 0.90, n_units),
            "repair_capacity": rng.uniform(0.20, 0.90, n_units),
            "fairness": rng.uniform(0.20, 0.90, n_units),
        }
    )


def run_simulation(n_units: int = 260, n_periods: int = 24, seed: int = 1818) -> pd.DataFrame:
    """Run repeated authority-legitimacy simulation."""
    rng = np.random.default_rng(seed)
    units = initialize_units(n_units, seed)
    records: list[dict[str, float]] = []

    for period in range(1, n_periods + 1):
        formal_authority_clarity = rng.uniform(0.15, 0.95)
        arbitrariness_pressure = rng.uniform(0.10, 0.85)
        visible_inconsistency = rng.uniform(0.05, 0.80)
        unequal_burden = rng.uniform(0.05, 0.80)
        opacity_pressure = rng.uniform(0.05, 0.80)
        enforcement_coercion_pressure = rng.uniform(0.05, 0.80)

        for index, row in units.iterrows():
            legitimacy_score = (
                0.12 * formal_authority_clarity
                + 0.15 * row["procedural_legitimacy"]
                + 0.12 * row["outcome_legitimacy"]
                + 0.14 * row["trust"]
                + 0.12 * row["rule_clarity"]
                + 0.12 * row["social_recognition"]
                + 0.12 * row["accountability"]
                + 0.10 * row["repair_capacity"]
                + 0.10 * row["fairness"]
                - 0.15 * arbitrariness_pressure
                - 0.11 * visible_inconsistency
                - 0.09 * unequal_burden
                - 0.08 * opacity_pressure
            )

            legitimacy_score = clamp(legitimacy_score)

            voluntary_compliance_score = (
                0.22 * legitimacy_score
                + 0.15 * row["trust"]
                + 0.12 * row["fairness"]
                + 0.12 * row["rule_clarity"]
                + 0.10 * row["social_recognition"]
                + 0.08 * row["repair_capacity"]
                - 0.12 * enforcement_coercion_pressure
                - 0.10 * arbitrariness_pressure
                - 0.08 * unequal_burden
            )

            voluntary_compliance_score = clamp(voluntary_compliance_score)

            units.at[index, "procedural_legitimacy"] = clamp(
                row["procedural_legitimacy"]
                + 0.020 * (legitimacy_score - 0.40)
                - 0.006 * arbitrariness_pressure
            )

            units.at[index, "trust"] = clamp(
                row["trust"]
                + 0.020 * (legitimacy_score - 0.40)
                + 0.004 * row["repair_capacity"]
                - 0.006 * visible_inconsistency
            )

            units.at[index, "social_recognition"] = clamp(
                row["social_recognition"]
                + 0.018 * (legitimacy_score - 0.40)
                - 0.006 * unequal_burden
            )

            units.at[index, "accountability"] = clamp(
                row["accountability"]
                + 0.018 * (legitimacy_score - 0.40)
                + 0.005 * row["repair_capacity"]
                - 0.005 * opacity_pressure
            )

            units.at[index, "repair_capacity"] = clamp(
                row["repair_capacity"]
                + 0.018 * (legitimacy_score - 0.40)
                + 0.004 * row["accountability"]
                - 0.006 * visible_inconsistency
            )

            units.at[index, "fairness"] = clamp(
                row["fairness"]
                + 0.018 * (legitimacy_score - 0.40)
                - 0.006 * arbitrariness_pressure
                - 0.004 * unequal_burden
            )

            records.append(
                {
                    "period": period,
                    "unit_id": row["unit_id"],
                    "formal_authority_clarity": formal_authority_clarity,
                    "arbitrariness_pressure": arbitrariness_pressure,
                    "visible_inconsistency": visible_inconsistency,
                    "unequal_burden": unequal_burden,
                    "opacity_pressure": opacity_pressure,
                    "enforcement_coercion_pressure": enforcement_coercion_pressure,
                    "legitimacy_score": legitimacy_score,
                    "voluntary_compliance_score": voluntary_compliance_score,
                    "procedural_legitimacy": units.at[index, "procedural_legitimacy"],
                    "outcome_legitimacy": units.at[index, "outcome_legitimacy"],
                    "trust": units.at[index, "trust"],
                    "rule_clarity": units.at[index, "rule_clarity"],
                    "social_recognition": units.at[index, "social_recognition"],
                    "accountability": units.at[index, "accountability"],
                    "repair_capacity": units.at[index, "repair_capacity"],
                    "fairness": units.at[index, "fairness"],
                    "fragile_legitimacy_environment": int(
                        legitimacy_score >= 0.60
                        and units.at[index, "procedural_legitimacy"] < 0.40
                        and units.at[index, "trust"] < 0.40
                    ),
                    "high_arbitrariness_environment": int(
                        arbitrariness_pressure >= 0.70
                        and visible_inconsistency >= 0.65
                        and units.at[index, "repair_capacity"] < 0.40
                    ),
                }
            )

    return pd.DataFrame(records)


def main() -> None:
    results = run_simulation()

    period_summary = (
        results.groupby("period")[
            [
                "formal_authority_clarity",
                "arbitrariness_pressure",
                "visible_inconsistency",
                "unequal_burden",
                "opacity_pressure",
                "enforcement_coercion_pressure",
                "legitimacy_score",
                "voluntary_compliance_score",
                "procedural_legitimacy",
                "outcome_legitimacy",
                "trust",
                "rule_clarity",
                "social_recognition",
                "accountability",
                "repair_capacity",
                "fairness",
                "fragile_legitimacy_environment",
                "high_arbitrariness_environment",
            ]
        ]
        .mean()
        .reset_index()
    )

    unit_summary = (
        results.groupby("unit_id")[
            [
                "legitimacy_score",
                "voluntary_compliance_score",
                "procedural_legitimacy",
                "trust",
                "social_recognition",
                "accountability",
                "repair_capacity",
                "fairness",
            ]
        ]
        .mean()
        .reset_index()
    )

    results["high_legitimacy"] = (results["legitimacy_score"] >= 0.65).astype(int)
    results["high_voluntary_compliance"] = (
        results["voluntary_compliance_score"] >= 0.65
    ).astype(int)

    high_legitimacy_rates = (
        results.groupby("period")["high_legitimacy"]
        .mean()
        .reset_index(name="high_legitimacy_rate")
    )

    high_compliance_rates = (
        results.groupby("period")["high_voluntary_compliance"]
        .mean()
        .reset_index(name="high_voluntary_compliance_rate")
    )

    fragile_periods = (
        period_summary[
            (period_summary["legitimacy_score"] >= 0.60)
            & (period_summary["procedural_legitimacy"] < 0.40)
            & (period_summary["trust"] < 0.40)
        ]
        .sort_values("legitimacy_score", ascending=False)
    )

    high_arbitrariness_periods = (
        period_summary[
            (period_summary["arbitrariness_pressure"] >= 0.70)
            & (period_summary["visible_inconsistency"] >= 0.65)
            & (period_summary["repair_capacity"] < 0.40)
        ]
        .sort_values("arbitrariness_pressure", ascending=False)
    )

    results.to_csv(OUTPUT_DIR / "authority_legitimacy_institutions_simulation.csv", index=False)
    period_summary.to_csv(OUTPUT_DIR / "authority_legitimacy_period_summary.csv", index=False)
    unit_summary.to_csv(OUTPUT_DIR / "authority_legitimacy_unit_summary.csv", index=False)
    high_legitimacy_rates.to_csv(OUTPUT_DIR / "authority_legitimacy_high_legitimacy_rates.csv", index=False)
    high_compliance_rates.to_csv(OUTPUT_DIR / "authority_legitimacy_high_compliance_rates.csv", index=False)
    fragile_periods.to_csv(OUTPUT_DIR / "authority_legitimacy_fragile_periods.csv", index=False)
    high_arbitrariness_periods.to_csv(OUTPUT_DIR / "authority_legitimacy_high_arbitrariness_periods.csv", index=False)

    print("Simulation complete.")
    print(period_summary.head())
    print(f"Wrote outputs to {OUTPUT_DIR}")


if __name__ == "__main__":
    main()
