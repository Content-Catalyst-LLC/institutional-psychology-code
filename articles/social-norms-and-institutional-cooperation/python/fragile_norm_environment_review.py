"""
Fragile norm-environment review.

Identify synthetic cases where norm compliance appears high but trust is low.
"""

from __future__ import annotations

from pathlib import Path
import pandas as pd

from generate_social_norms_data import generate_data


ROOT = Path(__file__).resolve().parents[1]
OUTPUT_DIR = ROOT / "outputs" / "tables"
OUTPUT_DIR.mkdir(parents=True, exist_ok=True)


def review_fragile_norm_environments(data: pd.DataFrame) -> pd.DataFrame:
    """Summarize norm cooperation outcomes by trust band."""
    reviewed = data.copy()
    reviewed["trust_band"] = pd.cut(
        reviewed["trust"],
        bins=[0, 40, 70, 100],
        labels=["low", "moderate", "high"],
        include_lowest=True,
    )

    summary = (
        reviewed.groupby("trust_band", observed=False)
        .agg(
            units=("unit_id", "count"),
            mean_cooperation_score=("cooperation_score", "mean"),
            high_norm_compliance_rate=("high_norm_compliance", "mean"),
            fragile_norm_environment_rate=("fragile_norm_environment", "mean"),
            mean_norm_conflict=("norm_conflict", "mean"),
            mean_hypocrisy_visibility=("hypocrisy_visibility", "mean"),
            mean_unequal_enforcement=("unequal_enforcement", "mean"),
        )
        .reset_index()
    )

    return summary


def main() -> None:
    data = generate_data()
    summary = review_fragile_norm_environments(data)
    output_path = OUTPUT_DIR / "fragile_norm_environment_review.csv"
    summary.to_csv(output_path, index=False)
    print(summary)
    print(f"Wrote {output_path}")


if __name__ == "__main__":
    main()
