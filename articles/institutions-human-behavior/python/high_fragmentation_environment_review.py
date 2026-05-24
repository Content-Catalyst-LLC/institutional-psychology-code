"""
High-fragmentation environment review.

This script summarizes synthetic institutional environments where fragmentation
and opacity are high while repair capacity is weak.
"""

from __future__ import annotations

from pathlib import Path
import pandas as pd

from generate_institutions_behavior_data import generate_data


ROOT = Path(__file__).resolve().parents[1]
OUTPUT_DIR = ROOT / "outputs" / "tables"
OUTPUT_DIR.mkdir(parents=True, exist_ok=True)


def review_high_fragmentation(data: pd.DataFrame) -> pd.DataFrame:
    """Summarize institutional outcomes by fragmentation band."""
    reviewed = data.copy()
    reviewed["fragmentation_band"] = pd.cut(
        reviewed["fragmentation_pressure"],
        bins=[0, 35, 70, 100],
        labels=["low", "moderate", "high"],
        include_lowest=True,
    )

    summary = (
        reviewed.groupby("fragmentation_band", observed=False)
        .agg(
            units=("unit_id", "count"),
            mean_institutional_strength=("institutional_strength", "mean"),
            mean_behavioral_alignment=("behavioral_alignment", "mean"),
            high_institutional_alignment_rate=("high_institutional_alignment", "mean"),
            high_behavioral_alignment_rate=("high_behavioral_alignment", "mean"),
            high_fragmentation_environment_rate=("high_fragmentation_environment", "mean"),
            mean_opacity_pressure=("opacity_pressure", "mean"),
            mean_administrative_burden=("administrative_burden", "mean"),
            mean_historical_harm_pressure=("historical_harm_pressure", "mean"),
            mean_repair_capacity=("repair_capacity", "mean"),
            mean_legitimacy_strength=("legitimacy_strength", "mean"),
            mean_trust_reinforcement=("trust_reinforcement", "mean"),
        )
        .reset_index()
    )

    return summary


def main() -> None:
    data = generate_data()
    summary = review_high_fragmentation(data)
    output_path = OUTPUT_DIR / "high_fragmentation_environment_review.csv"
    summary.to_csv(output_path, index=False)
    print(summary)
    print(f"Wrote {output_path}")


if __name__ == "__main__":
    main()
