"""
Fragile compliance review.

Identify synthetic cases where compliance appears strong but legitimacy is low.
"""

from __future__ import annotations

from pathlib import Path
import pandas as pd

from generate_compliance_rule_following_data import generate_data


ROOT = Path(__file__).resolve().parents[1]
OUTPUT_DIR = ROOT / "outputs" / "tables"
OUTPUT_DIR.mkdir(parents=True, exist_ok=True)


def review_fragile_compliance(data: pd.DataFrame) -> pd.DataFrame:
    """Summarize compliance outcomes by legitimacy band."""
    reviewed = data.copy()
    reviewed["legitimacy_band"] = pd.cut(
        reviewed["legitimacy"],
        bins=[0, 40, 70, 100],
        labels=["low", "moderate", "high"],
        include_lowest=True,
    )

    summary = (
        reviewed.groupby("legitimacy_band", observed=False)
        .agg(
            units=("unit_id", "count"),
            mean_compliance_quality=("compliance_quality", "mean"),
            high_compliance_rate=("high_compliance", "mean"),
            fragile_compliance_rate=("fragile_compliance", "mean"),
            mean_fairness=("fairness", "mean"),
            mean_trust=("trust", "mean"),
            mean_cognitive_clarity=("cognitive_clarity", "mean"),
            mean_compliance_burden=("compliance_burden", "mean"),
            mean_selective_rule_application=("selective_rule_application", "mean"),
        )
        .reset_index()
    )

    return summary


def main() -> None:
    data = generate_data()
    summary = review_fragile_compliance(data)
    output_path = OUTPUT_DIR / "fragile_compliance_review.csv"
    summary.to_csv(output_path, index=False)
    print(summary)
    print(f"Wrote {output_path}")


if __name__ == "__main__":
    main()
