"""
Dynamic simulation of crisis, legitimacy loss, reform windows, and transformation.

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


def initialize_institutions(n: int = 200, seed: int = 123) -> pd.DataFrame:
    """Initialize synthetic institutions."""
    rng = np.random.default_rng(seed)

    return pd.DataFrame(
        {
            "institution_id": np.arange(1, n + 1),
            "legitimacy": rng.uniform(0.35, 0.95, n),
            "adaptive_capacity": rng.uniform(0.25, 0.90, n),
            "coordination_quality": rng.uniform(0.25, 0.95, n),
            "coalition_strength": rng.uniform(0.10, 0.85, n),
            "governance_alignment": rng.uniform(0.20, 0.90, n),
            "power_concentration": rng.uniform(0.10, 0.95, n),
            "learning_rate": rng.uniform(0.20, 0.90, n),
            "capture_risk": rng.uniform(0.05, 0.85, n),
            "distributional_attention": rng.uniform(0.05, 0.95, n),
        }
    )


def run_simulation(n_institutions: int = 200, n_periods: int = 24, seed: int = 123) -> pd.DataFrame:
    """Run repeated crisis/reform simulation."""
    rng = np.random.default_rng(seed)
    institutions = initialize_institutions(n_institutions, seed)
    records: list[dict[str, float]] = []

    for period in range(1, n_periods + 1):
        shock = rng.uniform(0.10, 0.95, n_institutions)
        feedback_breakdown = rng.uniform(0.05, 0.90, n_institutions)

        for row_index, row in institutions.iterrows():
            legitimacy_loss = 0.20 * shock[row_index] + 0.15 * feedback_breakdown[row_index]
            updated_legitimacy = row["legitimacy"] - legitimacy_loss * 0.08
            institutions.at[row_index, "legitimacy"] = clamp(updated_legitimacy)

            reform_window = (
                0.35 * shock[row_index]
                + 0.25 * feedback_breakdown[row_index]
                + 0.25 * (1 - institutions.at[row_index, "legitimacy"])
                + 0.15 * row["coalition_strength"]
            )
            reform_window = clamp(reform_window)

            transformation_pressure = (
                0.20 * shock[row_index]
                + 0.17 * feedback_breakdown[row_index]
                + 0.18 * (1 - institutions.at[row_index, "legitimacy"])
                + 0.12 * row["adaptive_capacity"]
                + 0.10 * row["coordination_quality"]
                + 0.09 * row["governance_alignment"]
                + 0.08 * row["coalition_strength"]
                + 0.06 * row["distributional_attention"]
                - 0.08 * row["capture_risk"]
            )

            reform_probability = clamp(transformation_pressure)

            updated_adaptive_capacity = (
                row["adaptive_capacity"]
                + 0.03 * row["learning_rate"] * (1 - row["adaptive_capacity"])
            )
            institutions.at[row_index, "adaptive_capacity"] = clamp(updated_adaptive_capacity)

            records.append(
                {
                    "period": period,
                    "institution_id": int(row["institution_id"]),
                    "shock": shock[row_index],
                    "feedback_breakdown": feedback_breakdown[row_index],
                    "legitimacy": institutions.at[row_index, "legitimacy"],
                    "reform_window": reform_window,
                    "transformation_pressure": transformation_pressure,
                    "reform_probability": reform_probability,
                    "adaptive_capacity": institutions.at[row_index, "adaptive_capacity"],
                    "coalition_strength": row["coalition_strength"],
                    "governance_alignment": row["governance_alignment"],
                    "capture_risk": row["capture_risk"],
                    "distributional_attention": row["distributional_attention"],
                    "high_reform_likelihood": int(reform_probability >= 0.65),
                    "capture_warning": int(reform_probability >= 0.65 and row["capture_risk"] >= 0.65),
                }
            )

    return pd.DataFrame(records)


def main() -> None:
    results = run_simulation()

    period_summary = (
        results.groupby("period")[
            [
                "shock",
                "feedback_breakdown",
                "legitimacy",
                "reform_window",
                "reform_probability",
                "high_reform_likelihood",
                "capture_warning",
            ]
        ]
        .mean()
        .reset_index()
    )

    institution_summary = (
        results.groupby("institution_id")[
            [
                "reform_probability",
                "legitimacy",
                "adaptive_capacity",
                "coalition_strength",
                "capture_risk",
                "distributional_attention",
                "high_reform_likelihood",
                "capture_warning",
            ]
        ]
        .mean()
        .reset_index()
        .sort_values("reform_probability", ascending=False)
    )

    capture_warning_cases = results[
        (results["reform_probability"] >= 0.65)
        & (results["capture_risk"] >= 0.65)
    ].sort_values(["period", "reform_probability"], ascending=[True, False])

    results.to_csv(OUTPUT_DIR / "crisis_reform_transformation_simulation.csv", index=False)
    period_summary.to_csv(OUTPUT_DIR / "crisis_reform_period_summary.csv", index=False)
    institution_summary.to_csv(OUTPUT_DIR / "crisis_reform_institution_summary.csv", index=False)
    capture_warning_cases.to_csv(OUTPUT_DIR / "crisis_reform_capture_warning_cases.csv", index=False)

    print("Simulation complete.")
    print(period_summary.head())
    print(f"Wrote outputs to {OUTPUT_DIR}")


if __name__ == "__main__":
    main()
