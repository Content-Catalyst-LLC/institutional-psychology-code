"""
Transition-burden review for institutional adaptation.

This script summarizes how transition burden relates to adaptation outcomes.
"""

from __future__ import annotations

from pathlib import Path
import pandas as pd

from generate_institutional_change_data import generate_data


ROOT = Path(__file__).resolve().parents[1]
OUTPUT_DIR = ROOT / "outputs" / "tables"
OUTPUT_DIR.mkdir(parents=True, exist_ok=True)


def review_transition_burden(data: pd.DataFrame) -> pd.DataFrame:
    """Summarize adaptation outcomes by transition-burden band."""
    reviewed = data.copy()
    reviewed["transition_burden_band"] = pd.cut(
        reviewed["transition_burden"],
        bins=[0, 35, 65, 100],
        labels=["low", "moderate", "high"],
        include_lowest=True,
    )

    summary = (
        reviewed.groupby("transition_burden_band", observed=False)
        .agg(
            institutions=("institution_id", "count"),
            mean_change_score=("change_score", "mean"),
            successful_adaptation_rate=("successful_adaptation", "mean"),
            fragile_adaptation_rate=("fragile_adaptation", "mean"),
            mean_legitimacy=("legitimacy", "mean"),
            mean_coordination_quality=("coordination_quality", "mean"),
            mean_distributional_attention=("distributional_attention", "mean"),
        )
        .reset_index()
    )

    return summary


def main() -> None:
    data = generate_data()
    summary = review_transition_burden(data)
    output_path = OUTPUT_DIR / "transition_burden_review.csv"
    summary.to_csv(output_path, index=False)
    print(summary)
    print(f"Wrote {output_path}")


if __name__ == "__main__":
    main()
