"""
Dynamic simulation of behavioral governance systems.

This is a synthetic demonstration for institutional psychology research.
It should not be used for automated decisions about real people, workers,
communities, agencies, or institutions.
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


def initialize_units(n_units: int = 260, seed: int = 707) -> pd.DataFrame:
    """Initialize synthetic governance units."""
    rng = np.random.default_rng(seed)

    return pd.DataFrame(
        {
            "unit_id": np.arange(1, n_units + 1),
            "legitimacy": rng.uniform(0.20, 0.90, n_units),
            "trust": rng.uniform(0.20, 0.90, n_units),
            "norm_support": rng.uniform(0.20, 0.90, n_units),
            "coordination_quality": rng.uniform(0.20, 0.90, n_units),
            "adaptive_learning": rng.uniform(0.20, 0.90, n_units),
            "perceived_fairness": rng.uniform(0.20, 0.90, n_units),
            "burden_sensitivity": rng.uniform(0.10, 0.90, n_units),
        }
    )


def run_simulation(n_units: int = 260, n_periods: int = 24, seed: int = 707) -> pd.DataFrame:
    """Run repeated behavioral governance simulation."""
    rng = np.random.default_rng(seed)
    units = initialize_units(n_units, seed)
    records: list[dict[str, float]] = []

    for period in range(1, n_periods + 1):
        incentive_alignment = rng.uniform(0.15, 0.95)
        enforcement = rng.uniform(0.15, 0.95)
        cognitive_interpretability = rng.uniform(0.15, 0.95)
        behavioral_burden = rng.uniform(0.05, 0.85)
        hypocrisy_visibility = rng.uniform(0.05, 0.85)
        power_asymmetry = rng.uniform(0.05, 0.85)

        for index, row in units.iterrows():
            governance_score = (
                0.14 * incentive_alignment
                + 0.17 * row["legitimacy"]
                + 0.14 * row["trust"]
                + 0.11 * row["norm_support"]
                + 0.11 * row["coordination_quality"]
                + 0.11 * enforcement
                + 0.10 * cognitive_interpretability
                + 0.10 * row["adaptive_learning"]
                + 0.08 * row["perceived_fairness"]
                - 0.12 * behavioral_burden * row["burden_sensitivity"]
                - 0.08 * hypocrisy_visibility
                - 0.06 * power_asymmetry
            )

            governance_score = clamp(governance_score)

            units.at[index, "legitimacy"] = clamp(
                row["legitimacy"]
                + 0.030 * (governance_score - 0.50)
                + 0.015 * row["perceived_fairness"]
                - 0.020 * hypocrisy_visibility
                - 0.020 * behavioral_burden
            )

            units.at[index, "trust"] = clamp(
                row["trust"]
                + 0.030 * (governance_score - 0.50)
                + 0.015 * cognitive_interpretability
                - 0.020 * hypocrisy_visibility
                - 0.015 * power_asymmetry
            )

            units.at[index, "adaptive_learning"] = clamp(
                row["adaptive_learning"]
                + 0.020 * (governance_score - 0.40)
                + 0.015 * cognitive_interpretability
                - 0.010 * behavioral_burden
            )

            units.at[index, "perceived_fairness"] = clamp(
                row["perceived_fairness"]
                + 0.015 * (1 - behavioral_burden)
                - 0.020 * power_asymmetry
                - 0.015 * hypocrisy_visibility
            )

            fragile_governance = int(governance_score >= 0.60 and units.at[index, "trust"] < 0.40)
            high_burden_governance = int(governance_score >= 0.60 and behavioral_burden >= 0.65)

            records.append(
                {
                    "period": period,
                    "unit_id": row["unit_id"],
                    "incentive_alignment": incentive_alignment,
                    "enforcement": enforcement,
                    "cognitive_interpretability": cognitive_interpretability,
                    "behavioral_burden": behavioral_burden,
                    "hypocrisy_visibility": hypocrisy_visibility,
                    "power_asymmetry": power_asymmetry,
                    "governance_score": governance_score,
                    "legitimacy": units.at[index, "legitimacy"],
                    "trust": units.at[index, "trust"],
                    "norm_support": units.at[index, "norm_support"],
                    "coordination_quality": units.at[index, "coordination_quality"],
                    "adaptive_learning": units.at[index, "adaptive_learning"],
                    "perceived_fairness": units.at[index, "perceived_fairness"],
                    "fragile_governance": fragile_governance,
                    "high_burden_governance": high_burden_governance,
                }
            )

    return pd.DataFrame(records)


def main() -> None:
    results = run_simulation()

    period_summary = (
        results.groupby("period")[
            [
                "incentive_alignment",
                "enforcement",
                "cognitive_interpretability",
                "behavioral_burden",
                "hypocrisy_visibility",
                "power_asymmetry",
                "governance_score",
                "legitimacy",
                "trust",
                "adaptive_learning",
                "perceived_fairness",
                "fragile_governance",
                "high_burden_governance",
            ]
        ]
        .mean()
        .reset_index()
    )

    unit_summary = (
        results.groupby("unit_id")[
            [
                "governance_score",
                "legitimacy",
                "trust",
                "adaptive_learning",
                "perceived_fairness",
            ]
        ]
        .mean()
        .reset_index()
    )

    results["high_governance"] = (results["governance_score"] >= 0.65).astype(int)

    high_rates = (
        results.groupby("period")["high_governance"]
        .mean()
        .reset_index(name="high_governance_rate")
    )

    fragile_periods = (
        period_summary[
            (period_summary["governance_score"] >= 0.60)
            & (period_summary["trust"] < 0.40)
        ]
        .sort_values(["governance_score"], ascending=False)
    )

    high_burden_periods = (
        period_summary[
            (period_summary["governance_score"] >= 0.60)
            & (period_summary["behavioral_burden"] >= 0.65)
        ]
        .sort_values(["behavioral_burden"], ascending=False)
    )

    results.to_csv(OUTPUT_DIR / "behavioral_governance_systems_simulation.csv", index=False)
    period_summary.to_csv(OUTPUT_DIR / "behavioral_governance_period_summary.csv", index=False)
    unit_summary.to_csv(OUTPUT_DIR / "behavioral_governance_unit_summary.csv", index=False)
    high_rates.to_csv(OUTPUT_DIR / "behavioral_governance_high_rates.csv", index=False)
    fragile_periods.to_csv(OUTPUT_DIR / "behavioral_governance_fragile_periods.csv", index=False)
    high_burden_periods.to_csv(OUTPUT_DIR / "behavioral_governance_high_burden_periods.csv", index=False)

    print("Simulation complete.")
    print(period_summary.head())
    print(f"Wrote outputs to {OUTPUT_DIR}")


if __name__ == "__main__":
    main()
