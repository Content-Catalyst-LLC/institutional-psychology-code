"""
High-inertia institutional learning review.

This script summarizes learning outcomes by institutional inertia band.
"""

from __future__ import annotations

from pathlib import Path
import pandas as pd

from generate_institutional_learning_data import generate_data


ROOT = Path(__file__).resolve().parents[1]
OUTPUT_DIR = ROOT / "outputs" / "tables"
OUTPUT_DIR.mkdir(parents=True, exist_ok=True)


def review_high_inertia_learning(data: pd.DataFrame) -> pd.DataFrame:
    """Summarize learning outcomes by institutional-inertia band."""
    reviewed = data.copy()
    reviewed["institutional_inertia_band"] = pd.cut(
        reviewed["institutional_inertia"],
        bins=[0, 35, 65, 100],
        labels=["low", "moderate", "high"],
        include_lowest=True,
    )

    summary = (
        reviewed.groupby("institutional_inertia_band", observed=False)
        .agg(
            units=("unit_id", "count"),
            mean_learning_capacity=("learning_capacity", "mean"),
            high_adaptation_rate=("high_adaptation", "mean"),
            high_inertia_learning_rate=("high_inertia_learning", "mean"),
            mean_signal_distortion=("signal_distortion", "mean"),
            mean_memory_decay=("memory_decay", "mean"),
            mean_defensive_routines=("defensive_routines", "mean"),
            mean_power_protection=("power_protection", "mean"),
            mean_feedback_quality=("feedback_quality", "mean"),
            mean_decision_revisability=("decision_revisability", "mean"),
        )
        .reset_index()
    )

    return summary


def main() -> None:
    data = generate_data()
    summary = review_high_inertia_learning(data)
    output_path = OUTPUT_DIR / "high_inertia_learning_review.csv"
    summary.to_csv(output_path, index=False)
    print(summary)
    print(f"Wrote {output_path}")


if __name__ == "__main__":
    main()
