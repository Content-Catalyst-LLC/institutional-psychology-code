"""
Metric-substitution sensitivity analysis for institutional incentive systems.

The goal is to show how incentive effectiveness changes when metric substitution,
reporting distortion, burden, and short-termism are penalized more strongly.
"""

from __future__ import annotations

from pathlib import Path
import pandas as pd

from generate_institutional_incentives_data import generate_data


ROOT = Path(__file__).resolve().parents[1]
OUTPUT_DIR = ROOT / "outputs" / "tables"
OUTPUT_DIR.mkdir(parents=True, exist_ok=True)


def run_sensitivity(data: pd.DataFrame) -> pd.DataFrame:
    """Evaluate incentive effectiveness under different metric substitution penalties."""
    penalties = [0.00, 0.05, 0.10, 0.15, 0.20]
    rows = []

    for penalty in penalties:
        adjusted_score = (
            data["incentive_effectiveness"]
            - penalty * data["metric_substitution"]
            - 0.06 * data["reporting_distortion"]
            - 0.05 * data["behavioral_burden"]
            - 0.04 * data["short_termism"]
            - 0.03 * data["motivation_crowding"]
            + 0.05 * data["value_alignment"]
            + 0.04 * data["information_quality"]
            + 0.04 * data["learning_support"]
        ).clip(0, 100)

        rows.append(
            {
                "metric_substitution_penalty": penalty,
                "mean_adjusted_incentive_effectiveness": adjusted_score.mean(),
                "high_alignment_rate_adjusted": (adjusted_score >= 60).mean(),
                "fragile_incentive_system_rate_adjusted": (
                    (adjusted_score >= 60) & (data["legitimacy"] < 40)
                ).mean(),
                "high_burden_incentive_system_rate_adjusted": (
                    (adjusted_score >= 60)
                    & (data["behavioral_burden"] > 65)
                    & (data["metric_substitution"] > 65)
                ).mean(),
            }
        )

    return pd.DataFrame(rows)


def main() -> None:
    data = generate_data()
    sensitivity = run_sensitivity(data)
    output_path = OUTPUT_DIR / "metric_substitution_sensitivity.csv"
    sensitivity.to_csv(output_path, index=False)
    print(sensitivity)
    print(f"Wrote {output_path}")


if __name__ == "__main__":
    main()
