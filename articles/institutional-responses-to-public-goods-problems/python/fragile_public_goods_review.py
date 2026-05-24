"""
Fragile public goods review.

Identify synthetic cases where public goods provision is high but legitimacy is weak.
"""

from __future__ import annotations

from pathlib import Path
import pandas as pd

from generate_public_goods_data import generate_data


ROOT = Path(__file__).resolve().parents[1]
OUTPUT_DIR = ROOT / "outputs" / "tables"
OUTPUT_DIR.mkdir(parents=True, exist_ok=True)


def review_fragile_public_goods(data: pd.DataFrame) -> pd.DataFrame:
    """Summarize provision by legitimacy band."""
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
            mean_contribution_rate=("contribution_rate", "mean"),
            mean_provision_quality=("provision_quality", "mean"),
            high_provision_rate=("high_provision", "mean"),
            fragile_public_good_rate=("fragile_public_good", "mean"),
            mean_capture_risk=("capture_risk", "mean"),
            mean_distributional_attention=("distributional_attention", "mean"),
        )
        .reset_index()
    )

    return summary


def main() -> None:
    data = generate_data()
    summary = review_fragile_public_goods(data)
    output_path = OUTPUT_DIR / "fragile_public_goods_review.csv"
    summary.to_csv(output_path, index=False)
    print(summary)
    print(f"Wrote {output_path}")


if __name__ == "__main__":
    main()
