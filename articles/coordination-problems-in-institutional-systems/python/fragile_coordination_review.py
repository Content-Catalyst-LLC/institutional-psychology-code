"""
Fragile coordination review.

Identify synthetic cases where coordination appears high but trust is low.
"""

from __future__ import annotations

from pathlib import Path
import pandas as pd

from generate_coordination_data import generate_data


ROOT = Path(__file__).resolve().parents[1]
OUTPUT_DIR = ROOT / "outputs" / "tables"
OUTPUT_DIR.mkdir(parents=True, exist_ok=True)


def review_fragile_coordination(data: pd.DataFrame) -> pd.DataFrame:
    """Summarize coordination outcomes by trust band."""
    reviewed = data.copy()
    reviewed["trust_band"] = pd.cut(
        reviewed["trust"],
        bins=[0, 40, 70, 100],
        labels=["low", "moderate", "high"],
        include_lowest=True,
    )

    summary = (
        reviewed.groupby("trust_band", observed=False)
        .agg(
            units=("unit_id", "count"),
            mean_coordination_quality=("coordination_quality", "mean"),
            high_alignment_rate=("high_alignment", "mean"),
            fragile_coordination_rate=("fragile_coordination", "mean"),
            mean_uncertainty=("uncertainty", "mean"),
            mean_competing_standards=("competing_standards", "mean"),
            mean_distributional_attention=("distributional_attention", "mean"),
        )
        .reset_index()
    )

    return summary


def main() -> None:
    data = generate_data()
    summary = review_fragile_coordination(data)
    output_path = OUTPUT_DIR / "fragile_coordination_review.csv"
    summary.to_csv(output_path, index=False)
    print(summary)
    print(f"Wrote {output_path}")


if __name__ == "__main__":
    main()
