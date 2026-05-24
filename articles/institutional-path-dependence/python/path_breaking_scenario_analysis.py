"""
Path-breaking scenario analysis for institutional path dependence.

This script applies different disruption and reform-capacity scenarios to
synthetic institutions to examine how lock-in may weaken under coordinated
change pressure.
"""

from __future__ import annotations

from pathlib import Path
import pandas as pd

from generate_path_dependence_data import generate_data


ROOT = Path(__file__).resolve().parents[1]
OUTPUT_DIR = ROOT / "outputs" / "tables"
OUTPUT_DIR.mkdir(parents=True, exist_ok=True)


def scenario_analysis(data: pd.DataFrame) -> pd.DataFrame:
    """Evaluate lock-in under several path-breaking scenarios."""
    scenarios = [
        {"scenario": "baseline", "disruption_add": 0, "reform_add": 0},
        {"scenario": "moderate_reform_capacity", "disruption_add": 5, "reform_add": 15},
        {"scenario": "high_disruption_low_reform", "disruption_add": 25, "reform_add": 5},
        {"scenario": "high_disruption_high_reform", "disruption_add": 25, "reform_add": 25},
        {"scenario": "coordinated_path_breaking", "disruption_add": 20, "reform_add": 35},
    ]

    rows = []

    for scenario in scenarios:
        scenario_data = data.copy()
        scenario_data["scenario"] = scenario["scenario"]
        scenario_data["scenario_disruption_pressure"] = (
            scenario_data["disruption_pressure"] + scenario["disruption_add"]
        ).clip(0, 100)
        scenario_data["scenario_reform_capacity"] = (
            scenario_data["reform_capacity"] + scenario["reform_add"]
        ).clip(0, 100)

        scenario_data["scenario_path_raw"] = (
            0.08 * scenario_data["initial_conditions"]
            + 0.12 * scenario_data["behavioral_reinforcement"]
            + 0.12 * scenario_data["feedback_strength"]
            + 0.13 * scenario_data["increasing_returns"]
            + 0.11 * scenario_data["coordination_effects"]
            + 0.10 * scenario_data["learning_effects"]
            + 0.12 * scenario_data["legitimacy"]
            + 0.12 * scenario_data["switching_costs"]
            + 0.10 * scenario_data["complementarity"]
            - 0.12 * scenario_data["scenario_disruption_pressure"]
            - 0.05 * scenario_data["scenario_reform_capacity"]
        )

        # Use rank-based rescaling for scenario comparison.
        scenario_data["scenario_score"] = scenario_data["scenario_path_raw"].rank(pct=True) * 100

        rows.append(
            {
                "scenario": scenario["scenario"],
                "mean_path_dependence": scenario_data["scenario_score"].mean(),
                "lock_in_rate": (scenario_data["scenario_score"] >= 60).mean(),
                "strong_lock_in_rate": (scenario_data["scenario_score"] >= 75).mean(),
                "high_burden_lock_in_rate": (
                    (scenario_data["scenario_score"] >= 60)
                    & (scenario_data["distributional_burden"] >= 65)
                ).mean(),
            }
        )

    return pd.DataFrame(rows)


def main() -> None:
    data = generate_data()
    scenarios = scenario_analysis(data)
    output_path = OUTPUT_DIR / "path_breaking_scenario_analysis.csv"
    scenarios.to_csv(output_path, index=False)
    print(scenarios)
    print(f"Wrote {output_path}")


if __name__ == "__main__":
    main()
