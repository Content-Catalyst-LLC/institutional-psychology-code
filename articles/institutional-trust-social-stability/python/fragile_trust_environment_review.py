"""
Fragile trust-environment review.

Identify synthetic cases where apparent trust is high while fairness and
accountability are weak.
"""

from __future__ import annotations

from pathlib import Path
import pandas as pd

from generate_institutional_trust_data import generate_data


ROOT = Path(__file__).resolve().parents[1]
OUTPUT_DIR = ROOT / "outputs" / "tables"
OUTPUT_DIR.mkdir(parents=True, exist_ok=True)


def review_fragile_trust(data: pd.DataFrame) -> pd.DataFrame:
    """Summarize trust outcomes by fairness and accountability bands."""
    reviewed = data.copy()
    reviewed["fairness_band"] = pd.cut(
        reviewed["fairness"],
        bins=[0, 40, 70, 100],
        labels=["low", "moderate", "high"],
        include_lowest=True,
    )
    reviewed["accountability_band"] = pd.cut(
        reviewed["accountability"],
        bins=[0, 40, 70, 100],
        labels=["low", "moderate", "high"],
        include_lowest=True,
    )

    summary = (
        reviewed.groupby(["fairness_band", "accountability_band"], observed=False)
        .agg(
            units=("unit_id", "count"),
            mean_trust_score=("trust_score", "mean"),
            mean_social_stability=("social_stability", "mean"),
            high_trust_rate=("high_trust", "mean"),
            high_stability_rate=("high_stability", "mean"),
            fragile_trust_environment_rate=("fragile_trust_environment", "mean"),
            mean_repair_capacity=("repair_capacity", "mean"),
            mean_recognition_voice=("recognition_voice", "mean"),
            mean_arbitrariness_pressure=("arbitrariness_pressure", "mean"),
            mean_visible_violation_pressure=("visible_violation_pressure", "mean"),
        )
        .reset_index()
    )

    return summary


def main() -> None:
    data = generate_data()
    summary = review_fragile_trust(data)
    output_path = OUTPUT_DIR / "fragile_trust_environment_review.csv"
    summary.to_csv(output_path, index=False)
    print(summary)
    print(f"Wrote {output_path}")


if __name__ == "__main__":
    main()
