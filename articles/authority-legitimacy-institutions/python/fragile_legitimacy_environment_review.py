"""
Fragile legitimacy-environment review.

Identify synthetic cases where apparent legitimacy is high while procedural
legitimacy and trust are weak.
"""

from __future__ import annotations

from pathlib import Path
import pandas as pd

from generate_authority_legitimacy_data import generate_data


ROOT = Path(__file__).resolve().parents[1]
OUTPUT_DIR = ROOT / "outputs" / "tables"
OUTPUT_DIR.mkdir(parents=True, exist_ok=True)


def review_fragile_legitimacy(data: pd.DataFrame) -> pd.DataFrame:
    """Summarize legitimacy outcomes by procedure and trust bands."""
    reviewed = data.copy()
    reviewed["procedure_band"] = pd.cut(
        reviewed["procedural_legitimacy"],
        bins=[0, 40, 70, 100],
        labels=["low", "moderate", "high"],
        include_lowest=True,
    )
    reviewed["trust_band"] = pd.cut(
        reviewed["trust"],
        bins=[0, 40, 70, 100],
        labels=["low", "moderate", "high"],
        include_lowest=True,
    )

    summary = (
        reviewed.groupby(["procedure_band", "trust_band"], observed=False)
        .agg(
            units=("unit_id", "count"),
            mean_authority_legitimacy_strength=("authority_legitimacy_strength", "mean"),
            mean_voluntary_compliance=("voluntary_compliance", "mean"),
            high_legitimacy_rate=("high_legitimacy", "mean"),
            high_voluntary_compliance_rate=("high_voluntary_compliance", "mean"),
            fragile_legitimacy_environment_rate=("fragile_legitimacy_environment", "mean"),
            mean_accountability=("accountability", "mean"),
            mean_repair_capacity=("repair_capacity", "mean"),
            mean_social_recognition=("social_recognition", "mean"),
            mean_arbitrariness_pressure=("arbitrariness_pressure", "mean"),
            mean_visible_inconsistency=("visible_inconsistency", "mean"),
        )
        .reset_index()
    )

    return summary


def main() -> None:
    data = generate_data()
    summary = review_fragile_legitimacy(data)
    output_path = OUTPUT_DIR / "fragile_legitimacy_environment_review.csv"
    summary.to_csv(output_path, index=False)
    print(summary)
    print(f"Wrote {output_path}")


if __name__ == "__main__":
    main()
