"""
Fragile incentive-system review.

Identify synthetic cases where incentive effectiveness appears strong but legitimacy is low.
"""

from __future__ import annotations

from pathlib import Path
import pandas as pd

from generate_institutional_incentives_data import generate_data


ROOT = Path(__file__).resolve().parents[1]
OUTPUT_DIR = ROOT / "outputs" / "tables"
OUTPUT_DIR.mkdir(parents=True, exist_ok=True)


def review_fragile_incentives(data: pd.DataFrame) -> pd.DataFrame:
    """Summarize incentive outcomes by legitimacy band."""
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
            mean_incentive_effectiveness=("incentive_effectiveness", "mean"),
            high_alignment_rate=("high_alignment", "mean"),
            fragile_incentive_system_rate=("fragile_incentive_system", "mean"),
            mean_value_alignment=("value_alignment", "mean"),
            mean_fairness=("fairness", "mean"),
            mean_information_quality=("information_quality", "mean"),
            mean_metric_substitution=("metric_substitution", "mean"),
            mean_reporting_distortion=("reporting_distortion", "mean"),
            mean_behavioral_burden=("behavioral_burden", "mean"),
        )
        .reset_index()
    )

    return summary


def main() -> None:
    data = generate_data()
    summary = review_fragile_incentives(data)
    output_path = OUTPUT_DIR / "fragile_incentive_review.csv"
    summary.to_csv(output_path, index=False)
    print(summary)
    print(f"Wrote {output_path}")


if __name__ == "__main__":
    main()
