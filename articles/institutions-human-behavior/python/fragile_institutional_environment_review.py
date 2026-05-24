"""
Fragile institutional-environment review.

Identify synthetic cases where apparent institutional strength is high while
legitimacy strength and normative stability are weak.
"""

from __future__ import annotations

from pathlib import Path
import pandas as pd

from generate_institutions_behavior_data import generate_data


ROOT = Path(__file__).resolve().parents[1]
OUTPUT_DIR = ROOT / "outputs" / "tables"
OUTPUT_DIR.mkdir(parents=True, exist_ok=True)


def review_fragile_institutions(data: pd.DataFrame) -> pd.DataFrame:
    """Summarize institutional outcomes by legitimacy and normative-stability bands."""
    reviewed = data.copy()
    reviewed["legitimacy_band"] = pd.cut(
        reviewed["legitimacy_strength"],
        bins=[0, 40, 70, 100],
        labels=["low", "moderate", "high"],
        include_lowest=True,
    )
    reviewed["normative_stability_band"] = pd.cut(
        reviewed["normative_stability"],
        bins=[0, 40, 70, 100],
        labels=["low", "moderate", "high"],
        include_lowest=True,
    )

    summary = (
        reviewed.groupby(["legitimacy_band", "normative_stability_band"], observed=False)
        .agg(
            units=("unit_id", "count"),
            mean_institutional_strength=("institutional_strength", "mean"),
            mean_behavioral_alignment=("behavioral_alignment", "mean"),
            high_institutional_alignment_rate=("high_institutional_alignment", "mean"),
            high_behavioral_alignment_rate=("high_behavioral_alignment", "mean"),
            fragile_institutional_environment_rate=("fragile_institutional_environment", "mean"),
            mean_information_quality=("information_quality", "mean"),
            mean_learning_capacity=("learning_capacity", "mean"),
            mean_trust_reinforcement=("trust_reinforcement", "mean"),
            mean_fragmentation_pressure=("fragmentation_pressure", "mean"),
            mean_opacity_pressure=("opacity_pressure", "mean"),
            mean_administrative_burden=("administrative_burden", "mean"),
        )
        .reset_index()
    )

    return summary


def main() -> None:
    data = generate_data()
    summary = review_fragile_institutions(data)
    output_path = OUTPUT_DIR / "fragile_institutional_environment_review.csv"
    summary.to_csv(output_path, index=False)
    print(summary)
    print(f"Wrote {output_path}")


if __name__ == "__main__":
    main()
