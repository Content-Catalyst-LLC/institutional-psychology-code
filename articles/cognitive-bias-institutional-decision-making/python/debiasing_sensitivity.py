"""
Debiasing sensitivity analysis for institutional decision-making.

The goal is to show how decision quality changes when structured dissent,
corrective review, feedback openness, psychological safety, and justice-sensitive
voice are strengthened under different bias-pressure penalties.
"""

from __future__ import annotations

from pathlib import Path
import pandas as pd

from generate_cognitive_bias_data import generate_data


ROOT = Path(__file__).resolve().parents[1]
OUTPUT_DIR = ROOT / "outputs" / "tables"
OUTPUT_DIR.mkdir(parents=True, exist_ok=True)


def run_sensitivity(data: pd.DataFrame) -> pd.DataFrame:
    """Evaluate decision quality under different debiasing strength assumptions."""
    debiasing_strengths = [0.00, 0.05, 0.10, 0.15, 0.20]
    rows = []

    for strength in debiasing_strengths:
        adjusted_score = (
            data["decision_quality"]
            - 0.08 * data["institutional_bias_pressure"]
            - 0.05 * data["filtering_distortion"]
            - 0.05 * data["metric_tunnel_vision"]
            - 0.05 * data["power_protection"]
            + strength * data["dissent_capacity"]
            + strength * data["corrective_review"]
            + 0.04 * data["feedback_openness"]
            + 0.04 * data["psychological_safety"]
            + 0.04 * data["justice_voice"]
        ).clip(0, 100)

        rows.append(
            {
                "debiasing_strength": strength,
                "mean_adjusted_decision_quality": adjusted_score.mean(),
                "high_resilience_decision_rate_adjusted": (adjusted_score >= 60).mean(),
                "fragile_judgment_rate_adjusted": (
                    (adjusted_score >= 60)
                    & (data["dissent_capacity"] < 40)
                    & (data["filtering_distortion"] > 65)
                ).mean(),
                "high_bias_environment_rate_adjusted": (
                    (data["institutional_bias_pressure"] >= 65)
                    & (data["corrective_review"] < 40)
                    & (data["feedback_openness"] < 40)
                ).mean(),
            }
        )

    return pd.DataFrame(rows)


def main() -> None:
    data = generate_data()
    sensitivity = run_sensitivity(data)
    output_path = OUTPUT_DIR / "debiasing_sensitivity.csv"
    sensitivity.to_csv(output_path, index=False)
    print(sensitivity)
    print(f"Wrote {output_path}")


if __name__ == "__main__":
    main()
