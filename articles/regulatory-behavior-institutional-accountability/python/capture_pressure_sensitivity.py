"""
Capture-pressure sensitivity analysis for regulatory accountability.

The goal is to show how accountability changes when capture pressure and
unequal accountability are penalized more strongly.
"""

from __future__ import annotations

from pathlib import Path
import pandas as pd

from generate_regulatory_accountability_data import generate_data


ROOT = Path(__file__).resolve().parents[1]
OUTPUT_DIR = ROOT / "outputs" / "tables"
OUTPUT_DIR.mkdir(parents=True, exist_ok=True)


def run_sensitivity(data: pd.DataFrame) -> pd.DataFrame:
    """Evaluate regulatory accountability under different capture penalties."""
    penalties = [0.00, 0.05, 0.10, 0.15, 0.20]
    rows = []

    for penalty in penalties:
        adjusted_score = (
            data["accountability_effectiveness"]
            - penalty * data["capture_pressure"]
            - 0.06 * data["unequal_accountability"]
            - 0.05 * data["regulatory_burden"]
            + 0.05 * data["accountability_reach"]
            + 0.04 * data["information_quality"]
        ).clip(0, 100)

        rows.append(
            {
                "capture_pressure_penalty": penalty,
                "mean_adjusted_accountability": adjusted_score.mean(),
                "high_accountability_rate_adjusted": (adjusted_score >= 60).mean(),
                "fragile_regulation_rate_adjusted": (
                    (adjusted_score >= 60) & (data["legitimacy"] < 40)
                ).mean(),
                "high_burden_regulation_rate_adjusted": (
                    (adjusted_score >= 60)
                    & (data["regulatory_burden"] > 65)
                    & (data["unequal_accountability"] > 65)
                ).mean(),
            }
        )

    return pd.DataFrame(rows)


def main() -> None:
    data = generate_data()
    sensitivity = run_sensitivity(data)
    output_path = OUTPUT_DIR / "capture_pressure_sensitivity.csv"
    sensitivity.to_csv(output_path, index=False)
    print(sensitivity)
    print(f"Wrote {output_path}")


if __name__ == "__main__":
    main()
