"""
Incentive burden review.

This script summarizes incentive outcomes by behavioral burden band.
"""

from __future__ import annotations

from pathlib import Path
import pandas as pd

from generate_institutional_incentives_data import generate_data


ROOT = Path(__file__).resolve().parents[1]
OUTPUT_DIR = ROOT / "outputs" / "tables"
OUTPUT_DIR.mkdir(parents=True, exist_ok=True)


def review_incentive_burden(data: pd.DataFrame) -> pd.DataFrame:
    """Summarize incentive outcomes by behavioral-burden band."""
    reviewed = data.copy()
    reviewed["behavioral_burden_band"] = pd.cut(
        reviewed["behavioral_burden"],
        bins=[0, 35, 65, 100],
        labels=["low", "moderate", "high"],
        include_lowest=True,
    )

    summary = (
        reviewed.groupby("behavioral_burden_band", observed=False)
        .agg(
            units=("unit_id", "count"),
            mean_incentive_effectiveness=("incentive_effectiveness", "mean"),
            high_alignment_rate=("high_alignment", "mean"),
            high_burden_incentive_system_rate=("high_burden_incentive_system", "mean"),
            mean_metric_substitution=("metric_substitution", "mean"),
            mean_reporting_distortion=("reporting_distortion", "mean"),
            mean_legitimacy=("legitimacy", "mean"),
            mean_fairness=("fairness", "mean"),
            mean_accountability=("accountability", "mean"),
        )
        .reset_index()
    )

    return summary


def main() -> None:
    data = generate_data()
    summary = review_incentive_burden(data)
    output_path = OUTPUT_DIR / "incentive_burden_review.csv"
    summary.to_csv(output_path, index=False)
    print(summary)
    print(f"Wrote {output_path}")


if __name__ == "__main__":
    main()
