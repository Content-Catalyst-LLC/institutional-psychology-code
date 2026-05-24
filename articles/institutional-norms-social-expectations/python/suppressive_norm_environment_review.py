"""
Suppressive norm-environment review.

This script summarizes synthetic norm systems where social enforcement is strong
but suppressive pressure is high and learning capacity is weak.
"""

from __future__ import annotations

from pathlib import Path
import pandas as pd

from generate_institutional_norms_data import generate_data


ROOT = Path(__file__).resolve().parents[1]
OUTPUT_DIR = ROOT / "outputs" / "tables"
OUTPUT_DIR.mkdir(parents=True, exist_ok=True)


def review_suppressive_norms(data: pd.DataFrame) -> pd.DataFrame:
    """Summarize outcomes by suppressive pressure band."""
    reviewed = data.copy()
    reviewed["suppressive_pressure_band"] = pd.cut(
        reviewed["suppressive_pressure"],
        bins=[0, 35, 70, 100],
        labels=["low", "moderate", "high"],
        include_lowest=True,
    )

    summary = (
        reviewed.groupby("suppressive_pressure_band", observed=False)
        .agg(
            units=("unit_id", "count"),
            mean_normative_stability=("normative_stability", "mean"),
            high_coordination_rate=("high_coordination", "mean"),
            suppressive_norm_environment_rate=("suppressive_norm_environment", "mean"),
            mean_social_enforcement=("social_enforcement", "mean"),
            mean_learning_capacity=("learning_capacity", "mean"),
            mean_legitimacy_alignment=("legitimacy_alignment", "mean"),
            mean_unequal_normative_burden=("unequal_normative_burden", "mean"),
            mean_fragmentation_pressure=("fragmentation_pressure", "mean"),
            mean_norm_change_readiness=("norm_change_readiness", "mean"),
        )
        .reset_index()
    )

    return summary


def main() -> None:
    data = generate_data()
    summary = review_suppressive_norms(data)
    output_path = OUTPUT_DIR / "suppressive_norm_environment_review.csv"
    summary.to_csv(output_path, index=False)
    print(summary)
    print(f"Wrote {output_path}")


if __name__ == "__main__":
    main()
