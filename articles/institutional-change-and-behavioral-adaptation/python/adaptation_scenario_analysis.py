"""
Adaptation scenario analysis for institutional change.

This script applies several institutional reform scenarios to synthetic data.
"""

from __future__ import annotations

from pathlib import Path
import pandas as pd

from generate_institutional_change_data import generate_data


ROOT = Path(__file__).resolve().parents[1]
OUTPUT_DIR = ROOT / "outputs" / "tables"
OUTPUT_DIR.mkdir(parents=True, exist_ok=True)


def scenario_analysis(data: pd.DataFrame) -> pd.DataFrame:
    """Evaluate adaptation under several reform scenarios."""
    scenarios = [
        {"scenario": "baseline", "feedback_add": 0, "governance_add": 0, "burden_add": 0},
        {"scenario": "better_feedback", "feedback_add": 20, "governance_add": 5, "burden_add": 0},
        {"scenario": "governance_capacity_investment", "feedback_add": 5, "governance_add": 25, "burden_add": -5},
        {"scenario": "rapid_change_high_burden", "feedback_add": 15, "governance_add": 10, "burden_add": 20},
        {"scenario": "coherent_adaptation", "feedback_add": 20, "governance_add": 25, "burden_add": -15},
    ]

    rows = []

    for scenario in scenarios:
        scenario_data = data.copy()
        scenario_data["scenario"] = scenario["scenario"]
        scenario_data["scenario_feedback_quality"] = (
            scenario_data["feedback_quality"] + scenario["feedback_add"]
        ).clip(0, 100)
        scenario_data["scenario_governance_capacity"] = (
            scenario_data["governance_capacity"] + scenario["governance_add"]
        ).clip(0, 100)
        scenario_data["scenario_transition_burden"] = (
            scenario_data["transition_burden"] + scenario["burden_add"]
        ).clip(0, 100)

        scenario_data["scenario_change_raw"] = (
            0.13 * scenario_data["scenario_feedback_quality"]
            + 0.14 * scenario_data["adaptive_capacity"]
            + 0.10 * scenario_data["legitimacy"]
            + 0.10 * scenario_data["incentive_alignment"]
            + 0.09 * scenario_data["normative_support"]
            + 0.12 * scenario_data["scenario_governance_capacity"]
            + 0.10 * scenario_data["behavioral_flexibility"]
            + 0.08 * scenario_data["coordination_quality"]
            + 0.06 * scenario_data["environmental_change"]
            + 0.05 * scenario_data["distributional_attention"]
            - 0.12 * scenario_data["path_dependence"]
            - 0.05 * scenario_data["scenario_transition_burden"]
        )

        scenario_data["scenario_score"] = scenario_data["scenario_change_raw"].rank(pct=True) * 100

        rows.append(
            {
                "scenario": scenario["scenario"],
                "mean_change_score": scenario_data["scenario_score"].mean(),
                "successful_adaptation_rate": (scenario_data["scenario_score"] >= 58).mean(),
                "fragile_adaptation_rate": (
                    (scenario_data["scenario_score"] >= 58)
                    & (scenario_data["legitimacy"] < 45)
                ).mean(),
                "high_transition_burden_rate": (
                    scenario_data["scenario_transition_burden"] >= 65
                ).mean(),
            }
        )

    return pd.DataFrame(rows)


def main() -> None:
    data = generate_data()
    scenarios = scenario_analysis(data)
    output_path = OUTPUT_DIR / "adaptation_scenario_analysis.csv"
    scenarios.to_csv(output_path, index=False)
    print(scenarios)
    print(f"Wrote {output_path}")


if __name__ == "__main__":
    main()
