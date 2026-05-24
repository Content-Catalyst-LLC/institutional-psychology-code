"""
Trust repair sensitivity analysis.

The goal is to show how synthetic trust and stability change when
repair capacity, accountability, recognition, fairness, and transparency
are strengthened under different violation-pressure penalties.
"""

from __future__ import annotations

from pathlib import Path
import pandas as pd

from generate_institutional_trust_data import generate_data


ROOT = Path(__file__).resolve().parents[1]
OUTPUT_DIR = ROOT / "outputs" / "tables"
OUTPUT_DIR.mkdir(parents=True, exist_ok=True)


def run_sensitivity(data: pd.DataFrame) -> pd.DataFrame:
    """Evaluate trust outcomes under different repair-strength assumptions."""
    repair_strengths = [0.00, 0.05, 0.10, 0.15, 0.20]
    rows = []

    for strength in repair_strengths:
        adjusted_trust = (
            data["trust_score"]
            - 0.06 * data["arbitrariness_pressure"]
            - 0.06 * data["visible_violation_pressure"]
            - 0.04 * data["administrative_burden"]
            + strength * data["repair_capacity"]
            + strength * data["accountability"]
            + 0.04 * data["fairness"]
            + 0.04 * data["recognition_voice"]
            + 0.04 * data["transparency"]
        ).clip(0, 100)

        adjusted_stability = (
            data["social_stability"]
            + 0.10 * adjusted_trust
            + 0.05 * data["voluntary_compliance"]
            + 0.05 * data["cooperation_capacity"]
            - 0.05 * data["fragmentation_pressure"]
        ).clip(0, 100)

        rows.append(
            {
                "repair_strength": strength,
                "mean_adjusted_trust": adjusted_trust.mean(),
                "mean_adjusted_stability": adjusted_stability.mean(),
                "high_trust_rate_adjusted": (adjusted_trust >= 60).mean(),
                "high_stability_rate_adjusted": (adjusted_stability >= 60).mean(),
                "fragile_trust_environment_rate_adjusted": (
                    (adjusted_trust >= 60)
                    & (data["fairness"] < 40)
                    & (data["accountability"] < 40)
                ).mean(),
                "high_distrust_pressure_rate": data["high_distrust_pressure"].mean(),
            }
        )

    return pd.DataFrame(rows)


def main() -> None:
    data = generate_data()
    sensitivity = run_sensitivity(data)
    output_path = OUTPUT_DIR / "trust_repair_sensitivity.csv"
    sensitivity.to_csv(output_path, index=False)
    print(sensitivity)
    print(f"Wrote {output_path}")


if __name__ == "__main__":
    main()
