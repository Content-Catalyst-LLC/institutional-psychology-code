"""
Dynamic simulation of institutional enforcement and behavioral incentives.

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


def initialize_units(n_units: int = 260, seed: int = 909) -> pd.DataFrame:
    """Initialize synthetic enforcement units."""
    rng = np.random.default_rng(seed)

    return pd.DataFrame(
        {
            "unit_id": np.arange(1, n_units + 1),
            "legitimacy": rng.uniform(0.20, 0.90, n_units),
            "information_quality": rng.uniform(0.20, 0.90, n_units),
            "adaptive_learning": rng.uniform(0.20, 0.90, n_units),
            "accountability_reach": rng.uniform(0.20, 0.90, n_units),
            "evasion_pressure": rng.uniform(0.10, 0.90, n_units),
            "burden_sensitivity": rng.uniform(0.10, 0.90, n_units),
        }
    )


def run_simulation(n_units: int = 260, n_periods: int = 24, seed: int = 909) -> pd.DataFrame:
    """Run repeated enforcement behavior simulation."""
    rng = np.random.default_rng(seed)
    units = initialize_units(n_units, seed)
    records: list[dict[str, float]] = []

    for period in range(1, n_periods + 1):
        monitoring = rng.uniform(0.15, 0.95)
        sanctions = rng.uniform(0.15, 0.95)
        incentive_alignment = rng.uniform(0.15, 0.95)
        compliance_burden = rng.uniform(0.05, 0.85)
        selective_enforcement = rng.uniform(0.05, 0.85)
        hypocrisy_visibility = rng.uniform(0.05, 0.85)

        for index, row in units.iterrows():
            enforcement_score = (
                0.15 * monitoring
                + 0.15 * row["legitimacy"]
                + 0.13 * incentive_alignment
                + 0.13 * sanctions
                + 0.14 * row["information_quality"]
                + 0.11 * row["adaptive_learning"]
                + 0.10 * row["accountability_reach"]
                - 0.13 * row["evasion_pressure"]
                - 0.08 * compliance_burden * row["burden_sensitivity"]
                - 0.07 * selective_enforcement
                - 0.06 * hypocrisy_visibility
            )

            enforcement_score = clamp(enforcement_score)

            units.at[index, "legitimacy"] = clamp(
                row["legitimacy"]
                + 0.030 * (enforcement_score - 0.50)
                - 0.020 * selective_enforcement
                - 0.015 * hypocrisy_visibility
                - 0.010 * compliance_burden
            )

            units.at[index, "adaptive_learning"] = clamp(
                row["adaptive_learning"]
                + 0.025 * (enforcement_score - 0.40)
                + 0.015 * row["information_quality"]
                - 0.010 * compliance_burden
            )

            units.at[index, "accountability_reach"] = clamp(
                row["accountability_reach"]
                + 0.020 * sanctions
                - 0.020 * selective_enforcement
                - 0.010 * hypocrisy_visibility
            )

            units.at[index, "evasion_pressure"] = clamp(
                row["evasion_pressure"]
                - 0.015 * monitoring
                - 0.010 * row["information_quality"]
                + 0.008 * sanctions
                + 0.010 * hypocrisy_visibility
            )

            records.append(
                {
                    "period": period,
                    "unit_id": row["unit_id"],
                    "monitoring": monitoring,
                    "sanctions": sanctions,
                    "incentive_alignment": incentive_alignment,
                    "compliance_burden": compliance_burden,
                    "selective_enforcement": selective_enforcement,
                    "hypocrisy_visibility": hypocrisy_visibility,
                    "enforcement_score": enforcement_score,
                    "legitimacy": units.at[index, "legitimacy"],
                    "information_quality": units.at[index, "information_quality"],
                    "adaptive_learning": units.at[index, "adaptive_learning"],
                    "accountability_reach": units.at[index, "accountability_reach"],
                    "evasion_pressure": units.at[index, "evasion_pressure"],
                    "fragile_enforcement": int(
                        enforcement_score >= 0.60 and units.at[index, "legitimacy"] < 0.40
                    ),
                    "high_burden_enforcement": int(
                        enforcement_score >= 0.60
                        and compliance_burden >= 0.65
                        and selective_enforcement >= 0.65
                    ),
                }
            )

    return pd.DataFrame(records)


def main() -> None:
    results = run_simulation()

    period_summary = (
        results.groupby("period")[
            [
                "monitoring",
                "sanctions",
                "incentive_alignment",
                "compliance_burden",
                "selective_enforcement",
                "hypocrisy_visibility",
                "enforcement_score",
                "legitimacy",
                "information_quality",
                "adaptive_learning",
                "accountability_reach",
                "evasion_pressure",
                "fragile_enforcement",
                "high_burden_enforcement",
            ]
        ]
        .mean()
        .reset_index()
    )

    unit_summary = (
        results.groupby("unit_id")[
            [
                "enforcement_score",
                "legitimacy",
                "information_quality",
                "adaptive_learning",
                "accountability_reach",
                "evasion_pressure",
            ]
        ]
        .mean()
        .reset_index()
    )

    results["high_effectiveness"] = (results["enforcement_score"] >= 0.65).astype(int)

    high_rates = (
        results.groupby("period")["high_effectiveness"]
        .mean()
        .reset_index(name="high_effectiveness_rate")
    )

    fragile_periods = (
        period_summary[
            (period_summary["enforcement_score"] >= 0.60)
            & (period_summary["legitimacy"] < 0.40)
        ]
        .sort_values(["enforcement_score"], ascending=False)
    )

    high_burden_periods = (
        period_summary[
            (period_summary["enforcement_score"] >= 0.60)
            & (period_summary["compliance_burden"] >= 0.65)
            & (period_summary["selective_enforcement"] >= 0.65)
        ]
        .sort_values(["compliance_burden"], ascending=False)
    )

    results.to_csv(OUTPUT_DIR / "institutional_enforcement_behavioral_incentives_simulation.csv", index=False)
    period_summary.to_csv(OUTPUT_DIR / "institutional_enforcement_period_summary.csv", index=False)
    unit_summary.to_csv(OUTPUT_DIR / "institutional_enforcement_unit_summary.csv", index=False)
    high_rates.to_csv(OUTPUT_DIR / "institutional_enforcement_high_rates.csv", index=False)
    fragile_periods.to_csv(OUTPUT_DIR / "institutional_enforcement_fragile_periods.csv", index=False)
    high_burden_periods.to_csv(OUTPUT_DIR / "institutional_enforcement_high_burden_periods.csv", index=False)

    print("Simulation complete.")
    print(period_summary.head())
    print(f"Wrote outputs to {OUTPUT_DIR}")


if __name__ == "__main__":
    main()
