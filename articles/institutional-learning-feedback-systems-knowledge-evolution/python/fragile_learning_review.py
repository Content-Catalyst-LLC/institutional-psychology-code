"""
Fragile institutional learning review.

Identify synthetic cases where learning capacity appears strong but communication openness is weak.
"""

from __future__ import annotations

from pathlib import Path
import pandas as pd

from generate_institutional_learning_data import generate_data


ROOT = Path(__file__).resolve().parents[1]
OUTPUT_DIR = ROOT / "outputs" / "tables"
OUTPUT_DIR.mkdir(parents=True, exist_ok=True)


def review_fragile_learning(data: pd.DataFrame) -> pd.DataFrame:
    """Summarize learning outcomes by communication openness band."""
    reviewed = data.copy()
    reviewed["communication_openness_band"] = pd.cut(
        reviewed["communication_openness"],
        bins=[0, 40, 70, 100],
        labels=["low", "moderate", "high"],
        include_lowest=True,
    )

    summary = (
        reviewed.groupby("communication_openness_band", observed=False)
        .agg(
            units=("unit_id", "count"),
            mean_learning_capacity=("learning_capacity", "mean"),
            high_adaptation_rate=("high_adaptation", "mean"),
            fragile_learning_rate=("fragile_learning", "mean"),
            mean_feedback_quality=("feedback_quality", "mean"),
            mean_memory_retention=("memory_retention", "mean"),
            mean_psychological_safety=("psychological_safety", "mean"),
            mean_decision_revisability=("decision_revisability", "mean"),
            mean_signal_distortion=("signal_distortion", "mean"),
            mean_power_protection=("power_protection", "mean"),
        )
        .reset_index()
    )

    return summary


def main() -> None:
    data = generate_data()
    summary = review_fragile_learning(data)
    output_path = OUTPUT_DIR / "fragile_learning_review.csv"
    summary.to_csv(output_path, index=False)
    print(summary)
    print(f"Wrote {output_path}")


if __name__ == "__main__":
    main()
