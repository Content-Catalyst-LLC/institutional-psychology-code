"""
High-distortion decision-environment review.

This script summarizes decision outcomes by bias distortion and power protection.
"""

from __future__ import annotations

from pathlib import Path
import pandas as pd

from generate_decision_quality_data import generate_data


ROOT = Path(__file__).resolve().parents[1]
OUTPUT_DIR = ROOT / "outputs" / "tables"
OUTPUT_DIR.mkdir(parents=True, exist_ok=True)


def review_high_distortion_environment(data: pd.DataFrame) -> pd.DataFrame:
    """Summarize decision outcomes by distortion band."""
    reviewed = data.copy()
    reviewed["distortion_band"] = pd.cut(
        reviewed["bias_distortion"],
        bins=[0, 35, 70, 100],
        labels=["low", "moderate", "high"],
        include_lowest=True,
    )

    summary = (
        reviewed.groupby("distortion_band", observed=False)
        .agg(
            units=("unit_id", "count"),
            mean_decision_quality=("decision_quality", "mean"),
            high_quality_decision_rate=("high_quality_decision", "mean"),
            high_distortion_environment_rate=("high_distortion_environment", "mean"),
            mean_power_protection=("power_protection", "mean"),
            mean_metric_fixation=("metric_fixation", "mean"),
            mean_feedback_openness=("feedback_openness", "mean"),
            mean_justice_voice=("justice_voice", "mean"),
            mean_legitimacy=("legitimacy", "mean"),
        )
        .reset_index()
    )

    return summary


def main() -> None:
    data = generate_data()
    summary = review_high_distortion_environment(data)
    output_path = OUTPUT_DIR / "high_distortion_environment_review.csv"
    summary.to_csv(output_path, index=False)
    print(summary)
    print(f"Wrote {output_path}")


if __name__ == "__main__":
    main()
