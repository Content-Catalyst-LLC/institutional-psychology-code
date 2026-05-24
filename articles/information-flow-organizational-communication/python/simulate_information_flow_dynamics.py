"""
Dynamic simulation of information flow and organizational communication.

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


def initialize_units(n_units: int = 260, seed: int = 1414) -> pd.DataFrame:
    """Initialize synthetic institutional communication units."""
    rng = np.random.default_rng(seed)

    return pd.DataFrame(
        {
            "unit_id": np.arange(1, n_units + 1),
            "communication_quality": rng.uniform(0.20, 0.90, n_units),
            "memory_retention": rng.uniform(0.20, 0.90, n_units),
            "openness": rng.uniform(0.20, 0.90, n_units),
            "trust": rng.uniform(0.20, 0.90, n_units),
            "escalation_access": rng.uniform(0.20, 0.90, n_units),
            "distortion_loss": rng.uniform(0.10, 0.90, n_units),
            "overload": rng.uniform(0.10, 0.90, n_units),
            "suppression_pressure": rng.uniform(0.10, 0.90, n_units),
        }
    )


def run_simulation(n_units: int = 260, n_periods: int = 24, seed: int = 1414) -> pd.DataFrame:
    """Run repeated information-flow simulation."""
    rng = np.random.default_rng(seed)
    units = initialize_units(n_units, seed)
    records: list[dict[str, float]] = []

    for period in range(1, n_periods + 1):
        signal_quality = rng.uniform(0.15, 0.95)
        interpretive_integration = rng.uniform(0.15, 0.95)
        feedback_usability = rng.uniform(0.15, 0.95)
        community_voice = rng.uniform(0.15, 0.95)
        digital_transparency = rng.uniform(0.15, 0.95)
        metric_tunnel_vision = rng.uniform(0.05, 0.85)

        for index, row in units.iterrows():
            info_score = (
                0.16 * signal_quality
                + 0.13 * row["communication_quality"]
                + 0.13 * interpretive_integration
                + 0.12 * feedback_usability
                + 0.11 * row["memory_retention"]
                + 0.11 * row["openness"]
                + 0.09 * row["trust"]
                + 0.08 * row["escalation_access"]
                + 0.06 * community_voice
                + 0.05 * digital_transparency
                - 0.12 * row["distortion_loss"]
                - 0.08 * row["overload"]
                - 0.08 * row["suppression_pressure"]
                - 0.06 * metric_tunnel_vision
            )

            info_score = clamp(info_score)

            units.at[index, "communication_quality"] = clamp(
                row["communication_quality"] + 0.020 * (info_score - 0.40)
            )

            units.at[index, "memory_retention"] = clamp(
                row["memory_retention"]
                + 0.018 * (info_score - 0.40)
                + 0.006 * feedback_usability
                - 0.004 * row["overload"]
            )

            units.at[index, "openness"] = clamp(
                row["openness"]
                + 0.018 * (info_score - 0.40)
                - 0.010 * row["suppression_pressure"]
            )

            units.at[index, "trust"] = clamp(
                row["trust"]
                + 0.016 * (info_score - 0.40)
                + 0.006 * row["openness"]
                - 0.008 * row["distortion_loss"]
            )

            units.at[index, "escalation_access"] = clamp(
                row["escalation_access"]
                + 0.015 * (info_score - 0.40)
                + 0.006 * row["trust"]
                - 0.006 * row["suppression_pressure"]
            )

            units.at[index, "distortion_loss"] = clamp(
                row["distortion_loss"]
                - 0.010 * row["communication_quality"]
                - 0.008 * row["openness"]
                + 0.006 * row["suppression_pressure"]
            )

            units.at[index, "overload"] = clamp(
                row["overload"]
                - 0.006 * info_score
                + 0.005 * metric_tunnel_vision
            )

            units.at[index, "suppression_pressure"] = clamp(
                row["suppression_pressure"]
                - 0.007 * row["trust"]
                - 0.006 * row["openness"]
                + 0.005 * metric_tunnel_vision
            )

            records.append(
                {
                    "period": period,
                    "unit_id": row["unit_id"],
                    "signal_quality": signal_quality,
                    "interpretive_integration": interpretive_integration,
                    "feedback_usability": feedback_usability,
                    "community_voice": community_voice,
                    "digital_transparency": digital_transparency,
                    "metric_tunnel_vision": metric_tunnel_vision,
                    "info_score": info_score,
                    "communication_quality": units.at[index, "communication_quality"],
                    "memory_retention": units.at[index, "memory_retention"],
                    "openness": units.at[index, "openness"],
                    "trust": units.at[index, "trust"],
                    "escalation_access": units.at[index, "escalation_access"],
                    "distortion_loss": units.at[index, "distortion_loss"],
                    "overload": units.at[index, "overload"],
                    "suppression_pressure": units.at[index, "suppression_pressure"],
                    "fragile_communication": int(
                        info_score >= 0.60
                        and units.at[index, "openness"] < 0.40
                        and units.at[index, "distortion_loss"] >= 0.65
                    ),
                    "high_overload_system": int(
                        info_score >= 0.60
                        and units.at[index, "overload"] >= 0.70
                        and metric_tunnel_vision >= 0.65
                    ),
                }
            )

    return pd.DataFrame(records)


def main() -> None:
    results = run_simulation()

    period_summary = (
        results.groupby("period")[
            [
                "signal_quality",
                "interpretive_integration",
                "feedback_usability",
                "community_voice",
                "digital_transparency",
                "metric_tunnel_vision",
                "info_score",
                "communication_quality",
                "memory_retention",
                "openness",
                "trust",
                "escalation_access",
                "distortion_loss",
                "overload",
                "suppression_pressure",
                "fragile_communication",
                "high_overload_system",
            ]
        ]
        .mean()
        .reset_index()
    )

    unit_summary = (
        results.groupby("unit_id")[
            [
                "info_score",
                "communication_quality",
                "memory_retention",
                "openness",
                "trust",
                "escalation_access",
                "distortion_loss",
                "overload",
                "suppression_pressure",
            ]
        ]
        .mean()
        .reset_index()
    )

    results["high_information_flow"] = (results["info_score"] >= 0.65).astype(int)

    high_rates = (
        results.groupby("period")["high_information_flow"]
        .mean()
        .reset_index(name="high_information_flow_rate")
    )

    fragile_periods = (
        period_summary[
            (period_summary["info_score"] >= 0.60)
            & (period_summary["openness"] < 0.40)
            & (period_summary["distortion_loss"] >= 0.65)
        ]
        .sort_values("info_score", ascending=False)
    )

    high_overload_periods = (
        period_summary[
            (period_summary["info_score"] >= 0.60)
            & (period_summary["overload"] >= 0.70)
            & (period_summary["metric_tunnel_vision"] >= 0.65)
        ]
        .sort_values("overload", ascending=False)
    )

    results.to_csv(OUTPUT_DIR / "information_flow_organizational_communication_simulation.csv", index=False)
    period_summary.to_csv(OUTPUT_DIR / "information_flow_period_summary.csv", index=False)
    unit_summary.to_csv(OUTPUT_DIR / "information_flow_unit_summary.csv", index=False)
    high_rates.to_csv(OUTPUT_DIR / "information_flow_high_rates.csv", index=False)
    fragile_periods.to_csv(OUTPUT_DIR / "information_flow_fragile_periods.csv", index=False)
    high_overload_periods.to_csv(OUTPUT_DIR / "information_flow_high_overload_periods.csv", index=False)

    print("Simulation complete.")
    print(period_summary.head())
    print(f"Wrote outputs to {OUTPUT_DIR}")


if __name__ == "__main__":
    main()
