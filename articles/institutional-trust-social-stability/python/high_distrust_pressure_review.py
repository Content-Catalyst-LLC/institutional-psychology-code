"""
High-distrust pressure review.

This script summarizes institutional trust outcomes by arbitrariness and
visible violation pressure.
"""

from __future__ import annotations

from pathlib import Path
import pandas as pd

from generate_institutional_trust_data import generate_data


ROOT = Path(__file__).resolve().parents[1]
OUTPUT_DIR = ROOT / "outputs" / "tables"
OUTPUT_DIR.mkdir(parents=True, exist_ok=True)


def review_high_distrust_pressure(data: pd.DataFrame) -> pd.DataFrame:
    """Summarize trust outcomes by arbitrariness pressure band."""
    reviewed = data.copy()
    reviewed["arbitrariness_band"] = pd.cut(
        reviewed["arbitrariness_pressure"],
        bins=[0, 35, 70, 100],
        labels=["low", "moderate", "high"],
        include_lowest=True,
    )

    summary = (
        reviewed.groupby("arbitrariness_band", observed=False)
        .agg(
            units=("unit_id", "count"),
            mean_trust_score=("trust_score", "mean"),
            mean_social_stability=("social_stability", "mean"),
            high_trust_rate=("high_trust", "mean"),
            high_stability_rate=("high_stability", "mean"),
            high_distrust_pressure_rate=("high_distrust_pressure", "mean"),
            mean_visible_violation_pressure=("visible_violation_pressure", "mean"),
            mean_administrative_burden=("administrative_burden", "mean"),
            mean_repair_capacity=("repair_capacity", "mean"),
            mean_fairness=("fairness", "mean"),
            mean_accountability=("accountability", "mean"),
        )
        .reset_index()
    )

    return summary


def main() -> None:
    data = generate_data()
    summary = review_high_distrust_pressure(data)
    output_path = OUTPUT_DIR / "high_distrust_pressure_review.csv"
    summary.to_csv(output_path, index=False)
    print(summary)
    print(f"Wrote {output_path}")


if __name__ == "__main__":
    main()
