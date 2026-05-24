"""
Dynamic simulation of institutional change and behavioral adaptation.

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
    """Keep a value inside a defined interval."""
    return max(lower, min(upper, value))


def initialize_institutions(n: int = 220, seed: int = 202) -> pd.DataFrame:
    """Initialize synthetic institutions."""
    rng = np.random.default_rng(seed)

    return pd.DataFrame(
        {
            "institution_id": np.arange(1, n + 1),
            "institutional_strength": rng.uniform(0.35, 0.85, n),
            "feedback_quality": rng.uniform(0.20, 0.95, n),
            "adaptive_capacity": rng.uniform(0.20, 0.90, n),
            "legitimacy": rng.uniform(0.20, 0.95, n),
            "governance_capacity": rng.uniform(0.20, 0.95, n),
            "path_dependence": rng.uniform(0.20, 0.90, n),
            "behavioral_flexibility": rng.uniform(0.15, 0.90, n),
            "coordination_quality": rng.uniform(0.20, 0.95, n),
            "distributional_attention": rng.uniform(0.05, 0.95, n),
            "transition_burden": rng.uniform(0.05, 0.95, n),
        }
    )


def run_simulation(n_institutions: int = 220, n_periods: int = 24, seed: int = 202) -> pd.DataFrame:
    """Run repeated institutional adaptation simulation."""
    rng = np.random.default_rng(seed)
    institutions = initialize_institutions(n_institutions, seed)
    records: list[dict[str, float]] = []

    for period in range(1, n_periods + 1):
        environmental_change = rng.uniform(0.05, 0.85, n_institutions)

        for row_index, row in institutions.iterrows():
            adaptation_pressure = (
                0.20 * environmental_change[row_index]
                + 0.18 * row["feedback_quality"]
                + 0.16 * row["adaptive_capacity"]
                + 0.12 * row["behavioral_flexibility"]
                + 0.10 * row["governance_capacity"]
                + 0.08 * row["legitimacy"]
                + 0.06 * row["coordination_quality"]
                + 0.05 * row["distributional_attention"]
                - 0.18 * row["path_dependence"]
                - 0.06 * row["transition_burden"]
            )

            adaptation_pressure = clamp(adaptation_pressure)
            institutional_change = 0.10 * adaptation_pressure

            institutions.at[row_index, "institutional_strength"] = clamp(
                row["institutional_strength"]
                + institutional_change
                - 0.04 * environmental_change[row_index]
            )

            legitimacy_update = row["legitimacy"] + 0.05 * (adaptation_pressure - 0.40)
            institutions.at[row_index, "legitimacy"] = clamp(legitimacy_update)

            path_update = row["path_dependence"] - 0.03 * adaptation_pressure
            institutions.at[row_index, "path_dependence"] = clamp(path_update)

            transition_update = (
                row["transition_burden"]
                + 0.03 * adaptation_pressure
                - 0.04 * row["coordination_quality"]
            )
            institutions.at[row_index, "transition_burden"] = clamp(transition_update)

            high_change = int(adaptation_pressure >= 0.60)
            fragile_adaptation = int(
                adaptation_pressure >= 0.60
                and institutions.at[row_index, "legitimacy"] < 0.40
            )

            records.append(
                {
                    "period": period,
                    "institution_id": int(row["institution_id"]),
                    "environmental_change": environmental_change[row_index],
                    "adaptation_pressure": adaptation_pressure,
                    "institutional_strength": institutions.at[row_index, "institutional_strength"],
                    "legitimacy": institutions.at[row_index, "legitimacy"],
                    "path_dependence": institutions.at[row_index, "path_dependence"],
                    "transition_burden": institutions.at[row_index, "transition_burden"],
                    "coordination_quality": row["coordination_quality"],
                    "distributional_attention": row["distributional_attention"],
                    "high_change": high_change,
                    "fragile_adaptation": fragile_adaptation,
                }
            )

    return pd.DataFrame(records)


def main() -> None:
    results = run_simulation()

    period_summary = (
        results.groupby("period")[
            [
                "environmental_change",
                "adaptation_pressure",
                "institutional_strength",
                "legitimacy",
                "path_dependence",
                "transition_burden",
                "high_change",
                "fragile_adaptation",
            ]
        ]
        .mean()
        .reset_index()
    )

    institution_summary = (
        results.groupby("institution_id")[
            [
                "adaptation_pressure",
                "institutional_strength",
                "legitimacy",
                "path_dependence",
                "transition_burden",
                "high_change",
                "fragile_adaptation",
            ]
        ]
        .mean()
        .reset_index()
        .sort_values("adaptation_pressure", ascending=False)
    )

    fragile_cases = institution_summary[
        institution_summary["fragile_adaptation"] > 0
    ].sort_values(["fragile_adaptation", "legitimacy"], ascending=[False, True])

    results.to_csv(OUTPUT_DIR / "institutional_change_behavioral_adaptation_simulation.csv", index=False)
    period_summary.to_csv(OUTPUT_DIR / "institutional_change_period_summary.csv", index=False)
    institution_summary.to_csv(OUTPUT_DIR / "institutional_change_institution_summary.csv", index=False)
    fragile_cases.to_csv(OUTPUT_DIR / "institutional_change_fragile_adaptation_cases.csv", index=False)

    print("Simulation complete.")
    print(period_summary.head())
    print(f"Wrote outputs to {OUTPUT_DIR}")


if __name__ == "__main__":
    main()
