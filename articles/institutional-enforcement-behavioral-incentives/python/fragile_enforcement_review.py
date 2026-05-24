"""
Fragile enforcement review.

Identify synthetic cases where enforcement appears strong but legitimacy is low.
"""

from __future__ import annotations

from pathlib import Path
import pandas as pd

from generate_institutional_enforcement_data import generate_data


ROOT = Path(__file__).resolve().parents[1]
OUTPUT_DIR = ROOT / "outputs" / "tables"
OUTPUT_DIR.mkdir(parents=True, exist_ok=True)


def review_fragile_enforcement(data: pd.DataFrame) -> pd.DataFrame:
    """Summarize enforcement outcomes by legitimacy band."""
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
            mean_enforcement_effectiveness=("enforcement_effectiveness", "mean"),
            high_compliance_quality_rate=("high_compliance_quality", "mean"),
            fragile_enforcement_rate=("fragile_enforcement", "mean"),
            mean_monitoring_quality=("monitoring_quality", "mean"),
            mean_information_quality=("information_quality", "mean"),
            mean_evasion_pressure=("evasion_pressure", "mean"),
            mean_compliance_burden=("compliance_burden", "mean"),
            mean_selective_enforcement=("selective_enforcement", "mean"),
        )
        .reset_index()
    )

    return summary


def main() -> None:
    data = generate_data()
    summary = review_fragile_enforcement(data)
    output_path = OUTPUT_DIR / "fragile_enforcement_review.csv"
    summary.to_csv(output_path, index=False)
    print(summary)
    print(f"Wrote {output_path}")


if __name__ == "__main__":
    main()
