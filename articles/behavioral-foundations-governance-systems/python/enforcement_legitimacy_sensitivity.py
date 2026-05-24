"""
Enforcement-legitimacy sensitivity analysis for behavioral governance.

The goal is to show how governance effectiveness changes when enforcement
depends more strongly on legitimacy and fairness.
"""

from __future__ import annotations

from pathlib import Path
import pandas as pd

from generate_behavioral_governance_data import generate_data


ROOT = Path(__file__).resolve().parents[1]
OUTPUT_DIR = ROOT / "outputs" / "tables"
OUTPUT_DIR.mkdir(parents=True, exist_ok=True)


def run_sensitivity(data: pd.DataFrame) -> pd.DataFrame:
    """Evaluate governance quality under different enforcement-legitimacy interactions."""
    interaction_weights = [0.00, 0.05, 0.10, 0.15, 0.20]
    rows = []

    for weight in interaction_weights:
        adjusted_score = (
            data["governance_effectiveness"]
            + weight * ((data["enforcement_credibility"] * data["legitimacy"]) / 100)
            + 0.05 * data["perceived_fairness"]
            - 0.06 * data["behavioral_burden"]
            - 0.05 * data["hypocrisy_visibility"]
            - 0.04 * data["power_asymmetry"]
        ).clip(0, 100)

        rows.append(
            {
                "enforcement_legitimacy_interaction_weight": weight,
                "mean_adjusted_governance": adjusted_score.mean(),
                "high_governance_rate_adjusted": (adjusted_score >= 60).mean(),
                "fragile_governance_rate_adjusted": (
                    (adjusted_score >= 60) & (data["trust"] < 40)
                ).mean(),
                "high_burden_governance_rate_adjusted": (
                    (adjusted_score >= 60)
                    & (data["behavioral_burden"] > 65)
                    & (data["perceived_fairness"] < 40)
                ).mean(),
            }
        )

    return pd.DataFrame(rows)


def main() -> None:
    data = generate_data()
    sensitivity = run_sensitivity(data)
    output_path = OUTPUT_DIR / "enforcement_legitimacy_sensitivity.csv"
    sensitivity.to_csv(output_path, index=False)
    print(sensitivity)
    print(f"Wrote {output_path}")


if __name__ == "__main__":
    main()
