"""
Dynamic simulation of institutional learning, feedback systems, and knowledge evolution.

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


def initialize_units(n_units: int = 260, seed: int = 1212) -> pd.DataFrame:
    """Initialize synthetic institutional learning units."""
    rng = np.random.default_rng(seed)

    return pd.DataFrame(
        {
            "unit_id": np.arange(1, n_units + 1),
            "memory_retention": rng.uniform(0.20, 0.90, n_units),
            "communication_openness": rng.uniform(0.20, 0.90, n_units),
            "psychological_safety": rng.uniform(0.20, 0.90, n_units),
            "decision_revisability": rng.uniform(0.20, 0.90, n_units),
            "institutional_inertia": rng.uniform(0.10, 0.90, n_units),
            "signal_distortion": rng.uniform(0.10, 0.90, n_units),
            "power_protection": rng.uniform(0.10, 0.90, n_units),
        }
    )


def run_simulation(n_units: int = 260, n_periods: int = 24, seed: int = 1212) -> pd.DataFrame:
    """Run repeated institutional learning simulation."""
    rng = np.random.default_rng(seed)
    units = initialize_units(n_units, seed)
    records: list[dict[str, float]] = []

    for period in range(1, n_periods + 1):
        feedback_quality = rng.uniform(0.15, 0.95)
        interpretive_quality = rng.uniform(0.15, 0.95)
        disconfirming_evidence = rng.uniform(0.05, 0.95)
        feedback_delay = rng.uniform(0.05, 0.85)
        defensive_routines = rng.uniform(0.05, 0.85)

        for index, row in units.iterrows():
            learning_score = (
                0.16 * feedback_quality
                + 0.13 * row["memory_retention"]
                + 0.13 * row["communication_openness"]
                + 0.13 * interpretive_quality
                + 0.13 * row["decision_revisability"]
                + 0.13 * row["psychological_safety"]
                + 0.05 * disconfirming_evidence
                - 0.13 * row["institutional_inertia"]
                - 0.10 * row["signal_distortion"]
                - 0.09 * row["power_protection"]
                - 0.08 * feedback_delay
                - 0.07 * defensive_routines
            )

            learning_score = clamp(learning_score)

            units.at[index, "memory_retention"] = clamp(
                row["memory_retention"]
                + 0.025 * (learning_score - 0.40)
                - 0.010 * feedback_delay
            )

            units.at[index, "communication_openness"] = clamp(
                row["communication_openness"]
                + 0.022 * (learning_score - 0.40)
                - 0.012 * defensive_routines
                - 0.010 * row["power_protection"]
            )

            units.at[index, "psychological_safety"] = clamp(
                row["psychological_safety"]
                + 0.020 * (learning_score - 0.40)
                - 0.015 * defensive_routines
                - 0.012 * row["power_protection"]
            )

            units.at[index, "decision_revisability"] = clamp(
                row["decision_revisability"]
                + 0.018 * (learning_score - 0.40)
                + 0.010 * interpretive_quality
                - 0.012 * row["institutional_inertia"]
            )

            units.at[index, "institutional_inertia"] = clamp(
                row["institutional_inertia"]
                - 0.014 * learning_score
                + 0.008 * defensive_routines
                + 0.006 * row["power_protection"]
            )

            units.at[index, "signal_distortion"] = clamp(
                row["signal_distortion"]
                - 0.012 * row["communication_openness"]
                - 0.010 * row["psychological_safety"]
                + 0.008 * defensive_routines
            )

            units.at[index, "power_protection"] = clamp(
                row["power_protection"]
                - 0.008 * learning_score
                + 0.006 * defensive_routines
            )

            records.append(
                {
                    "period": period,
                    "unit_id": row["unit_id"],
                    "feedback_quality": feedback_quality,
                    "interpretive_quality": interpretive_quality,
                    "disconfirming_evidence": disconfirming_evidence,
                    "feedback_delay": feedback_delay,
                    "defensive_routines": defensive_routines,
                    "learning_score": learning_score,
                    "memory_retention": units.at[index, "memory_retention"],
                    "communication_openness": units.at[index, "communication_openness"],
                    "psychological_safety": units.at[index, "psychological_safety"],
                    "decision_revisability": units.at[index, "decision_revisability"],
                    "institutional_inertia": units.at[index, "institutional_inertia"],
                    "signal_distortion": units.at[index, "signal_distortion"],
                    "power_protection": units.at[index, "power_protection"],
                    "fragile_learning": int(
                        learning_score >= 0.60
                        and units.at[index, "communication_openness"] < 0.40
                    ),
                    "high_inertia_learning": int(
                        learning_score >= 0.60
                        and units.at[index, "institutional_inertia"] >= 0.65
                        and units.at[index, "signal_distortion"] >= 0.65
                    ),
                }
            )

    return pd.DataFrame(records)


def main() -> None:
    results = run_simulation()

    period_summary = (
        results.groupby("period")[
            [
                "feedback_quality",
                "interpretive_quality",
                "disconfirming_evidence",
                "feedback_delay",
                "defensive_routines",
                "learning_score",
                "memory_retention",
                "communication_openness",
                "psychological_safety",
                "decision_revisability",
                "institutional_inertia",
                "signal_distortion",
                "power_protection",
                "fragile_learning",
                "high_inertia_learning",
            ]
        ]
        .mean()
        .reset_index()
    )

    unit_summary = (
        results.groupby("unit_id")[
            [
                "learning_score",
                "memory_retention",
                "communication_openness",
                "psychological_safety",
                "decision_revisability",
                "institutional_inertia",
                "signal_distortion",
                "power_protection",
            ]
        ]
        .mean()
        .reset_index()
    )

    results["high_learning"] = (results["learning_score"] >= 0.65).astype(int)

    high_rates = (
        results.groupby("period")["high_learning"]
        .mean()
        .reset_index(name="high_learning_rate")
    )

    fragile_periods = (
        period_summary[
            (period_summary["learning_score"] >= 0.60)
            & (period_summary["communication_openness"] < 0.40)
        ]
        .sort_values("learning_score", ascending=False)
    )

    high_inertia_periods = (
        period_summary[
            (period_summary["learning_score"] >= 0.60)
            & (period_summary["institutional_inertia"] >= 0.65)
            & (period_summary["signal_distortion"] >= 0.65)
        ]
        .sort_values("institutional_inertia", ascending=False)
    )

    results.to_csv(OUTPUT_DIR / "institutional_learning_feedback_systems_simulation.csv", index=False)
    period_summary.to_csv(OUTPUT_DIR / "institutional_learning_period_summary.csv", index=False)
    unit_summary.to_csv(OUTPUT_DIR / "institutional_learning_unit_summary.csv", index=False)
    high_rates.to_csv(OUTPUT_DIR / "institutional_learning_high_rates.csv", index=False)
    fragile_periods.to_csv(OUTPUT_DIR / "institutional_learning_fragile_periods.csv", index=False)
    high_inertia_periods.to_csv(OUTPUT_DIR / "institutional_learning_high_inertia_periods.csv", index=False)

    print("Simulation complete.")
    print(period_summary.head())
    print(f"Wrote outputs to {OUTPUT_DIR}")


if __name__ == "__main__":
    main()
