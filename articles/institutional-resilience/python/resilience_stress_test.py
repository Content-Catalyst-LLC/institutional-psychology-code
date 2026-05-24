"""
Scenario stress test for institutional resilience.

This script applies several shock scenarios to synthetic institutions and
summarizes expected continuity loss.
"""

from __future__ import annotations

from pathlib import Path
import pandas as pd

from generate_institutional_resilience_data import generate_data


ROOT = Path(__file__).resolve().parents[1]
OUTPUT_DIR = ROOT / "outputs" / "tables"
OUTPUT_DIR.mkdir(parents=True, exist_ok=True)


def run_stress_scenarios(data: pd.DataFrame) -> pd.DataFrame:
    """Apply shock scenarios and summarize continuity loss."""
    scenarios = {
        "baseline": 0,
        "moderate_shock": 10,
        "severe_shock": 20,
        "extreme_shock": 35,
    }

    rows = []

    for scenario, shock_addition in scenarios.items():
        scenario_data = data.copy()
        scenario_data["scenario"] = scenario
        scenario_data["scenario_shock_intensity"] = (
            scenario_data["shock_intensity"] + shock_addition
        ).clip(0, 100)

        scenario_data["scenario_continuity_score"] = (
            0.35 * scenario_data["resilience_index"]
            + 0.25 * scenario_data["legitimacy"]
            + 0.20 * scenario_data["trust"]
            + 0.20 * scenario_data["coordination"]
            - 0.30 * scenario_data["scenario_shock_intensity"]
        ).clip(0, 100)

        rows.append(
            {
                "scenario": scenario,
                "mean_continuity": scenario_data["scenario_continuity_score"].mean(),
                "median_continuity": scenario_data["scenario_continuity_score"].median(),
                "failure_rate": (scenario_data["scenario_continuity_score"] < 40).mean(),
                "maintained_core_function_rate": (
                    scenario_data["scenario_continuity_score"] >= 55
                ).mean(),
            }
        )

    return pd.DataFrame(rows)


def main() -> None:
    data = generate_data()
    scenario_summary = run_stress_scenarios(data)
    output_path = OUTPUT_DIR / "institutional_resilience_stress_scenarios.csv"
    scenario_summary.to_csv(output_path, index=False)
    print(scenario_summary)
    print(f"Wrote {output_path}")


if __name__ == "__main__":
    main()
