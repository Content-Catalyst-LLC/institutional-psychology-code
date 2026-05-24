"""
Decision architecture sensitivity analysis.

The goal is to show how synthetic decision quality changes when information
flow, corrective capacity, legitimacy, justice voice, memory, and feedback
are strengthened under different bounded-rationality and distortion penalties.
"""

from __future__ import annotations

from pathlib import Path
import pandas as pd

from generate_decision_quality_data import generate_data


ROOT = Path(__file__).resolve().parents[1]
OUTPUT_DIR = ROOT / "outputs" / "tables"
OUTPUT_DIR.mkdir(parents=True, exist_ok=True)


def run_sensitivity(data: pd.DataFrame) -> pd.DataFrame:
    """Evaluate decision quality under different architecture-strength assumptions."""
    architecture_strengths = [0.00, 0.05, 0.10, 0.15, 0.20]
    rows = []

    for strength in architecture_strengths:
        adjusted_score = (
            data["decision_quality"]
            - 0.06 * data["bounded_rationality_pressure"]
            - 0.05 * data["bias_distortion"]
            - 0.05 * data["power_protection"]
            - 0.04 * data["metric_fixation"]
            - 0.04 * data["siloing"]
            - 0.04 * data["premature_closure"]
            + strength * data["information_flow_effectiveness"]
            + strength * data["corrective_capacity"]
            + 0.04 * data["legitimacy"]
            + 0.04 * data["justice_voice"]
            + 0.04 * data["memory_quality"]
            + 0.04 * data["feedback_openness"]
        ).clip(0, 100)

        rows.append(
            {
                "architecture_strength": strength,
                "mean_adjusted_decision_quality": adjusted_score.mean(),
                "high_quality_decision_rate_adjusted": (adjusted_score >= 60).mean(),
                "fragile_decision_environment_rate_adjusted": (
                    (adjusted_score >= 60)
                    & (data["corrective_capacity"] < 40)
                    & (data["information_flow_effectiveness"] < 45)
                ).mean(),
                "high_distortion_environment_rate": data["high_distortion_environment"].mean(),
            }
        )

    return pd.DataFrame(rows)


def main() -> None:
    data = generate_data()
    sensitivity = run_sensitivity(data)
    output_path = OUTPUT_DIR / "decision_architecture_sensitivity.csv"
    sensitivity.to_csv(output_path, index=False)
    print(sensitivity)
    print(f"Wrote {output_path}")


if __name__ == "__main__":
    main()
