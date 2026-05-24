"""
Evasion-pressure sensitivity analysis for enforcement systems.

The goal is to show how enforcement effectiveness changes when evasion pressure,
selective enforcement, and defensive compliance are penalized more strongly.
"""

from __future__ import annotations

from pathlib import Path
import pandas as pd

from generate_institutional_enforcement_data import generate_data


ROOT = Path(__file__).resolve().parents[1]
OUTPUT_DIR = ROOT / "outputs" / "tables"
OUTPUT_DIR.mkdir(parents=True, exist_ok=True)


def run_sensitivity(data: pd.DataFrame) -> pd.DataFrame:
    """Evaluate enforcement effectiveness under different evasion penalties."""
    penalties = [0.00, 0.05, 0.10, 0.15, 0.20]
    rows = []

    for penalty in penalties:
        adjusted_score = (
            data["enforcement_effectiveness"]
            - penalty * data["evasion_pressure"]
            - 0.06 * data["selective_enforcement"]
            - 0.05 * data["defensive_compliance"]
            - 0.04 * data["compliance_burden"]
            + 0.05 * data["accountability_reach"]
            + 0.04 * data["information_quality"]
        ).clip(0, 100)

        rows.append(
            {
                "evasion_pressure_penalty": penalty,
                "mean_adjusted_enforcement": adjusted_score.mean(),
                "high_compliance_quality_rate_adjusted": (adjusted_score >= 60).mean(),
                "fragile_enforcement_rate_adjusted": (
                    (adjusted_score >= 60) & (data["legitimacy"] < 40)
                ).mean(),
                "high_burden_enforcement_rate_adjusted": (
                    (adjusted_score >= 60)
                    & (data["compliance_burden"] > 65)
                    & (data["selective_enforcement"] > 65)
                ).mean(),
            }
        )

    return pd.DataFrame(rows)


def main() -> None:
    data = generate_data()
    sensitivity = run_sensitivity(data)
    output_path = OUTPUT_DIR / "evasion_pressure_sensitivity.csv"
    sensitivity.to_csv(output_path, index=False)
    print(sensitivity)
    print(f"Wrote {output_path}")


if __name__ == "__main__":
    main()
