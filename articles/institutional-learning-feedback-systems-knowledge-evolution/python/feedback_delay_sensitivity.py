"""
Feedback-delay sensitivity analysis for institutional learning.

The goal is to show how learning capacity changes when feedback delay,
signal distortion, inertia, memory decay, and power protection are penalized
more strongly.
"""

from __future__ import annotations

from pathlib import Path
import pandas as pd

from generate_institutional_learning_data import generate_data


ROOT = Path(__file__).resolve().parents[1]
OUTPUT_DIR = ROOT / "outputs" / "tables"
OUTPUT_DIR.mkdir(parents=True, exist_ok=True)


def run_sensitivity(data: pd.DataFrame) -> pd.DataFrame:
    """Evaluate learning capacity under different feedback-delay penalties."""
    penalties = [0.00, 0.05, 0.10, 0.15, 0.20]
    rows = []

    for penalty in penalties:
        adjusted_score = (
            data["learning_capacity"]
            - penalty * data["feedback_delay"]
            - 0.06 * data["signal_distortion"]
            - 0.05 * data["institutional_inertia"]
            - 0.04 * data["memory_decay"]
            - 0.04 * data["power_protection"]
            + 0.05 * data["feedback_quality"]
            + 0.04 * data["communication_openness"]
            + 0.04 * data["decision_revisability"]
        ).clip(0, 100)

        rows.append(
            {
                "feedback_delay_penalty": penalty,
                "mean_adjusted_learning_capacity": adjusted_score.mean(),
                "high_adaptation_rate_adjusted": (adjusted_score >= 60).mean(),
                "fragile_learning_rate_adjusted": (
                    (adjusted_score >= 60) & (data["communication_openness"] < 40)
                ).mean(),
                "high_inertia_learning_rate_adjusted": (
                    (adjusted_score >= 60)
                    & (data["institutional_inertia"] > 65)
                    & (data["signal_distortion"] > 65)
                ).mean(),
            }
        )

    return pd.DataFrame(rows)


def main() -> None:
    data = generate_data()
    sensitivity = run_sensitivity(data)
    output_path = OUTPUT_DIR / "feedback_delay_sensitivity.csv"
    sensitivity.to_csv(output_path, index=False)
    print(sensitivity)
    print(f"Wrote {output_path}")


if __name__ == "__main__":
    main()
