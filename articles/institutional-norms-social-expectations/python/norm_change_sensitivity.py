"""
Norm change sensitivity analysis.

The goal is to show how synthetic norm-change readiness changes when alternative
norm visibility, legitimacy alignment, and learning capacity increase while
sanction cost, rigidity pressure, and suppressive pressure vary.
"""

from __future__ import annotations

from pathlib import Path
import pandas as pd

from generate_institutional_norms_data import generate_data


ROOT = Path(__file__).resolve().parents[1]
OUTPUT_DIR = ROOT / "outputs" / "tables"
OUTPUT_DIR.mkdir(parents=True, exist_ok=True)


def run_sensitivity(data: pd.DataFrame) -> pd.DataFrame:
    """Evaluate norm-change readiness under different change-support assumptions."""
    support_strengths = [0.00, 0.05, 0.10, 0.15, 0.20]
    rows = []

    for strength in support_strengths:
        adjusted_readiness = (
            data["norm_change_readiness"]
            + strength * data["alternative_norm_visibility"]
            + strength * data["learning_capacity"]
            + 0.05 * data["legitimacy_alignment"]
            + 0.04 * data["trust_reinforcement"]
            - 0.06 * data["sanction_cost"]
            - 0.05 * data["rigidity_pressure"]
            - 0.05 * data["suppressive_pressure"]
        ).clip(0, 100)

        adjusted_stability = (
            data["normative_stability"]
            + 0.05 * data["expectation_convergence"]
            + 0.04 * data["legitimacy_alignment"]
            + 0.04 * data["trust_reinforcement"]
            - 0.05 * data["fragmentation_pressure"]
            - 0.04 * data["unequal_normative_burden"]
        ).clip(0, 100)

        rows.append(
            {
                "support_strength": strength,
                "mean_adjusted_norm_change_readiness": adjusted_readiness.mean(),
                "mean_adjusted_normative_stability": adjusted_stability.mean(),
                "high_change_readiness_rate_adjusted": (adjusted_readiness >= 60).mean(),
                "high_coordination_rate_adjusted": (adjusted_stability >= 60).mean(),
                "fragile_normative_environment_rate": data["fragile_normative_environment"].mean(),
                "suppressive_norm_environment_rate": data["suppressive_norm_environment"].mean(),
            }
        )

    return pd.DataFrame(rows)


def main() -> None:
    data = generate_data()
    sensitivity = run_sensitivity(data)
    output_path = OUTPUT_DIR / "norm_change_sensitivity.csv"
    sensitivity.to_csv(output_path, index=False)
    print(sensitivity)
    print(f"Wrote {output_path}")


if __name__ == "__main__":
    main()
