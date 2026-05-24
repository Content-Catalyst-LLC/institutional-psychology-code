"""
Dynamic simulation of institutional norms and social expectations.

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


def initialize_units(n_units: int = 260, seed: int = 1919) -> pd.DataFrame:
    """Initialize synthetic norm-system units."""
    rng = np.random.default_rng(seed)

    return pd.DataFrame(
        {
            "unit_id": np.arange(1, n_units + 1),
            "expectation_convergence": rng.uniform(0.20, 0.90, n_units),
            "internalization": rng.uniform(0.20, 0.90, n_units),
            "social_enforcement": rng.uniform(0.20, 0.90, n_units),
            "legitimacy_alignment": rng.uniform(0.20, 0.90, n_units),
            "trust_reinforcement": rng.uniform(0.20, 0.90, n_units),
            "learning_capacity": rng.uniform(0.20, 0.90, n_units),
        }
    )


def run_simulation(n_units: int = 260, n_periods: int = 24, seed: int = 1919) -> pd.DataFrame:
    """Run repeated institutional norm and expectation simulation."""
    rng = np.random.default_rng(seed)
    units = initialize_units(n_units, seed)
    records: list[dict[str, float]] = []

    for period in range(1, n_periods + 1):
        norm_repetition = rng.uniform(0.15, 0.95)
        fragmentation_pressure = rng.uniform(0.10, 0.85)
        suppressive_pressure = rng.uniform(0.05, 0.85)
        unequal_normative_burden = rng.uniform(0.05, 0.85)
        alternative_norm_visibility = rng.uniform(0.05, 0.85)
        sanction_cost = rng.uniform(0.05, 0.85)
        rigidity_pressure = rng.uniform(0.05, 0.85)

        for index, row in units.iterrows():
            norm_score = (
                0.14 * norm_repetition
                + 0.15 * row["expectation_convergence"]
                + 0.14 * row["internalization"]
                + 0.12 * row["social_enforcement"]
                + 0.14 * row["legitimacy_alignment"]
                + 0.11 * row["trust_reinforcement"]
                + 0.08 * row["learning_capacity"]
                - 0.16 * fragmentation_pressure
                - 0.10 * unequal_normative_burden
                - 0.08 * suppressive_pressure
            )

            norm_score = clamp(norm_score)

            change_readiness = (
                0.18 * alternative_norm_visibility
                + 0.14 * row["learning_capacity"]
                + 0.12 * row["legitimacy_alignment"]
                - 0.15 * sanction_cost
                - 0.12 * rigidity_pressure
                - 0.10 * suppressive_pressure
            )

            change_readiness = clamp(change_readiness)

            units.at[index, "expectation_convergence"] = clamp(
                row["expectation_convergence"]
                + 0.020 * (norm_score - 0.40)
                - 0.006 * fragmentation_pressure
            )

            units.at[index, "internalization"] = clamp(
                row["internalization"]
                + 0.018 * (norm_score - 0.40)
                + 0.004 * row["legitimacy_alignment"]
            )

            units.at[index, "legitimacy_alignment"] = clamp(
                row["legitimacy_alignment"]
                + 0.018 * (norm_score - 0.40)
                - 0.006 * unequal_normative_burden
            )

            units.at[index, "trust_reinforcement"] = clamp(
                row["trust_reinforcement"]
                + 0.018 * (norm_score - 0.40)
                - 0.006 * fragmentation_pressure
            )

            units.at[index, "learning_capacity"] = clamp(
                row["learning_capacity"]
                + 0.016 * (change_readiness - 0.35)
                - 0.006 * suppressive_pressure
            )

            records.append(
                {
                    "period": period,
                    "unit_id": row["unit_id"],
                    "norm_repetition": norm_repetition,
                    "fragmentation_pressure": fragmentation_pressure,
                    "suppressive_pressure": suppressive_pressure,
                    "unequal_normative_burden": unequal_normative_burden,
                    "alternative_norm_visibility": alternative_norm_visibility,
                    "sanction_cost": sanction_cost,
                    "rigidity_pressure": rigidity_pressure,
                    "norm_score": norm_score,
                    "change_readiness": change_readiness,
                    "expectation_convergence": units.at[index, "expectation_convergence"],
                    "internalization": units.at[index, "internalization"],
                    "social_enforcement": units.at[index, "social_enforcement"],
                    "legitimacy_alignment": units.at[index, "legitimacy_alignment"],
                    "trust_reinforcement": units.at[index, "trust_reinforcement"],
                    "learning_capacity": units.at[index, "learning_capacity"],
                    "fragile_normative_environment": int(
                        norm_score >= 0.60
                        and units.at[index, "expectation_convergence"] < 0.40
                        and units.at[index, "legitimacy_alignment"] < 0.40
                    ),
                    "suppressive_norm_environment": int(
                        row["social_enforcement"] >= 0.70
                        and suppressive_pressure >= 0.65
                        and units.at[index, "learning_capacity"] < 0.40
                    ),
                }
            )

    return pd.DataFrame(records)


def main() -> None:
    results = run_simulation()

    period_summary = (
        results.groupby("period")[
            [
                "norm_repetition",
                "fragmentation_pressure",
                "suppressive_pressure",
                "unequal_normative_burden",
                "alternative_norm_visibility",
                "sanction_cost",
                "rigidity_pressure",
                "norm_score",
                "change_readiness",
                "expectation_convergence",
                "internalization",
                "social_enforcement",
                "legitimacy_alignment",
                "trust_reinforcement",
                "learning_capacity",
                "fragile_normative_environment",
                "suppressive_norm_environment",
            ]
        ]
        .mean()
        .reset_index()
    )

    unit_summary = (
        results.groupby("unit_id")[
            [
                "norm_score",
                "change_readiness",
                "expectation_convergence",
                "internalization",
                "legitimacy_alignment",
                "trust_reinforcement",
                "learning_capacity",
            ]
        ]
        .mean()
        .reset_index()
    )

    results["high_normative_stability"] = (results["norm_score"] >= 0.65).astype(int)
    results["high_change_readiness"] = (results["change_readiness"] >= 0.60).astype(int)

    high_stability_rates = (
        results.groupby("period")["high_normative_stability"]
        .mean()
        .reset_index(name="high_normative_stability_rate")
    )

    high_change_rates = (
        results.groupby("period")["high_change_readiness"]
        .mean()
        .reset_index(name="high_change_readiness_rate")
    )

    fragile_periods = (
        period_summary[
            (period_summary["norm_score"] >= 0.60)
            & (period_summary["expectation_convergence"] < 0.40)
            & (period_summary["legitimacy_alignment"] < 0.40)
        ]
        .sort_values("norm_score", ascending=False)
    )

    suppressive_periods = (
        period_summary[
            (period_summary["social_enforcement"] >= 0.70)
            & (period_summary["suppressive_pressure"] >= 0.65)
            & (period_summary["learning_capacity"] < 0.40)
        ]
        .sort_values("suppressive_pressure", ascending=False)
    )

    results.to_csv(OUTPUT_DIR / "institutional_norms_social_expectations_simulation.csv", index=False)
    period_summary.to_csv(OUTPUT_DIR / "institutional_norms_period_summary.csv", index=False)
    unit_summary.to_csv(OUTPUT_DIR / "institutional_norms_unit_summary.csv", index=False)
    high_stability_rates.to_csv(OUTPUT_DIR / "institutional_norms_high_stability_rates.csv", index=False)
    high_change_rates.to_csv(OUTPUT_DIR / "institutional_norms_high_change_readiness_rates.csv", index=False)
    fragile_periods.to_csv(OUTPUT_DIR / "institutional_norms_fragile_periods.csv", index=False)
    suppressive_periods.to_csv(OUTPUT_DIR / "institutional_norms_suppressive_periods.csv", index=False)

    print("Simulation complete.")
    print(period_summary.head())
    print(f"Wrote outputs to {OUTPUT_DIR}")


if __name__ == "__main__":
    main()
