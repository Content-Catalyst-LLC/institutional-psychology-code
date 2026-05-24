"""
Fragile communication review.

Identify synthetic cases where information effectiveness appears strong but
openness is low and distortion loss is high.
"""

from __future__ import annotations

from pathlib import Path
import pandas as pd

from generate_information_flow_data import generate_data


ROOT = Path(__file__).resolve().parents[1]
OUTPUT_DIR = ROOT / "outputs" / "tables"
OUTPUT_DIR.mkdir(parents=True, exist_ok=True)


def review_fragile_communication(data: pd.DataFrame) -> pd.DataFrame:
    """Summarize information outcomes by openness and distortion bands."""
    reviewed = data.copy()
    reviewed["openness_band"] = pd.cut(
        reviewed["openness"],
        bins=[0, 40, 70, 100],
        labels=["low", "moderate", "high"],
        include_lowest=True,
    )
    reviewed["distortion_band"] = pd.cut(
        reviewed["distortion_loss"],
        bins=[0, 35, 65, 100],
        labels=["low", "moderate", "high"],
        include_lowest=True,
    )

    summary = (
        reviewed.groupby(["openness_band", "distortion_band"], observed=False)
        .agg(
            units=("unit_id", "count"),
            mean_information_effectiveness=("information_effectiveness", "mean"),
            high_integration_rate=("high_integration", "mean"),
            fragile_communication_rate=("fragile_communication", "mean"),
            mean_signal_quality=("signal_quality", "mean"),
            mean_communication_quality=("communication_quality", "mean"),
            mean_escalation_access=("escalation_access", "mean"),
            mean_trust=("trust", "mean"),
            mean_suppression_pressure=("suppression_pressure", "mean"),
        )
        .reset_index()
    )

    return summary


def main() -> None:
    data = generate_data()
    summary = review_fragile_communication(data)
    output_path = OUTPUT_DIR / "fragile_communication_review.csv"
    summary.to_csv(output_path, index=False)
    print(summary)
    print(f"Wrote {output_path}")


if __name__ == "__main__":
    main()
