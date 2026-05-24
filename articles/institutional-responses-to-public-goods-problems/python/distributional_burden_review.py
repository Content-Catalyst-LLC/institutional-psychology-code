"""
Distributional burden review for public goods institutions.

This script summarizes provision outcomes by distributional-attention band.
"""

from __future__ import annotations

from pathlib import Path
import pandas as pd

from generate_public_goods_data import generate_data


ROOT = Path(__file__).resolve().parents[1]
OUTPUT_DIR = ROOT / "outputs" / "tables"
OUTPUT_DIR.mkdir(parents=True, exist_ok=True)


def review_distributional_burden(data: pd.DataFrame) -> pd.DataFrame:
    """Summarize public goods outcomes by distributional-attention band."""
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
            units=("unit_id", "count"),
            mean_contribution_rate=("contribution_rate", "mean"),
            mean_provision_quality=("provision_quality", "mean"),
            high_provision_rate=("high_provision", "mean"),
            high_burden_risk_rate=("high_burden_risk", "mean"),
            mean_legitimacy=("legitimacy", "mean"),
            mean_perceived_fairness=("perceived_fairness", "mean"),
            mean_capture_risk=("capture_risk", "mean"),
        )
        .reset_index()
    )

    return summary


def main() -> None:
    data = generate_data()
    summary = review_distributional_burden(data)
    output_path = OUTPUT_DIR / "distributional_burden_review.csv"
    summary.to_csv(output_path, index=False)
    print(summary)
    print(f"Wrote {output_path}")


if __name__ == "__main__":
    main()
