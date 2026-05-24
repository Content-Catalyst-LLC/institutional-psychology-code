"""
High-bias environment review.

This script summarizes decision outcomes by institutional bias-pressure band.
"""

from __future__ import annotations

from pathlib import Path
import pandas as pd

from generate_cognitive_bias_data import generate_data


ROOT = Path(__file__).resolve().parents[1]
OUTPUT_DIR = ROOT / "outputs" / "tables"
OUTPUT_DIR.mkdir(parents=True, exist_ok=True)


def review_high_bias_environment(data: pd.DataFrame) -> pd.DataFrame:
    """Summarize decision outcomes by institutional bias-pressure band."""
    reviewed = data.copy()
    reviewed["bias_pressure_band"] = pd.cut(
        reviewed["institutional_bias_pressure"],
        bins=[0, 35, 65, 100],
        labels=["low", "moderate", "high"],
        include_lowest=True,
    )

    summary = (
        reviewed.groupby("bias_pressure_band", observed=False)
        .agg(
            units=("unit_id", "count"),
            mean_decision_quality=("decision_quality", "mean"),
            mean_bias_pressure=("institutional_bias_pressure", "mean"),
            high_resilience_decision_rate=("high_resilience_decision", "mean"),
            high_bias_environment_rate=("high_bias_environment", "mean"),
            mean_corrective_review=("corrective_review", "mean"),
            mean_feedback_openness=("feedback_openness", "mean"),
            mean_dissent_capacity=("dissent_capacity", "mean"),
            mean_power_protection=("power_protection", "mean"),
            mean_metric_tunnel_vision=("metric_tunnel_vision", "mean"),
        )
        .reset_index()
    )

    return summary


def main() -> None:
    data = generate_data()
    summary = review_high_bias_environment(data)
    output_path = OUTPUT_DIR / "high_bias_environment_review.csv"
    summary.to_csv(output_path, index=False)
    print(summary)
    print(f"Wrote {output_path}")


if __name__ == "__main__":
    main()
