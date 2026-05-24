"""
Behavioral burden review for governance systems.

This script summarizes governance outcomes by behavioral burden band.
"""

from __future__ import annotations

from pathlib import Path
import pandas as pd

from generate_behavioral_governance_data import generate_data


ROOT = Path(__file__).resolve().parents[1]
OUTPUT_DIR = ROOT / "outputs" / "tables"
OUTPUT_DIR.mkdir(parents=True, exist_ok=True)


def review_behavioral_burden(data: pd.DataFrame) -> pd.DataFrame:
    """Summarize governance outcomes by behavioral-burden band."""
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
            mean_governance_effectiveness=("governance_effectiveness", "mean"),
            high_governance_rate=("high_governance", "mean"),
            high_burden_governance_rate=("high_burden_governance", "mean"),
            mean_perceived_fairness=("perceived_fairness", "mean"),
            mean_legitimacy=("legitimacy", "mean"),
            mean_trust=("trust", "mean"),
            mean_power_asymmetry=("power_asymmetry", "mean"),
        )
        .reset_index()
    )

    return summary


def main() -> None:
    data = generate_data()
    summary = review_behavioral_burden(data)
    output_path = OUTPUT_DIR / "behavioral_burden_review.csv"
    summary.to_csv(output_path, index=False)
    print(summary)
    print(f"Wrote {output_path}")


if __name__ == "__main__":
    main()
