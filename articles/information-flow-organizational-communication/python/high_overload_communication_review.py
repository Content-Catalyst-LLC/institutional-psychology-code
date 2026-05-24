"""
High-overload communication review.

This script summarizes information outcomes by overload band.
"""

from __future__ import annotations

from pathlib import Path
import pandas as pd

from generate_information_flow_data import generate_data


ROOT = Path(__file__).resolve().parents[1]
OUTPUT_DIR = ROOT / "outputs" / "tables"
OUTPUT_DIR.mkdir(parents=True, exist_ok=True)


def review_high_overload_communication(data: pd.DataFrame) -> pd.DataFrame:
    """Summarize information outcomes by overload band."""
    reviewed = data.copy()
    reviewed["overload_band"] = pd.cut(
        reviewed["overload"],
        bins=[0, 35, 70, 100],
        labels=["low", "moderate", "high"],
        include_lowest=True,
    )

    summary = (
        reviewed.groupby("overload_band", observed=False)
        .agg(
            units=("unit_id", "count"),
            mean_information_effectiveness=("information_effectiveness", "mean"),
            high_integration_rate=("high_integration", "mean"),
            high_overload_system_rate=("high_overload_system", "mean"),
            mean_metric_tunnel_vision=("metric_tunnel_vision", "mean"),
            mean_distortion_loss=("distortion_loss", "mean"),
            mean_interpretive_integration=("interpretive_integration", "mean"),
            mean_memory_retention=("memory_retention", "mean"),
            mean_community_voice=("community_voice", "mean"),
        )
        .reset_index()
    )

    return summary


def main() -> None:
    data = generate_data()
    summary = review_high_overload_communication(data)
    output_path = OUTPUT_DIR / "high_overload_communication_review.csv"
    summary.to_csv(output_path, index=False)
    print(summary)
    print(f"Wrote {output_path}")


if __name__ == "__main__":
    main()
