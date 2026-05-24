"""
Fragile institutional judgment review.

Identify synthetic cases where decision quality appears high but
dissent capacity is weak and filtering distortion is high.
"""

from __future__ import annotations

from pathlib import Path
import pandas as pd

from generate_cognitive_bias_data import generate_data


ROOT = Path(__file__).resolve().parents[1]
OUTPUT_DIR = ROOT / "outputs" / "tables"
OUTPUT_DIR.mkdir(parents=True, exist_ok=True)


def review_fragile_judgment(data: pd.DataFrame) -> pd.DataFrame:
    """Summarize decision outcomes by dissent and distortion bands."""
    reviewed = data.copy()
    reviewed["dissent_band"] = pd.cut(
        reviewed["dissent_capacity"],
        bins=[0, 40, 70, 100],
        labels=["low", "moderate", "high"],
        include_lowest=True,
    )
    reviewed["distortion_band"] = pd.cut(
        reviewed["filtering_distortion"],
        bins=[0, 35, 65, 100],
        labels=["low", "moderate", "high"],
        include_lowest=True,
    )

    summary = (
        reviewed.groupby(["dissent_band", "distortion_band"], observed=False)
        .agg(
            units=("unit_id", "count"),
            mean_decision_quality=("decision_quality", "mean"),
            mean_bias_pressure=("institutional_bias_pressure", "mean"),
            high_resilience_decision_rate=("high_resilience_decision", "mean"),
            fragile_judgment_rate=("fragile_judgment", "mean"),
            mean_information_quality=("information_quality", "mean"),
            mean_corrective_review=("corrective_review", "mean"),
            mean_feedback_openness=("feedback_openness", "mean"),
            mean_psychological_safety=("psychological_safety", "mean"),
        )
        .reset_index()
    )

    return summary


def main() -> None:
    data = generate_data()
    summary = review_fragile_judgment(data)
    output_path = OUTPUT_DIR / "fragile_judgment_review.csv"
    summary.to_csv(output_path, index=False)
    print(summary)
    print(f"Wrote {output_path}")


if __name__ == "__main__":
    main()
