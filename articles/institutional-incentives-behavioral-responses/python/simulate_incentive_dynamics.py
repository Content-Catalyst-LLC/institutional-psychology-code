"""
Dynamic simulation of institutional incentives and behavioral responses.

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


def initialize_units(n_units: int = 260, seed: int = 1111) -> pd.DataFrame:
    """Initialize synthetic institutional units."""
    rng = np.random.default_rng(seed)

    return pd.DataFrame(
        {
            "unit_id": np.arange(1, n_units + 1),
            "fairness": rng.uniform(0.20, 0.90, n_units),
            "legitimacy": rng.uniform(0.20, 0.90, n_units),
            "learning_support": rng.uniform(0.20, 0.90, n_units),
            "accountability": rng.uniform(0.20, 0.90, n_units),
            "metric_substitution": rng.uniform(0.10, 0.90, n_units),
            "burden_sensitivity": rng.uniform(0.10, 0.90, n_units),
        }
    )


def run_simulation(n_units: int = 260, n_periods: int = 24, seed: int = 1111) -> pd.DataFrame:
    """Run repeated incentive-system simulation."""
    rng = np.random.default_rng(seed)
    units = initialize_units(n_units, seed)
    records: list[dict[str, float]] = []

    for period in range(1, n_periods + 1):
        value_alignment = rng.uniform(0.15, 0.95)
        information_quality = rng.uniform(0.15, 0.95)
        bias_pressure = rng.uniform(0.10, 0.85)
        reporting_distortion = rng.uniform(0.05, 0.85)
        behavioral_burden = rng.uniform(0.05, 0.85)
        short_termism = rng.uniform(0.05, 0.85)

        for index, row in units.iterrows():
            incentive_score = (
                0.17 * value_alignment
                + 0.14 * row["fairness"]
                + 0.15 * information_quality
                + 0.14 * row["legitimacy"]
                + 0.13 * row["learning_support"]
                + 0.10 * row["accountability"]
                - 0.10 * bias_pressure
                - 0.12 * row["metric_substitution"]
                - 0.08 * reporting_distortion
                - 0.07 * behavioral_burden * row["burden_sensitivity"]
                - 0.06 * short_termism
            )

            incentive_score = clamp(incentive_score)

            units.at[index, "fairness"] = clamp(
                row["fairness"]
                + 0.025 * (incentive_score - 0.50)
                - 0.015 * behavioral_burden
                - 0.015 * reporting_distortion
            )

            units.at[index, "legitimacy"] = clamp(
                row["legitimacy"]
                + 0.025 * (incentive_score - 0.50)
                + 0.010 * row["fairness"]
                - 0.020 * short_termism
                - 0.015 * row["metric_substitution"]
            )

            units.at[index, "learning_support"] = clamp(
                row["learning_support"]
                + 0.020 * (information_quality - 0.45)
                + 0.015 * (incentive_score - 0.40)
                - 0.010 * reporting_distortion
            )

            units.at[index, "metric_substitution"] = clamp(
                row["metric_substitution"]
                - 0.012 * row["learning_support"]
                - 0.010 * row["accountability"]
                + 0.008 * bias_pressure
                + 0.010 * short_termism
            )

            records.append(
                {
                    "period": period,
                    "unit_id": row["unit_id"],
                    "value_alignment": value_alignment,
                    "information_quality": information_quality,
                    "bias_pressure": bias_pressure,
                    "reporting_distortion": reporting_distortion,
                    "behavioral_burden": behavioral_burden,
                    "short_termism": short_termism,
                    "incentive_score": incentive_score,
                    "fairness": units.at[index, "fairness"],
                    "legitimacy": units.at[index, "legitimacy"],
                    "learning_support": units.at[index, "learning_support"],
                    "accountability": units.at[index, "accountability"],
                    "metric_substitution": units.at[index, "metric_substitution"],
                    "fragile_incentive_system": int(
                        incentive_score >= 0.60 and units.at[index, "legitimacy"] < 0.40
                    ),
                    "high_burden_incentive_system": int(
                        incentive_score >= 0.60
                        and behavioral_burden >= 0.65
                        and units.at[index, "metric_substitution"] >= 0.65
                    ),
                }
            )

    return pd.DataFrame(records)


def main() -> None:
    results = run_simulation()

    period_summary = (
        results.groupby("period")[
            [
                "value_alignment",
                "information_quality",
                "bias_pressure",
                "reporting_distortion",
                "behavioral_burden",
                "short_termism",
                "incentive_score",
                "fairness",
                "legitimacy",
                "learning_support",
                "accountability",
                "metric_substitution",
                "fragile_incentive_system",
                "high_burden_incentive_system",
            ]
        ]
        .mean()
        .reset_index()
    )

    unit_summary = (
        results.groupby("unit_id")[
            [
                "incentive_score",
                "fairness",
                "legitimacy",
                "learning_support",
                "accountability",
                "metric_substitution",
            ]
        ]
        .mean()
        .reset_index()
    )

    results["high_alignment"] = (results["incentive_score"] >= 0.65).astype(int)

    high_rates = (
        results.groupby("period")["high_alignment"]
        .mean()
        .reset_index(name="high_alignment_rate")
    )

    fragile_periods = (
        period_summary[
            (period_summary["incentive_score"] >= 0.60)
            & (period_summary["legitimacy"] < 0.40)
        ]
        .sort_values("incentive_score", ascending=False)
    )

    high_burden_periods = (
        period_summary[
            (period_summary["incentive_score"] >= 0.60)
            & (period_summary["behavioral_burden"] >= 0.65)
            & (period_summary["metric_substitution"] >= 0.65)
        ]
        .sort_values("behavioral_burden", ascending=False)
    )

    results.to_csv(OUTPUT_DIR / "institutional_incentives_behavioral_responses_simulation.csv", index=False)
    period_summary.to_csv(OUTPUT_DIR / "institutional_incentives_period_summary.csv", index=False)
    unit_summary.to_csv(OUTPUT_DIR / "institutional_incentives_unit_summary.csv", index=False)
    high_rates.to_csv(OUTPUT_DIR / "institutional_incentives_high_rates.csv", index=False)
    fragile_periods.to_csv(OUTPUT_DIR / "institutional_incentives_fragile_periods.csv", index=False)
    high_burden_periods.to_csv(OUTPUT_DIR / "institutional_incentives_high_burden_periods.csv", index=False)

    print("Simulation complete.")
    print(period_summary.head())
    print(f"Wrote outputs to {OUTPUT_DIR}")


if __name__ == "__main__":
    main()
