"""
Dynamic simulation of regulatory behavior and institutional accountability.

This is a synthetic demonstration for institutional psychology research.
It should not be used for automated decisions about real people, workers,
communities, agencies, firms, or institutions.
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


def initialize_units(n_units: int = 260, seed: int = 808) -> pd.DataFrame:
    """Initialize synthetic regulatory units."""
    rng = np.random.default_rng(seed)

    return pd.DataFrame(
        {
            "unit_id": np.arange(1, n_units + 1),
            "legitimacy": rng.uniform(0.20, 0.90, n_units),
            "information_quality": rng.uniform(0.20, 0.90, n_units),
            "adaptive_learning": rng.uniform(0.20, 0.90, n_units),
            "accountability_reach": rng.uniform(0.20, 0.90, n_units),
            "capture_pressure": rng.uniform(0.10, 0.90, n_units),
            "burden_sensitivity": rng.uniform(0.10, 0.90, n_units),
        }
    )


def run_simulation(n_units: int = 260, n_periods: int = 24, seed: int = 808) -> pd.DataFrame:
    """Run repeated regulatory behavior simulation."""
    rng = np.random.default_rng(seed)
    units = initialize_units(n_units, seed)
    records: list[dict[str, float]] = []

    for period in range(1, n_periods + 1):
        oversight = rng.uniform(0.15, 0.95)
        enforcement = rng.uniform(0.15, 0.95)
        incentive_alignment = rng.uniform(0.15, 0.95)
        regulatory_burden = rng.uniform(0.05, 0.85)
        hypocrisy_visibility = rng.uniform(0.05, 0.85)
        unequal_accountability = rng.uniform(0.05, 0.85)

        for index, row in units.iterrows():
            accountability_score = (
                0.15 * oversight
                + 0.15 * row["legitimacy"]
                + 0.13 * incentive_alignment
                + 0.13 * enforcement
                + 0.14 * row["information_quality"]
                + 0.12 * row["adaptive_learning"]
                + 0.10 * row["accountability_reach"]
                - 0.14 * row["capture_pressure"]
                - 0.08 * regulatory_burden * row["burden_sensitivity"]
                - 0.07 * hypocrisy_visibility
                - 0.07 * unequal_accountability
            )

            accountability_score = clamp(accountability_score)

            units.at[index, "legitimacy"] = clamp(
                row["legitimacy"]
                + 0.030 * (accountability_score - 0.50)
                - 0.020 * hypocrisy_visibility
                - 0.015 * unequal_accountability
            )

            units.at[index, "adaptive_learning"] = clamp(
                row["adaptive_learning"]
                + 0.025 * (accountability_score - 0.40)
                + 0.015 * row["information_quality"]
                - 0.010 * regulatory_burden
            )

            units.at[index, "accountability_reach"] = clamp(
                row["accountability_reach"]
                + 0.020 * enforcement
                - 0.020 * unequal_accountability
                - 0.015 * row["capture_pressure"]
            )

            units.at[index, "capture_pressure"] = clamp(
                row["capture_pressure"]
                - 0.015 * oversight
                - 0.010 * enforcement
                + 0.015 * hypocrisy_visibility
            )

            records.append(
                {
                    "period": period,
                    "unit_id": row["unit_id"],
                    "oversight": oversight,
                    "enforcement": enforcement,
                    "incentive_alignment": incentive_alignment,
                    "regulatory_burden": regulatory_burden,
                    "hypocrisy_visibility": hypocrisy_visibility,
                    "unequal_accountability": unequal_accountability,
                    "accountability_score": accountability_score,
                    "legitimacy": units.at[index, "legitimacy"],
                    "information_quality": units.at[index, "information_quality"],
                    "adaptive_learning": units.at[index, "adaptive_learning"],
                    "accountability_reach": units.at[index, "accountability_reach"],
                    "capture_pressure": units.at[index, "capture_pressure"],
                    "fragile_regulation": int(
                        accountability_score >= 0.60 and units.at[index, "legitimacy"] < 0.40
                    ),
                    "high_burden_regulation": int(
                        accountability_score >= 0.60
                        and regulatory_burden >= 0.65
                        and unequal_accountability >= 0.65
                    ),
                }
            )

    return pd.DataFrame(records)


def main() -> None:
    results = run_simulation()

    period_summary = (
        results.groupby("period")[
            [
                "oversight",
                "enforcement",
                "incentive_alignment",
                "regulatory_burden",
                "hypocrisy_visibility",
                "unequal_accountability",
                "accountability_score",
                "legitimacy",
                "information_quality",
                "adaptive_learning",
                "accountability_reach",
                "capture_pressure",
                "fragile_regulation",
                "high_burden_regulation",
            ]
        ]
        .mean()
        .reset_index()
    )

    unit_summary = (
        results.groupby("unit_id")[
            [
                "accountability_score",
                "legitimacy",
                "information_quality",
                "adaptive_learning",
                "accountability_reach",
                "capture_pressure",
            ]
        ]
        .mean()
        .reset_index()
    )

    results["high_accountability"] = (results["accountability_score"] >= 0.65).astype(int)

    high_rates = (
        results.groupby("period")["high_accountability"]
        .mean()
        .reset_index(name="high_accountability_rate")
    )

    fragile_periods = (
        period_summary[
            (period_summary["accountability_score"] >= 0.60)
            & (period_summary["legitimacy"] < 0.40)
        ]
        .sort_values(["accountability_score"], ascending=False)
    )

    high_burden_periods = (
        period_summary[
            (period_summary["accountability_score"] >= 0.60)
            & (period_summary["regulatory_burden"] >= 0.65)
            & (period_summary["unequal_accountability"] >= 0.65)
        ]
        .sort_values(["regulatory_burden"], ascending=False)
    )

    results.to_csv(OUTPUT_DIR / "regulatory_behavior_accountability_simulation.csv", index=False)
    period_summary.to_csv(OUTPUT_DIR / "regulatory_accountability_period_summary.csv", index=False)
    unit_summary.to_csv(OUTPUT_DIR / "regulatory_accountability_unit_summary.csv", index=False)
    high_rates.to_csv(OUTPUT_DIR / "regulatory_accountability_high_rates.csv", index=False)
    fragile_periods.to_csv(OUTPUT_DIR / "regulatory_accountability_fragile_periods.csv", index=False)
    high_burden_periods.to_csv(OUTPUT_DIR / "regulatory_accountability_high_burden_periods.csv", index=False)

    print("Simulation complete.")
    print(period_summary.head())
    print(f"Wrote outputs to {OUTPUT_DIR}")


if __name__ == "__main__":
    main()
