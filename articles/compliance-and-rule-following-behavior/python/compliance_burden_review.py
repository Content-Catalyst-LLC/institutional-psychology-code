"""
Compliance burden review for rule-following systems.

This script summarizes compliance outcomes by compliance burden band.
"""

from __future__ import annotations

from pathlib import Path
import pandas as pd

from generate_compliance_rule_following_data import generate_data


ROOT = Path(__file__).resolve().parents[1]
OUTPUT_DIR = ROOT / "outputs" / "tables"
OUTPUT_DIR.mkdir(parents=True, exist_ok=True)


def review_compliance_burden(data: pd.DataFrame) -> pd.DataFrame:
    """Summarize compliance outcomes by compliance-burden band."""
    reviewed = data.copy()
    reviewed["compliance_burden_band"] = pd.cut(
        reviewed["compliance_burden"],
        bins=[0, 35, 65, 100],
        labels=["low", "moderate", "high"],
        include_lowest=True,
    )

    summary = (
        reviewed.groupby("compliance_burden_band", observed=False)
        .agg(
            units=("unit_id", "count"),
            mean_compliance_quality=("compliance_quality", "mean"),
            high_compliance_rate=("high_compliance", "mean"),
            high_burden_compliance_rate=("high_burden_compliance", "mean"),
            mean_selective_rule_application=("selective_rule_application", "mean"),
            mean_legitimacy=("legitimacy", "mean"),
            mean_fairness=("fairness", "mean"),
            mean_cognitive_clarity=("cognitive_clarity", "mean"),
            mean_trust=("trust", "mean"),
        )
        .reset_index()
    )

    return summary


def main() -> None:
    data = generate_data()
    summary = review_compliance_burden(data)
    output_path = OUTPUT_DIR / "compliance_burden_review.csv"
    summary.to_csv(output_path, index=False)
    print(summary)
    print(f"Wrote {output_path}")


if __name__ == "__main__":
    main()
