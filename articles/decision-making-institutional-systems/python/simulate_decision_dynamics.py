"""
Dynamic simulation of decision-making in institutional systems.

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


def initialize_units(n_units: int = 280, seed: int = 1616) -> pd.DataFrame:
    """Initialize synthetic institutional decision units."""
    rng = np.random.default_rng(seed)

    return pd.DataFrame(
        {
            "unit_id": np.arange(1, n_units + 1),
            "organizational_structure_quality": rng.uniform(0.20, 0.90, n_units),
            "incentive_alignment": rng.uniform(0.20, 0.90, n_units),
            "information_flow_effectiveness": rng.uniform(0.20, 0.90, n_units),
            "legitimacy": rng.uniform(0.20, 0.90, n_units),
            "corrective_capacity": rng.uniform(0.20, 0.90, n_units),
            "justice_voice": rng.uniform(0.20, 0.90, n_units),
            "memory_quality": rng.uniform(0.20, 0.90, n_units),
            "feedback_openness": rng.uniform(0.20, 0.90, n_units),
        }
    )


def run_simulation(n_units: int = 280, n_periods: int = 24, seed: int = 1616) -> pd.DataFrame:
    """Run repeated institutional decision-quality simulation."""
    rng = np.random.default_rng(seed)
    units = initialize_units(n_units, seed)
    records: list[dict[str, float]] = []

    for period in range(1, n_periods + 1):
        bounded_rationality_pressure = rng.uniform(0.10, 0.85)
        uncertainty_management = rng.uniform(0.15, 0.95)
        bias_distortion = rng.uniform(0.10, 0.85)
        power_protection = rng.uniform(0.05, 0.85)
        metric_fixation = rng.uniform(0.05, 0.85)
        siloing = rng.uniform(0.05, 0.85)
        premature_closure = rng.uniform(0.05, 0.85)

        for index, row in units.iterrows():
            decision_score = (
                0.12 * row["organizational_structure_quality"]
                + 0.12 * row["incentive_alignment"]
                + 0.14 * row["information_flow_effectiveness"]
                + 0.12 * row["legitimacy"]
                + 0.13 * uncertainty_management
                + 0.14 * row["corrective_capacity"]
                + 0.09 * row["justice_voice"]
                + 0.08 * row["memory_quality"]
                + 0.08 * row["feedback_openness"]
                - 0.15 * bounded_rationality_pressure
                - 0.11 * bias_distortion
                - 0.09 * power_protection
                - 0.08 * metric_fixation
                - 0.07 * siloing
                - 0.07 * premature_closure
            )

            decision_score = clamp(decision_score)

            units.at[index, "information_flow_effectiveness"] = clamp(
                row["information_flow_effectiveness"]
                + 0.020 * (decision_score - 0.40)
                - 0.006 * siloing
                - 0.006 * bias_distortion
            )

            units.at[index, "legitimacy"] = clamp(
                row["legitimacy"]
                + 0.018 * (decision_score - 0.40)
                + 0.006 * row["justice_voice"]
                - 0.006 * power_protection
            )

            units.at[index, "corrective_capacity"] = clamp(
                row["corrective_capacity"]
                + 0.020 * (decision_score - 0.40)
                + 0.006 * row["feedback_openness"]
                - 0.006 * premature_closure
            )

            units.at[index, "justice_voice"] = clamp(
                row["justice_voice"]
                + 0.015 * (decision_score - 0.40)
                + 0.005 * row["legitimacy"]
                - 0.006 * metric_fixation
            )

            units.at[index, "memory_quality"] = clamp(
                row["memory_quality"]
                + 0.017 * (decision_score - 0.40)
                + 0.006 * row["feedback_openness"]
                - 0.004 * bias_distortion
            )

            units.at[index, "feedback_openness"] = clamp(
                row["feedback_openness"]
                + 0.016 * (decision_score - 0.40)
                - 0.006 * power_protection
                - 0.005 * premature_closure
            )

            units.at[index, "incentive_alignment"] = clamp(
                row["incentive_alignment"]
                + 0.012 * (decision_score - 0.40)
                - 0.005 * metric_fixation
            )

            records.append(
                {
                    "period": period,
                    "unit_id": row["unit_id"],
                    "bounded_rationality_pressure": bounded_rationality_pressure,
                    "uncertainty_management": uncertainty_management,
                    "bias_distortion": bias_distortion,
                    "power_protection": power_protection,
                    "metric_fixation": metric_fixation,
                    "siloing": siloing,
                    "premature_closure": premature_closure,
                    "decision_score": decision_score,
                    "organizational_structure_quality": units.at[index, "organizational_structure_quality"],
                    "incentive_alignment": units.at[index, "incentive_alignment"],
                    "information_flow_effectiveness": units.at[index, "information_flow_effectiveness"],
                    "legitimacy": units.at[index, "legitimacy"],
                    "corrective_capacity": units.at[index, "corrective_capacity"],
                    "justice_voice": units.at[index, "justice_voice"],
                    "memory_quality": units.at[index, "memory_quality"],
                    "feedback_openness": units.at[index, "feedback_openness"],
                    "fragile_decision_environment": int(
                        decision_score >= 0.60
                        and units.at[index, "corrective_capacity"] < 0.40
                        and units.at[index, "information_flow_effectiveness"] < 0.45
                    ),
                    "high_distortion_environment": int(
                        bias_distortion >= 0.70
                        and power_protection >= 0.65
                        and units.at[index, "feedback_openness"] < 0.40
                    ),
                }
            )

    return pd.DataFrame(records)


def main() -> None:
    results = run_simulation()

    period_summary = (
        results.groupby("period")[
            [
                "bounded_rationality_pressure",
                "uncertainty_management",
                "bias_distortion",
                "power_protection",
                "metric_fixation",
                "siloing",
                "premature_closure",
                "decision_score",
                "organizational_structure_quality",
                "incentive_alignment",
                "information_flow_effectiveness",
                "legitimacy",
                "corrective_capacity",
                "justice_voice",
                "memory_quality",
                "feedback_openness",
                "fragile_decision_environment",
                "high_distortion_environment",
            ]
        ]
        .mean()
        .reset_index()
    )

    unit_summary = (
        results.groupby("unit_id")[
            [
                "decision_score",
                "information_flow_effectiveness",
                "legitimacy",
                "corrective_capacity",
                "justice_voice",
                "memory_quality",
                "feedback_openness",
            ]
        ]
        .mean()
        .reset_index()
    )

    results["high_quality_decision"] = (results["decision_score"] >= 0.65).astype(int)

    high_rates = (
        results.groupby("period")["high_quality_decision"]
        .mean()
        .reset_index(name="high_quality_decision_rate")
    )

    fragile_periods = (
        period_summary[
            (period_summary["decision_score"] >= 0.60)
            & (period_summary["corrective_capacity"] < 0.40)
            & (period_summary["information_flow_effectiveness"] < 0.45)
        ]
        .sort_values("decision_score", ascending=False)
    )

    high_distortion_periods = (
        period_summary[
            (period_summary["bias_distortion"] >= 0.70)
            & (period_summary["power_protection"] >= 0.65)
            & (period_summary["feedback_openness"] < 0.40)
        ]
        .sort_values("bias_distortion", ascending=False)
    )

    results.to_csv(OUTPUT_DIR / "decision_making_in_institutional_systems_simulation.csv", index=False)
    period_summary.to_csv(OUTPUT_DIR / "decision_making_period_summary.csv", index=False)
    unit_summary.to_csv(OUTPUT_DIR / "decision_making_unit_summary.csv", index=False)
    high_rates.to_csv(OUTPUT_DIR / "decision_making_high_quality_rates.csv", index=False)
    fragile_periods.to_csv(OUTPUT_DIR / "decision_making_fragile_periods.csv", index=False)
    high_distortion_periods.to_csv(OUTPUT_DIR / "decision_making_high_distortion_periods.csv", index=False)

    print("Simulation complete.")
    print(period_summary.head())
    print(f"Wrote outputs to {OUTPUT_DIR}")


if __name__ == "__main__":
    main()
