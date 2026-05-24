"""
High-burden lock-in review for institutional path dependence.

The goal is to show how aggregate stability can hide unequal burdens.
"""

from __future__ import annotations

from pathlib import Path
import pandas as pd

from generate_path_dependence_data import generate_data


ROOT = Path(__file__).resolve().parents[1]
OUTPUT_DIR = ROOT / "outputs" / "tables"
OUTPUT_DIR.mkdir(parents=True, exist_ok=True)


def review_high_burden_lock_in(data: pd.DataFrame) -> pd.DataFrame:
    """Summarize path dependence by distributional-burden band."""
    reviewed = data.copy()
    reviewed["burden_band"] = pd.cut(
        reviewed["distributional_burden"],
        bins=[0, 35, 65, 100],
        labels=["low", "moderate", "high"],
        include_lowest=True,
    )

    summary = (
        reviewed.groupby("burden_band", observed=False)
        .agg(
            institutions=("institution_id", "count"),
            mean_path_dependence=("path_dependence_score", "mean"),
            lock_in_rate=("lock_in", "mean"),
            strong_lock_in_rate=("strong_lock_in", "mean"),
            high_burden_lock_in_rate=("high_burden_lock_in", "mean"),
            mean_legitimacy=("legitimacy", "mean"),
            mean_reform_capacity=("reform_capacity", "mean"),
        )
        .reset_index()
    )

    return summary


def main() -> None:
    data = generate_data()
    summary = review_high_burden_lock_in(data)
    output_path = OUTPUT_DIR / "high_burden_lock_in_review.csv"
    summary.to_csv(output_path, index=False)
    print(summary)
    print(f"Wrote {output_path}")


if __name__ == "__main__":
    main()
