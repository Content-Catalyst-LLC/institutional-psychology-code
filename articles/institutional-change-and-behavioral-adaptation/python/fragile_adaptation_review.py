"""
Fragile adaptation review for institutional change.

The goal is to identify synthetic cases where adaptation appears successful
but rests on low legitimacy or high transition burden.
"""

from __future__ import annotations

from pathlib import Path
import pandas as pd

from generate_institutional_change_data import generate_data


ROOT = Path(__file__).resolve().parents[1]
OUTPUT_DIR = ROOT / "outputs" / "tables"
OUTPUT_DIR.mkdir(parents=True, exist_ok=True)


def review_fragile_adaptation(data: pd.DataFrame) -> pd.DataFrame:
    """Summarize fragile adaptation conditions."""
    fragile = data.copy()
    fragile["legitimacy_band"] = pd.cut(
        fragile["legitimacy"],
        bins=[0, 45, 70, 100],
        labels=["low", "moderate", "high"],
        include_lowest=True,
    )

    summary = (
        fragile.groupby("legitimacy_band", observed=False)
        .agg(
            institutions=("institution_id", "count"),
            mean_change_score=("change_score", "mean"),
            successful_adaptation_rate=("successful_adaptation", "mean"),
            fragile_adaptation_rate=("fragile_adaptation", "mean"),
            mean_transition_burden=("transition_burden", "mean"),
            mean_distributional_attention=("distributional_attention", "mean"),
        )
        .reset_index()
    )

    return summary


def main() -> None:
    data = generate_data()
    summary = review_fragile_adaptation(data)
    output_path = OUTPUT_DIR / "fragile_adaptation_review.csv"
    summary.to_csv(output_path, index=False)
    print(summary)
    print(f"Wrote {output_path}")


if __name__ == "__main__":
    main()
