"""
Dynamic simulation of institutional path dependence and lock-in.

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


def initialize_institutions(n: int = 250, seed: int = 101) -> pd.DataFrame:
    """Initialize synthetic institutions."""
    rng = np.random.default_rng(seed)

    return pd.DataFrame(
        {
            "institution_id": np.arange(1, n + 1),
            "path_strength": rng.uniform(0.30, 0.75, n),
            "increasing_returns": rng.uniform(0.20, 0.95, n),
            "coordination_effects": rng.uniform(0.20, 0.95, n),
            "legitimacy": rng.uniform(0.20, 0.95, n),
            "learning_effects": rng.uniform(0.20, 0.90, n),
            "switching_costs": rng.uniform(0.15, 0.95, n),
            "complementarity": rng.uniform(0.15, 0.95, n),
            "reform_capacity": rng.uniform(0.05, 0.90, n),
            "distributional_burden": rng.uniform(0.05, 0.95, n),
        }
    )


def run_simulation(n_institutions: int = 250, n_periods: int = 24, seed: int = 101) -> pd.DataFrame:
    """Run repeated path-strength simulation."""
    rng = np.random.default_rng(seed)
    institutions = initialize_institutions(n_institutions, seed)
    records: list[dict[str, float]] = []

    for period in range(1, n_periods + 1):
        disruption_pressure = rng.uniform(0.05, 0.70, n_institutions)

        for row_index, row in institutions.iterrows():
            reinforcement = (
                0.20 * row["increasing_returns"]
                + 0.18 * row["coordination_effects"]
                + 0.17 * row["legitimacy"]
                + 0.14 * row["learning_effects"]
                + 0.14 * row["switching_costs"]
                + 0.10 * row["complementarity"]
                - 0.08 * row["reform_capacity"]
            )

            new_path_strength = (
                row["path_strength"]
                + 0.12 * reinforcement * (1 - row["path_strength"])
                - 0.10 * disruption_pressure[row_index]
            )
            new_path_strength = clamp(new_path_strength)
            institutions.at[row_index, "path_strength"] = new_path_strength

            stay_probability = 1 / (
                1
                + np.exp(
                    -(
                        -1.2
                        + 1.8 * row["increasing_returns"]
                        + 1.5 * row["coordination_effects"]
                        + 1.4 * row["legitimacy"]
                        + 1.2 * row["switching_costs"]
                        + 0.9 * row["complementarity"]
                        - 1.6 * disruption_pressure[row_index]
                        - 1.0 * row["reform_capacity"]
                    )
                )
            )

            strong_lock_in = int(new_path_strength >= 0.75)
            high_burden_lock_in = int(
                new_path_strength >= 0.70
                and row["distributional_burden"] >= 0.65
            )

            records.append(
                {
                    "period": period,
                    "institution_id": int(row["institution_id"]),
                    "disruption_pressure": disruption_pressure[row_index],
                    "path_strength": new_path_strength,
                    "stay_probability": stay_probability,
                    "legitimacy": row["legitimacy"],
                    "switching_costs": row["switching_costs"],
                    "increasing_returns": row["increasing_returns"],
                    "coordination_effects": row["coordination_effects"],
                    "learning_effects": row["learning_effects"],
                    "complementarity": row["complementarity"],
                    "reform_capacity": row["reform_capacity"],
                    "distributional_burden": row["distributional_burden"],
                    "strong_lock_in": strong_lock_in,
                    "high_burden_lock_in": high_burden_lock_in,
                }
            )

    return pd.DataFrame(records)


def main() -> None:
    results = run_simulation()

    period_summary = (
        results.groupby("period")[
            [
                "disruption_pressure",
                "path_strength",
                "stay_probability",
                "strong_lock_in",
                "high_burden_lock_in",
            ]
        ]
        .mean()
        .reset_index()
    )

    institution_summary = (
        results.groupby("institution_id")[
            [
                "path_strength",
                "stay_probability",
                "legitimacy",
                "switching_costs",
                "reform_capacity",
                "distributional_burden",
                "high_burden_lock_in",
            ]
        ]
        .mean()
        .reset_index()
        .sort_values("path_strength", ascending=False)
    )

    high_burden_cases = institution_summary[
        institution_summary["high_burden_lock_in"] > 0
    ].sort_values(["high_burden_lock_in", "distributional_burden"], ascending=False)

    results.to_csv(OUTPUT_DIR / "institutional_path_dependence_simulation.csv", index=False)
    period_summary.to_csv(OUTPUT_DIR / "institutional_path_dependence_period_summary.csv", index=False)
    institution_summary.to_csv(OUTPUT_DIR / "institutional_path_dependence_institution_summary.csv", index=False)
    high_burden_cases.to_csv(OUTPUT_DIR / "institutional_path_dependence_high_burden_cases.csv", index=False)

    print("Simulation complete.")
    print(period_summary.head())
    print(f"Wrote outputs to {OUTPUT_DIR}")


if __name__ == "__main__":
    main()
