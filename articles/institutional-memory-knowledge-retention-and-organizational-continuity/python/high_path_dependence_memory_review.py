"""
High path-dependence institutional memory review.

This script summarizes memory outcomes by path-dependence pressure band.
"""

from __future__ import annotations

from pathlib import Path
import pandas as pd

from generate_institutional_memory_data import generate_data


ROOT = Path(__file__).resolve().parents[1]
OUTPUT_DIR = ROOT / "outputs" / "tables"
OUTPUT_DIR.mkdir(parents=True, exist_ok=True)


def review_high_path_dependence_memory(data: pd.DataFrame) -> pd.DataFrame:
    """Summarize memory outcomes by path-dependence pressure band."""
    reviewed = data.copy()
    reviewed["path_dependence_band"] = pd.cut(
        reviewed["path_dependence_pressure"],
        bins=[0, 35, 65, 100],
        labels=["low", "moderate", "high"],
        include_lowest=True,
    )

    summary = (
        reviewed.groupby("path_dependence_band", observed=False)
        .agg(
            units=("unit_id", "count"),
            mean_memory_effectiveness=("memory_effectiveness", "mean"),
            high_resilience_memory_rate=("high_resilience_memory", "mean"),
            high_path_dependence_memory_rate=("high_path_dependence_memory", "mean"),
            mean_revisability=("revisability", "mean"),
            mean_selective_narration=("selective_narration", "mean"),
            mean_memory_justice=("memory_justice", "mean"),
            mean_distributed_integration=("distributed_integration", "mean"),
            mean_loss_fragmentation=("loss_fragmentation", "mean"),
        )
        .reset_index()
    )

    return summary


def main() -> None:
    data = generate_data()
    summary = review_high_path_dependence_memory(data)
    output_path = OUTPUT_DIR / "high_path_dependence_memory_review.csv"
    summary.to_csv(output_path, index=False)
    print(summary)
    print(f"Wrote {output_path}")


if __name__ == "__main__":
    main()
