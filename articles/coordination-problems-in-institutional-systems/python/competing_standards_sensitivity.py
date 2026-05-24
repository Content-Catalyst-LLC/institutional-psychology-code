"""
Competing standards sensitivity analysis for institutional coordination.

The goal is to show how coordination quality changes when competing standards
are penalized more strongly.
"""

from __future__ import annotations

from pathlib import Path
import pandas as pd

from generate_coordination_data import generate_data


ROOT = Path(__file__).resolve().parents[1]
OUTPUT_DIR = ROOT / "outputs" / "tables"
OUTPUT_DIR.mkdir(parents=True, exist_ok=True)


def run_standards_sensitivity(data: pd.DataFrame) -> pd.DataFrame:
    """Evaluate coordination quality under different competing-standards penalties."""
    penalties = [0.00, 0.05, 0.10, 0.15, 0.20]
    rows = []

    for penalty in penalties:
        adjusted_score = (
            data["coordination_quality"]
            - penalty * data["competing_standards"]
            - 0.05 * data["competing_authority"]
            + 0.04 * data["focal_salience"]
        ).clip(0, 100)

        rows.append(
            {
                "competing_standards_penalty": penalty,
                "mean_adjusted_coordination": adjusted_score.mean(),
                "high_alignment_rate_adjusted": (adjusted_score >= 60).mean(),
                "fragile_alignment_rate_adjusted": (
                    (adjusted_score >= 60) & (data["trust"] < 40)
                ).mean(),
                "high_burden_alignment_rate_adjusted": (
                    (adjusted_score >= 60)
                    & (data["adaptation_burden"] > 65)
                    & (data["distributional_attention"] < 40)
                ).mean(),
            }
        )

    return pd.DataFrame(rows)


def main() -> None:
    data = generate_data()
    sensitivity = run_standards_sensitivity(data)
    output_path = OUTPUT_DIR / "competing_standards_sensitivity.csv"
    sensitivity.to_csv(output_path, index=False)
    print(sensitivity)
    print(f"Wrote {output_path}")


if __name__ == "__main__":
    main()
