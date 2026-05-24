"""
Distributional review for synthetic crisis reform data.

This script shows how aggregate transformation scores can hide low
distributional attention and high capture risk.
"""

from __future__ import annotations

from pathlib import Path
import pandas as pd

from generate_crisis_reform_data import generate_data


ROOT = Path(__file__).resolve().parents[1]
OUTPUT_DIR = ROOT / "outputs" / "tables"
OUTPUT_DIR.mkdir(parents=True, exist_ok=True)


def review_distributional_attention(data: pd.DataFrame) -> pd.DataFrame:
    """Summarize reform outcomes by distributional-attention band."""
    reviewed = data.copy()
    reviewed["distributional_attention_band"] = pd.cut(
        reviewed["distributional_attention"],
        bins=[0, 35, 65, 100],
        labels=["low", "moderate", "high"],
        include_lowest=True,
    )

    summary = (
        reviewed.groupby("distributional_attention_band", observed=False)
        .agg(
            cases=("case_id", "count"),
            mean_transformation=("transformation_score", "mean"),
            major_reform_rate=("major_reform", "mean"),
            deep_transformation_rate=("deep_transformation", "mean"),
            mean_capture_risk=("capture_risk", "mean"),
            high_capture_risk_rate=("high_capture_risk", "mean"),
        )
        .reset_index()
    )

    return summary


def main() -> None:
    data = generate_data()
    summary = review_distributional_attention(data)
    output_path = OUTPUT_DIR / "distributional_reform_review.csv"
    summary.to_csv(output_path, index=False)
    print(summary)
    print(f"Wrote {output_path}")


if __name__ == "__main__":
    main()
