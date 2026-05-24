"""
Dynamic simulation of institutions and human behavior.

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


def initialize_units(n_units: int = 260, seed: int = 2020) -> pd.DataFrame:
    """Initialize synthetic institutional-behavior units."""
    rng = np.random.default_rng(seed)

    return pd.DataFrame(
        {
            "unit_id": np.arange(1, n_units + 1),
            "normative_stability": rng.uniform(0.20, 0.90, n_units),
            "legitimacy_strength": rng.uniform(0.20, 0.90, n_units),
            "information_quality": rng.uniform(0.20, 0.90, n_units),
            "memory_retention": rng.uniform(0.20, 0.90, n_units),
            "learning_capacity": rng.uniform(0.20, 0.90, n_units),
            "trust_reinforcement": rng.uniform(0.20, 0.90, n_units),
            "repair_capacity": rng.uniform(0.20, 0.90, n_units),
            "role_clarity": rng.uniform(0.20, 0.90, n_units),
        }
    )


def run_simulation(n_units: int = 260, n_periods: int = 24, seed: int = 2020) -> pd.DataFrame:
    """Run repeated institutional-behavior simulation."""
    rng = np.random.default_rng(seed)
    units = initialize_units(n_units, seed)
    records: list[dict[str, float]] = []

    for period in range(1, n_periods + 1):
        incentive_alignment = rng.uniform(0.15, 0.95)
        fragmentation_pressure = rng.uniform(0.10, 0.85)
        opacity_pressure = rng.uniform(0.05, 0.85)
        administrative_burden = rng.uniform(0.05, 0.85)
        historical_harm_pressure = rng.uniform(0.05, 0.85)

        for index, row in units.iterrows():
            institution_score = (
                0.14 * row["normative_stability"]
                + 0.15 * row["legitimacy_strength"]
                + 0.11 * incentive_alignment
                + 0.13 * row["information_quality"]
                + 0.12 * row["memory_retention"]
                + 0.13 * row["learning_capacity"]
                + 0.12 * row["trust_reinforcement"]
                + 0.08 * row["repair_capacity"]
                + 0.08 * row["role_clarity"]
                - 0.16 * fragmentation_pressure
                - 0.08 * opacity_pressure
                - 0.08 * administrative_burden
                - 0.07 * historical_harm_pressure
            )

            institution_score = clamp(institution_score)

            behavioral_alignment = (
                0.20 * institution_score
                + 0.14 * row["legitimacy_strength"]
                + 0.12 * row["normative_stability"]
                + 0.12 * row["trust_reinforcement"]
                + 0.10 * row["role_clarity"]
                + 0.08 * incentive_alignment
                - 0.12 * fragmentation_pressure
                - 0.08 * opacity_pressure
                - 0.08 * administrative_burden
            )

            behavioral_alignment = clamp(behavioral_alignment)

            units.at[index, "normative_stability"] = clamp(
                row["normative_stability"] + 0.020 * (institution_score - 0.40)
            )

            units.at[index, "legitimacy_strength"] = clamp(
                row["legitimacy_strength"]
                + 0.020 * (institution_score - 0.40)
                + 0.004 * row["repair_capacity"]
                - 0.006 * fragmentation_pressure
            )

            units.at[index, "information_quality"] = clamp(
                row["information_quality"]
                + 0.016 * (institution_score - 0.40)
                - 0.006 * opacity_pressure
            )

            units.at[index, "memory_retention"] = clamp(
                row["memory_retention"]
                + 0.016 * (institution_score - 0.40)
                + 0.004 * row["learning_capacity"]
            )

            units.at[index, "learning_capacity"] = clamp(
                row["learning_capacity"]
                + 0.018 * (institution_score - 0.40)
                + 0.004 * row["information_quality"]
                - 0.006 * historical_harm_pressure
            )

            units.at[index, "trust_reinforcement"] = clamp(
                row["trust_reinforcement"]
                + 0.018 * (institution_score - 0.40)
                + 0.004 * row["repair_capacity"]
                - 0.006 * administrative_burden
            )

            units.at[index, "repair_capacity"] = clamp(
                row["repair_capacity"]
                + 0.018 * (institution_score - 0.40)
                + 0.004 * row["learning_capacity"]
                - 0.006 * opacity_pressure
            )

            records.append(
                {
                    "period": period,
                    "unit_id": row["unit_id"],
                    "incentive_alignment": incentive_alignment,
                    "fragmentation_pressure": fragmentation_pressure,
                    "opacity_pressure": opacity_pressure,
                    "administrative_burden": administrative_burden,
                    "historical_harm_pressure": historical_harm_pressure,
                    "institution_score": institution_score,
                    "behavioral_alignment": behavioral_alignment,
                    "normative_stability": units.at[index, "normative_stability"],
                    "legitimacy_strength": units.at[index, "legitimacy_strength"],
                    "information_quality": units.at[index, "information_quality"],
                    "memory_retention": units.at[index, "memory_retention"],
                    "learning_capacity": units.at[index, "learning_capacity"],
                    "trust_reinforcement": units.at[index, "trust_reinforcement"],
                    "repair_capacity": units.at[index, "repair_capacity"],
                    "role_clarity": units.at[index, "role_clarity"],
                    "fragile_institutional_environment": int(
                        institution_score >= 0.60
                        and units.at[index, "legitimacy_strength"] < 0.40
                        and units.at[index, "normative_stability"] < 0.40
                    ),
                    "high_fragmentation_environment": int(
                        fragmentation_pressure >= 0.70
                        and opacity_pressure >= 0.65
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
                "incentive_alignment",
                "fragmentation_pressure",
                "opacity_pressure",
                "administrative_burden",
                "historical_harm_pressure",
                "institution_score",
                "behavioral_alignment",
                "normative_stability",
                "legitimacy_strength",
                "information_quality",
                "memory_retention",
                "learning_capacity",
                "trust_reinforcement",
                "repair_capacity",
                "role_clarity",
                "fragile_institutional_environment",
                "high_fragmentation_environment",
            ]
        ]
        .mean()
        .reset_index()
    )

    unit_summary = (
        results.groupby("unit_id")[
            [
                "institution_score",
                "behavioral_alignment",
                "normative_stability",
                "legitimacy_strength",
                "information_quality",
                "memory_retention",
                "learning_capacity",
                "trust_reinforcement",
                "repair_capacity",
            ]
        ]
        .mean()
        .reset_index()
    )

    results["high_institutional_alignment"] = (results["institution_score"] >= 0.65).astype(int)
    results["high_behavioral_alignment"] = (results["behavioral_alignment"] >= 0.65).astype(int)

    high_institutional_rates = (
        results.groupby("period")["high_institutional_alignment"]
        .mean()
        .reset_index(name="high_institutional_alignment_rate")
    )

    high_behavioral_rates = (
        results.groupby("period")["high_behavioral_alignment"]
        .mean()
        .reset_index(name="high_behavioral_alignment_rate")
    )

    fragile_periods = (
        period_summary[
            (period_summary["institution_score"] >= 0.60)
            & (period_summary["legitimacy_strength"] < 0.40)
            & (period_summary["normative_stability"] < 0.40)
        ]
        .sort_values("institution_score", ascending=False)
    )

    fragmentation_periods = (
        period_summary[
            (period_summary["fragmentation_pressure"] >= 0.70)
            & (period_summary["opacity_pressure"] >= 0.65)
            & (period_summary["repair_capacity"] < 0.40)
        ]
        .sort_values("fragmentation_pressure", ascending=False)
    )

    results.to_csv(OUTPUT_DIR / "institutions_and_human_behavior_simulation.csv", index=False)
    period_summary.to_csv(OUTPUT_DIR / "institutions_human_behavior_period_summary.csv", index=False)
    unit_summary.to_csv(OUTPUT_DIR / "institutions_human_behavior_unit_summary.csv", index=False)
    high_institutional_rates.to_csv(OUTPUT_DIR / "institutions_human_behavior_high_institutional_rates.csv", index=False)
    high_behavioral_rates.to_csv(OUTPUT_DIR / "institutions_human_behavior_high_behavioral_rates.csv", index=False)
    fragile_periods.to_csv(OUTPUT_DIR / "institutions_human_behavior_fragile_periods.csv", index=False)
    fragmentation_periods.to_csv(OUTPUT_DIR / "institutions_human_behavior_fragmentation_periods.csv", index=False)

    print("Simulation complete.")
    print(period_summary.head())
    print(f"Wrote outputs to {OUTPUT_DIR}")


if __name__ == "__main__":
    main()
