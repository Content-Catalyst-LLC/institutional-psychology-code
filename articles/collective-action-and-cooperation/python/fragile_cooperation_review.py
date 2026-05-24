"""
Fragile cooperation review.

Identify synthetic cases where cooperation appears high but trust is low.
"""

from __future__ import annotations

from pathlib import Path
import pandas as pd

from generate_collective_action_data import generate_data


ROOT = Path(__file__).resolve().parents[1]
OUTPUT_DIR = ROOT / "outputs" / "tables"
OUTPUT_DIR.mkdir(parents=True, exist_ok=True)


def review_fragile_cooperation(data: pd.DataFrame) -> pd.DataFrame:
    """Summarize cooperation outcomes by trust band."""
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
            high_cooperation_rate=("high_cooperation", "mean"),
            fragile_cooperation_rate=("fragile_cooperation", "mean"),
            mean_free_riding_pressure=("free_riding_pressure", "mean"),
            mean_legitimacy=("legitimacy", "mean"),
            mean_burden_inequality=("burden_inequality", "mean"),
        )
        .reset_index()
    )

    return summary


def main() -> None:
    data = generate_data()
    summary = review_fragile_cooperation(data)
    output_path = OUTPUT_DIR / "fragile_cooperation_review.csv"
    summary.to_csv(output_path, index=False)
    print(summary)
    print(f"Wrote {output_path}")


if __name__ == "__main__":
    main()
