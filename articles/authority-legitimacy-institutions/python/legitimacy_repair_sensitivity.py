"""
Legitimacy repair sensitivity analysis.

The goal is to show how synthetic legitimacy and voluntary compliance change
when repair capacity, accountability, procedural legitimacy, trust, and social
recognition are strengthened under different arbitrariness penalties.
"""

from __future__ import annotations

from pathlib import Path
import pandas as pd

from generate_authority_legitimacy_data import generate_data


ROOT = Path(__file__).resolve().parents[1]
OUTPUT_DIR = ROOT / "outputs" / "tables"
OUTPUT_DIR.mkdir(parents=True, exist_ok=True)


def run_sensitivity(data: pd.DataFrame) -> pd.DataFrame:
    """Evaluate legitimacy outcomes under different repair-strength assumptions."""
    repair_strengths = [0.00, 0.05, 0.10, 0.15, 0.20]
    rows = []

    for strength in repair_strengths:
        adjusted_legitimacy = (
            data["authority_legitimacy_strength"]
            - 0.06 * data["arbitrariness_pressure"]
            - 0.05 * data["visible_inconsistency"]
            - 0.04 * data["unequal_burden"]
            - 0.04 * data["opacity_pressure"]
            + strength * data["repair_capacity"]
            + strength * data["accountability"]
            + 0.04 * data["procedural_legitimacy"]
            + 0.04 * data["trust"]
            + 0.04 * data["social_recognition"]
        ).clip(0, 100)

        adjusted_compliance = (
            data["voluntary_compliance"]
            + 0.10 * adjusted_legitimacy
            + 0.05 * data["shared_norm_support"]
            + 0.05 * data["rule_clarity"]
            - 0.05 * data["enforcement_coercion_pressure"]
        ).clip(0, 100)

        rows.append(
            {
                "repair_strength": strength,
                "mean_adjusted_legitimacy": adjusted_legitimacy.mean(),
                "mean_adjusted_voluntary_compliance": adjusted_compliance.mean(),
                "high_legitimacy_rate_adjusted": (adjusted_legitimacy >= 60).mean(),
                "high_voluntary_compliance_rate_adjusted": (adjusted_compliance >= 60).mean(),
                "fragile_legitimacy_environment_rate_adjusted": (
                    (adjusted_legitimacy >= 60)
                    & (data["procedural_legitimacy"] < 40)
                    & (data["trust"] < 40)
                ).mean(),
                "high_arbitrariness_environment_rate": data["high_arbitrariness_environment"].mean(),
            }
        )

    return pd.DataFrame(rows)


def main() -> None:
    data = generate_data()
    sensitivity = run_sensitivity(data)
    output_path = OUTPUT_DIR / "legitimacy_repair_sensitivity.csv"
    sensitivity.to_csv(output_path, index=False)
    print(sensitivity)
    print(f"Wrote {output_path}")


if __name__ == "__main__":
    main()
