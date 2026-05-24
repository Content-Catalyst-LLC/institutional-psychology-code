"""
Fragile normative-environment review.

Identify synthetic cases where apparent normative stability is high while
expectation convergence and legitimacy alignment are weak.
"""

from __future__ import annotations

from pathlib import Path
import pandas as pd

from generate_institutional_norms_data import generate_data


ROOT = Path(__file__).resolve().parents[1]
OUTPUT_DIR = ROOT / "outputs" / "tables"
OUTPUT_DIR.mkdir(parents=True, exist_ok=True)


def review_fragile_norms(data: pd.DataFrame) -> pd.DataFrame:
    """Summarize normative outcomes by expectation and legitimacy bands."""
    reviewed = data.copy()
    reviewed["expectation_band"] = pd.cut(
        reviewed["expectation_convergence"],
        bins=[0, 40, 70, 100],
        labels=["low", "moderate", "high"],
        include_lowest=True,
    )
    reviewed["legitimacy_band"] = pd.cut(
        reviewed["legitimacy_alignment"],
        bins=[0, 40, 70, 100],
        labels=["low", "moderate", "high"],
        include_lowest=True,
    )

    summary = (
        reviewed.groupby(["expectation_band", "legitimacy_band"], observed=False)
        .agg(
            units=("unit_id", "count"),
            mean_normative_stability=("normative_stability", "mean"),
            high_coordination_rate=("high_coordination", "mean"),
            fragile_normative_environment_rate=("fragile_normative_environment", "mean"),
            mean_internalization=("internalization", "mean"),
            mean_social_enforcement=("social_enforcement", "mean"),
            mean_trust_reinforcement=("trust_reinforcement", "mean"),
            mean_fragmentation_pressure=("fragmentation_pressure", "mean"),
            mean_unequal_normative_burden=("unequal_normative_burden", "mean"),
            mean_norm_change_readiness=("norm_change_readiness", "mean"),
        )
        .reset_index()
    )

    return summary


def main() -> None:
    data = generate_data()
    summary = review_fragile_norms(data)
    output_path = OUTPUT_DIR / "fragile_normative_environment_review.csv"
    summary.to_csv(output_path, index=False)
    print(summary)
    print(f"Wrote {output_path}")


if __name__ == "__main__":
    main()
