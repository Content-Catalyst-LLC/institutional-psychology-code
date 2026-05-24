"""
Fragile governance review.

Identify synthetic cases where governance appears strong but trust is low.
"""

from __future__ import annotations

from pathlib import Path
import pandas as pd

from generate_behavioral_governance_data import generate_data


ROOT = Path(__file__).resolve().parents[1]
OUTPUT_DIR = ROOT / "outputs" / "tables"
OUTPUT_DIR.mkdir(parents=True, exist_ok=True)


def review_fragile_governance(data: pd.DataFrame) -> pd.DataFrame:
    """Summarize governance outcomes by trust band."""
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
            mean_governance_effectiveness=("governance_effectiveness", "mean"),
            high_governance_rate=("high_governance", "mean"),
            fragile_governance_rate=("fragile_governance", "mean"),
            mean_legitimacy=("legitimacy", "mean"),
            mean_behavioral_burden=("behavioral_burden", "mean"),
            mean_hypocrisy_visibility=("hypocrisy_visibility", "mean"),
            mean_power_asymmetry=("power_asymmetry", "mean"),
        )
        .reset_index()
    )

    return summary


def main() -> None:
    data = generate_data()
    summary = review_fragile_governance(data)
    output_path = OUTPUT_DIR / "fragile_governance_review.csv"
    summary.to_csv(output_path, index=False)
    print(summary)
    print(f"Wrote {output_path}")


if __name__ == "__main__":
    main()
