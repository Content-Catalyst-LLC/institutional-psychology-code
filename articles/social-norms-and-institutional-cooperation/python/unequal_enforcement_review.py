"""
Unequal enforcement review for social norm systems.

This script summarizes norm cooperation outcomes by unequal enforcement band.
"""

from __future__ import annotations

from pathlib import Path
import pandas as pd

from generate_social_norms_data import generate_data


ROOT = Path(__file__).resolve().parents[1]
OUTPUT_DIR = ROOT / "outputs" / "tables"
OUTPUT_DIR.mkdir(parents=True, exist_ok=True)


def review_unequal_enforcement(data: pd.DataFrame) -> pd.DataFrame:
    """Summarize norm cooperation outcomes by unequal-enforcement band."""
    reviewed = data.copy()
    reviewed["unequal_enforcement_band"] = pd.cut(
        reviewed["unequal_enforcement"],
        bins=[0, 35, 65, 100],
        labels=["low", "moderate", "high"],
        include_lowest=True,
    )

    summary = (
        reviewed.groupby("unequal_enforcement_band", observed=False)
        .agg(
            units=("unit_id", "count"),
            mean_cooperation_score=("cooperation_score", "mean"),
            high_norm_compliance_rate=("high_norm_compliance", "mean"),
            high_burden_norm_environment_rate=("high_burden_norm_environment", "mean"),
            mean_distributional_attention=("distributional_attention", "mean"),
            mean_trust=("trust", "mean"),
            mean_legitimacy=("legitimacy", "mean"),
            mean_norm_conflict=("norm_conflict", "mean"),
        )
        .reset_index()
    )

    return summary


def main() -> None:
    data = generate_data()
    summary = review_unequal_enforcement(data)
    output_path = OUTPUT_DIR / "unequal_enforcement_review.csv"
    summary.to_csv(output_path, index=False)
    print(summary)
    print(f"Wrote {output_path}")


if __name__ == "__main__":
    main()
