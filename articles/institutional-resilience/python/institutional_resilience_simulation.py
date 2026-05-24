"""
Dynamic institutional resilience simulation.

This simulation models repeated institutional shocks and updates trust,
legitimacy, and adaptive capacity over time. It is a synthetic demonstration
for institutional psychology research and should not be used for automated
decisions about real people, organizations, or communities.
"""

from __future__ import annotations

from pathlib import Path
import numpy as np
import pandas as pd


ROOT = Path(__file__).resolve().parents[1]
OUTPUT_DIR = ROOT / "outputs" / "tables"
OUTPUT_DIR.mkdir(parents=True, exist_ok=True)


def clamp(value: float, lower: float = 0.0, upper: float = 1.0) -> float:
    """Clamp a value to a lower and upper bound."""
    return max(lower, min(upper, value))


def compute_resilience(row: pd.Series, shock: float) -> float:
    """Compute institutional resilience under shock."""
    structural_capacity = (
        0.18 * row["robustness"]
        + 0.18 * row["adaptive_capacity"]
        + 0.14 * row["recovery_capacity"]
        + 0.10 * row["transformational_capacity"]
        + 0.10 * row["redundancy"]
        + 0.10 * row["coordination"]
    )

    behavioral_capacity = (
        0.10 * row["legitimacy"]
        + 0.10 * row["trust"]
        + 0.05 * row["feedback_quality"]
        + 0.05 * row["learning_rate"]
    )

    resilience = structural_capacity + behavioral_capacity - 0.20 * shock
    return clamp(resilience)


def initialize_institutions(n: int = 200, seed: int = 42) -> pd.DataFrame:
    """Initialize synthetic institutions."""
    rng = np.random.default_rng(seed)

    return pd.DataFrame(
        {
            "institution_id": np.arange(1, n + 1),
            "robustness": rng.uniform(0.40, 0.95, n),
            "adaptive_capacity": rng.uniform(0.30, 0.95, n),
            "recovery_capacity": rng.uniform(0.35, 0.95, n),
            "transformational_capacity": rng.uniform(0.20, 0.90, n),
            "legitimacy": rng.uniform(0.25, 0.95, n),
            "trust": rng.uniform(0.20, 0.95, n),
            "feedback_quality": rng.uniform(0.15, 0.95, n),
            "learning_rate": rng.uniform(0.20, 0.90, n),
            "redundancy": rng.uniform(0.10, 0.85, n),
            "coordination": rng.uniform(0.20, 0.95, n),
        }
    )


def run_simulation(n_institutions: int = 200, n_periods: int = 24, seed: int = 42) -> pd.DataFrame:
    """Run repeated shock simulation."""
    rng = np.random.default_rng(seed)
    institutions = initialize_institutions(n_institutions, seed)
    records: list[dict[str, float]] = []

    for period in range(1, n_periods + 1):
        period_shock = rng.uniform(0.10, 0.95, n_institutions)

        for row_index, row in institutions.iterrows():
            shock = float(period_shock[row_index])
            resilience = compute_resilience(row, shock)

            continuity = clamp(
                0.50 * resilience
                + 0.20 * row["legitimacy"]
                + 0.15 * row["trust"]
                + 0.15 * row["coordination"]
            )

            trust_update = (
                row["trust"]
                + 0.08 * (continuity - 0.50)
                + 0.04 * row["feedback_quality"]
            )

            legitimacy_update = (
                row["legitimacy"]
                + 0.06 * (continuity - 0.50)
                + 0.03 * row["coordination"]
            )

            adaptive_update = (
                row["adaptive_capacity"]
                + 0.03 * row["learning_rate"] * (1 - row["adaptive_capacity"])
            )

            institutions.at[row_index, "trust"] = clamp(trust_update)
            institutions.at[row_index, "legitimacy"] = clamp(legitimacy_update)
            institutions.at[row_index, "adaptive_capacity"] = clamp(adaptive_update)

            records.append(
                {
                    "period": period,
                    "institution_id": int(row["institution_id"]),
                    "shock": shock,
                    "resilience": resilience,
                    "continuity": continuity,
                    "trust": institutions.at[row_index, "trust"],
                    "legitimacy": institutions.at[row_index, "legitimacy"],
                    "adaptive_capacity": institutions.at[row_index, "adaptive_capacity"],
                    "feedback_quality": row["feedback_quality"],
                    "coordination": row["coordination"],
                    "failure": int(continuity < 0.40),
                }
            )

    return pd.DataFrame(records)


def main() -> None:
    results = run_simulation()

    period_summary = (
        results.groupby("period")[["shock", "resilience", "continuity", "trust", "legitimacy", "failure"]]
        .mean()
        .reset_index()
    )

    institutional_summary = (
        results.groupby("institution_id")[["resilience", "continuity", "trust", "legitimacy", "failure"]]
        .mean()
        .reset_index()
        .sort_values("resilience", ascending=False)
    )

    results.to_csv(OUTPUT_DIR / "institutional_resilience_simulation.csv", index=False)
    period_summary.to_csv(OUTPUT_DIR / "institutional_resilience_period_summary.csv", index=False)
    institutional_summary.to_csv(OUTPUT_DIR / "institutional_resilience_institution_summary.csv", index=False)

    print("Simulation complete.")
    print(period_summary.head())
    print(f"Wrote outputs to {OUTPUT_DIR}")


if __name__ == "__main__":
    main()
