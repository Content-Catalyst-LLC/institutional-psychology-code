"""
Compliance burden review for enforcement systems.

This script summarizes enforcement outcomes by compliance burden band.
"""

from __future__ import annotations

from pathlib import Path
import pandas as pd

from generate_institutional_enforcement_data import generate_data


ROOT = Path(__file__).resolve().parents[1]
OUTPUT_DIR = ROOT / "outputs" / "tables"
OUTPUT_DIR.mkdir(parents=True, exist_ok=True)


def review_compliance_burden(data: pd.DataFrame) -> pd.DataFrame:
    """Summarize enforcement outcomes by compliance-burden band."""
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
            mean_enforcement_effectiveness=("enforcement_effectiveness", "mean"),
            high_compliance_quality_rate=("high_compliance_quality", "mean"),
            high_burden_enforcement_rate=("high_burden_enforcement", "mean"),
            mean_selective_enforcement=("selective_enforcement", "mean"),
            mean_legitimacy=("legitimacy", "mean"),
            mean_evasion_pressure=("evasion_pressure", "mean"),
            mean_accountability_reach=("accountability_reach", "mean"),
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
