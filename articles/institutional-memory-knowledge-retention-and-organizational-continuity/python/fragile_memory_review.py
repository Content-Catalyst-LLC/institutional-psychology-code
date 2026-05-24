"""
Fragile institutional memory review.

Identify synthetic cases where memory effectiveness appears strong but
documented retention and tacit transfer are weak.
"""

from __future__ import annotations

from pathlib import Path
import pandas as pd

from generate_institutional_memory_data import generate_data


ROOT = Path(__file__).resolve().parents[1]
OUTPUT_DIR = ROOT / "outputs" / "tables"
OUTPUT_DIR.mkdir(parents=True, exist_ok=True)


def review_fragile_memory(data: pd.DataFrame) -> pd.DataFrame:
    """Summarize memory outcomes by documentation and transfer bands."""
    reviewed = data.copy()
    reviewed["documentation_band"] = pd.cut(
        reviewed["documented_retention"],
        bins=[0, 40, 70, 100],
        labels=["low", "moderate", "high"],
        include_lowest=True,
    )
    reviewed["tacit_transfer_band"] = pd.cut(
        reviewed["tacit_transfer"],
        bins=[0, 40, 70, 100],
        labels=["low", "moderate", "high"],
        include_lowest=True,
    )

    summary = (
        reviewed.groupby(["documentation_band", "tacit_transfer_band"], observed=False)
        .agg(
            units=("unit_id", "count"),
            mean_memory_effectiveness=("memory_effectiveness", "mean"),
            high_resilience_memory_rate=("high_resilience_memory", "mean"),
            fragile_memory_rate=("fragile_memory", "mean"),
            mean_accessibility=("accessibility", "mean"),
            mean_interpretive_use=("interpretive_use", "mean"),
            mean_revisability=("revisability", "mean"),
            mean_loss_fragmentation=("loss_fragmentation", "mean"),
            mean_key_person_dependency=("key_person_dependency", "mean"),
        )
        .reset_index()
    )

    return summary


def main() -> None:
    data = generate_data()
    summary = review_fragile_memory(data)
    output_path = OUTPUT_DIR / "fragile_memory_review.csv"
    summary.to_csv(output_path, index=False)
    print(summary)
    print(f"Wrote {output_path}")


if __name__ == "__main__":
    main()
