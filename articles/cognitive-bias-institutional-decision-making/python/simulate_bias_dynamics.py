"""
Dynamic simulation of cognitive bias in institutional decision-making.

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


def initialize_units(n_units: int = 260, seed: int = 1515) -> pd.DataFrame:
    """Initialize synthetic institutional decision units."""
    rng = np.random.default_rng(seed)

    return pd.DataFrame(
        {
            "unit_id": np.arange(1, n_units + 1),
            "conformity_pressure": rng.uniform(0.10, 0.90, n_units),
            "path_lock_in": rng.uniform(0.10, 0.90, n_units),
            "dissent_capacity": rng.uniform(0.20, 0.90, n_units),
            "corrective_review": rng.uniform(0.20, 0.90, n_units),
            "information_quality": rng.uniform(0.20, 0.90, n_units),
            "psychological_safety": rng.uniform(0.20, 0.90, n_units),
            "justice_voice": rng.uniform(0.20, 0.90, n_units),
        }
    )


def run_simulation(n_units: int = 260, n_periods: int = 24, seed: int = 1515) -> pd.DataFrame:
    """Run repeated institutional bias and decision-quality simulation."""
    rng = np.random.default_rng(seed)
    units = initialize_units(n_units, seed)
    records: list[dict[str, float]] = []

    for period in range(1, n_periods + 1):
        overconfidence = rng.uniform(0.10, 0.85)
        anchoring_pressure = rng.uniform(0.10, 0.85)
        confirmation_pressure = rng.uniform(0.10, 0.85)
        filtering_distortion = rng.uniform(0.10, 0.85)
        feedback_openness = rng.uniform(0.15, 0.95)
        metric_tunnel_vision = rng.uniform(0.05, 0.85)
        power_protection = rng.uniform(0.05, 0.85)

        for index, row in units.iterrows():
            bias_pressure = (
                0.12 * overconfidence
                + 0.10 * anchoring_pressure
                + 0.11 * confirmation_pressure
                + 0.12 * row["conformity_pressure"]
                + 0.13 * filtering_distortion
                + 0.11 * row["path_lock_in"]
                + 0.10 * metric_tunnel_vision
                + 0.09 * power_protection
                - 0.12 * row["dissent_capacity"]
                - 0.11 * row["corrective_review"]
                - 0.10 * row["information_quality"]
                - 0.09 * feedback_openness
                - 0.08 * row["psychological_safety"]
                - 0.07 * row["justice_voice"]
            )

            bias_pressure = clamp(bias_pressure)

            decision_score = (
                0.15 * row["dissent_capacity"]
                + 0.14 * row["corrective_review"]
                + 0.15 * row["information_quality"]
                + 0.13 * feedback_openness
                + 0.11 * row["psychological_safety"]
                + 0.09 * row["justice_voice"]
                - 0.12 * overconfidence
                - 0.11 * anchoring_pressure
                - 0.12 * confirmation_pressure
                - 0.13 * filtering_distortion
                - 0.12 * row["conformity_pressure"]
                - 0.12 * row["path_lock_in"]
                - 0.10 * metric_tunnel_vision
                - 0.09 * power_protection
            )

            decision_score = clamp(decision_score)

            units.at[index, "dissent_capacity"] = clamp(
                row["dissent_capacity"]
                + 0.020 * (decision_score - 0.40)
                + 0.006 * row["psychological_safety"]
                - 0.006 * power_protection
            )

            units.at[index, "corrective_review"] = clamp(
                row["corrective_review"]
                + 0.018 * (decision_score - 0.40)
                + 0.006 * feedback_openness
            )

            units.at[index, "information_quality"] = clamp(
                row["information_quality"]
                + 0.018 * (decision_score - 0.40)
                - 0.006 * filtering_distortion
            )

            units.at[index, "psychological_safety"] = clamp(
                row["psychological_safety"]
                + 0.016 * (decision_score - 0.40)
                - 0.008 * power_protection
                - 0.006 * row["conformity_pressure"]
            )

            units.at[index, "justice_voice"] = clamp(
                row["justice_voice"]
                + 0.014 * (decision_score - 0.40)
                + 0.005 * feedback_openness
                - 0.006 * metric_tunnel_vision
            )

            units.at[index, "path_lock_in"] = clamp(
                row["path_lock_in"]
                - 0.010 * decision_score
                - 0.006 * row["corrective_review"]
                + 0.006 * anchoring_pressure
            )

            units.at[index, "conformity_pressure"] = clamp(
                row["conformity_pressure"]
                - 0.008 * row["dissent_capacity"]
                - 0.006 * row["psychological_safety"]
                + 0.006 * power_protection
            )

            records.append(
                {
                    "period": period,
                    "unit_id": row["unit_id"],
                    "overconfidence": overconfidence,
                    "anchoring_pressure": anchoring_pressure,
                    "confirmation_pressure": confirmation_pressure,
                    "filtering_distortion": filtering_distortion,
                    "feedback_openness": feedback_openness,
                    "metric_tunnel_vision": metric_tunnel_vision,
                    "power_protection": power_protection,
                    "bias_pressure": bias_pressure,
                    "decision_score": decision_score,
                    "conformity_pressure": units.at[index, "conformity_pressure"],
                    "path_lock_in": units.at[index, "path_lock_in"],
                    "dissent_capacity": units.at[index, "dissent_capacity"],
                    "corrective_review": units.at[index, "corrective_review"],
                    "information_quality": units.at[index, "information_quality"],
                    "psychological_safety": units.at[index, "psychological_safety"],
                    "justice_voice": units.at[index, "justice_voice"],
                    "fragile_judgment": int(
                        decision_score >= 0.60
                        and units.at[index, "dissent_capacity"] < 0.40
                        and filtering_distortion >= 0.65
                    ),
                    "high_bias_environment": int(
                        bias_pressure >= 0.65
                        and units.at[index, "corrective_review"] < 0.40
                        and feedback_openness < 0.40
                    ),
                }
            )

    return pd.DataFrame(records)


def main() -> None:
    results = run_simulation()

    period_summary = (
        results.groupby("period")[
            [
                "overconfidence",
                "anchoring_pressure",
                "confirmation_pressure",
                "filtering_distortion",
                "feedback_openness",
                "metric_tunnel_vision",
                "power_protection",
                "bias_pressure",
                "decision_score",
                "conformity_pressure",
                "path_lock_in",
                "dissent_capacity",
                "corrective_review",
                "information_quality",
                "psychological_safety",
                "justice_voice",
                "fragile_judgment",
                "high_bias_environment",
            ]
        ]
        .mean()
        .reset_index()
    )

    unit_summary = (
        results.groupby("unit_id")[
            [
                "decision_score",
                "bias_pressure",
                "path_lock_in",
                "dissent_capacity",
                "corrective_review",
                "information_quality",
                "psychological_safety",
                "justice_voice",
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
            & (period_summary["dissent_capacity"] < 0.40)
            & (period_summary["filtering_distortion"] >= 0.65)
        ]
        .sort_values("decision_score", ascending=False)
    )

    high_bias_periods = (
        period_summary[
            (period_summary["bias_pressure"] >= 0.65)
            & (period_summary["corrective_review"] < 0.40)
            & (period_summary["feedback_openness"] < 0.40)
        ]
        .sort_values("bias_pressure", ascending=False)
    )

    results.to_csv(OUTPUT_DIR / "cognitive_bias_institutional_decision_making_simulation.csv", index=False)
    period_summary.to_csv(OUTPUT_DIR / "cognitive_bias_period_summary.csv", index=False)
    unit_summary.to_csv(OUTPUT_DIR / "cognitive_bias_unit_summary.csv", index=False)
    high_rates.to_csv(OUTPUT_DIR / "cognitive_bias_high_quality_rates.csv", index=False)
    fragile_periods.to_csv(OUTPUT_DIR / "cognitive_bias_fragile_judgment_periods.csv", index=False)
    high_bias_periods.to_csv(OUTPUT_DIR / "cognitive_bias_high_bias_periods.csv", index=False)

    print("Simulation complete.")
    print(period_summary.head())
    print(f"Wrote outputs to {OUTPUT_DIR}")


if __name__ == "__main__":
    main()
