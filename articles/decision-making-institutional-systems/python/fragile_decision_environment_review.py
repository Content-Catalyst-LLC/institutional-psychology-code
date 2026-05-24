"""
Fragile decision-environment review.

Identify synthetic cases where apparent decision quality is high while
corrective capacity and information-flow effectiveness are weak.
"""

from __future__ import annotations

from pathlib import Path
import pandas as pd

from generate_decision_quality_data import generate_data


ROOT = Path(__file__).resolve().parents[1]
OUTPUT_DIR = ROOT / "outputs" / "tables"
OUTPUT_DIR.mkdir(parents=True, exist_ok=True)


def review_fragile_decisions(data: pd.DataFrame) -> pd.DataFrame:
    """Summarize decision outcomes by correction and information-flow bands."""
    reviewed = data.copy()
    reviewed["correction_band"] = pd.cut(
        reviewed["corrective_capacity"],
        bins=[0, 40, 70, 100],
        labels=["low", "moderate", "high"],
        include_lowest=True,
    )
    reviewed["information_flow_band"] = pd.cut(
        reviewed["information_flow_effectiveness"],
        bins=[0, 45, 70, 100],
        labels=["low", "moderate", "high"],
        include_lowest=True,
    )

    summary = (
        reviewed.groupby(["correction_band", "information_flow_band"], observed=False)
        .agg(
            units=("unit_id", "count"),
            mean_decision_quality=("decision_quality", "mean"),
            high_quality_decision_rate=("high_quality_decision", "mean"),
            fragile_decision_environment_rate=("fragile_decision_environment", "mean"),
            mean_legitimacy=("legitimacy", "mean"),
            mean_uncertainty_management=("uncertainty_management", "mean"),
            mean_feedback_openness=("feedback_openness", "mean"),
            mean_bias_distortion=("bias_distortion", "mean"),
            mean_power_protection=("power_protection", "mean"),
        )
        .reset_index()
    )

    return summary


def main() -> None:
    data = generate_data()
    summary = review_fragile_decisions(data)
    output_path = OUTPUT_DIR / "fragile_decision_environment_review.csv"
    summary.to_csv(output_path, index=False)
    print(summary)
    print(f"Wrote {output_path}")


if __name__ == "__main__":
    main()
