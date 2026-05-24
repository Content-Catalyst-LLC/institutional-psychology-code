"""
High-arbitrariness environment review.

This script summarizes legitimacy outcomes by arbitrariness and visible
inconsistency pressure.
"""

from __future__ import annotations

from pathlib import Path
import pandas as pd

from generate_authority_legitimacy_data import generate_data


ROOT = Path(__file__).resolve().parents[1]
OUTPUT_DIR = ROOT / "outputs" / "tables"
OUTPUT_DIR.mkdir(parents=True, exist_ok=True)


def review_high_arbitrariness(data: pd.DataFrame) -> pd.DataFrame:
    """Summarize legitimacy outcomes by arbitrariness band."""
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
            mean_authority_legitimacy_strength=("authority_legitimacy_strength", "mean"),
            mean_voluntary_compliance=("voluntary_compliance", "mean"),
            high_legitimacy_rate=("high_legitimacy", "mean"),
            high_voluntary_compliance_rate=("high_voluntary_compliance", "mean"),
            high_arbitrariness_environment_rate=("high_arbitrariness_environment", "mean"),
            mean_visible_inconsistency=("visible_inconsistency", "mean"),
            mean_unequal_burden=("unequal_burden", "mean"),
            mean_opacity_pressure=("opacity_pressure", "mean"),
            mean_repair_capacity=("repair_capacity", "mean"),
            mean_procedural_legitimacy=("procedural_legitimacy", "mean"),
            mean_trust=("trust", "mean"),
        )
        .reset_index()
    )

    return summary


def main() -> None:
    data = generate_data()
    summary = review_high_arbitrariness(data)
    output_path = OUTPUT_DIR / "high_arbitrariness_environment_review.csv"
    summary.to_csv(output_path, index=False)
    print(summary)
    print(f"Wrote {output_path}")


if __name__ == "__main__":
    main()
