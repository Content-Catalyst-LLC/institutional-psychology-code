"""
High-burden coordination review.

This script summarizes high-alignment cases where adaptation burden is high
and distributional attention is low.
"""

from __future__ import annotations

from pathlib import Path
import pandas as pd

from generate_coordination_data import generate_data


ROOT = Path(__file__).resolve().parents[1]
OUTPUT_DIR = ROOT / "outputs" / "tables"
OUTPUT_DIR.mkdir(parents=True, exist_ok=True)


def review_high_burden_coordination(data: pd.DataFrame) -> pd.DataFrame:
    """Summarize coordination outcomes by adaptation-burden band."""
    reviewed = data.copy()
    reviewed["adaptation_burden_band"] = pd.cut(
        reviewed["adaptation_burden"],
        bins=[0, 35, 65, 100],
        labels=["low", "moderate", "high"],
        include_lowest=True,
    )

    summary = (
        reviewed.groupby("adaptation_burden_band", observed=False)
        .agg(
            units=("unit_id", "count"),
            mean_coordination_quality=("coordination_quality", "mean"),
            high_alignment_rate=("high_alignment", "mean"),
            high_burden_coordination_rate=("high_burden_coordination", "mean"),
            mean_distributional_attention=("distributional_attention", "mean"),
            mean_trust=("trust", "mean"),
            mean_authority_signal=("authority_signal", "mean"),
            mean_competing_standards=("competing_standards", "mean"),
        )
        .reset_index()
    )

    return summary


def main() -> None:
    data = generate_data()
    summary = review_high_burden_coordination(data)
    output_path = OUTPUT_DIR / "high_burden_coordination_review.csv"
    summary.to_csv(output_path, index=False)
    print(summary)
    print(f"Wrote {output_path}")


if __name__ == "__main__":
    main()
