"""
Institutional repair and learning sensitivity analysis.

The goal is to show how synthetic institutional strength and behavioral
alignment change when learning capacity, repair capacity, information quality,
memory retention, legitimacy, and trust are strengthened under fragmentation,
opacity, administrative burden, and historical harm pressure.
"""

from __future__ import annotations

from pathlib import Path
import pandas as pd

from generate_institutions_behavior_data import generate_data


ROOT = Path(__file__).resolve().parents[1]
OUTPUT_DIR = ROOT / "outputs" / "tables"
OUTPUT_DIR.mkdir(parents=True, exist_ok=True)


def run_sensitivity(data: pd.DataFrame) -> pd.DataFrame:
    """Evaluate institutional outcomes under different repair-learning assumptions."""
    repair_learning_strengths = [0.00, 0.05, 0.10, 0.15, 0.20]
    rows = []

    for strength in repair_learning_strengths:
        adjusted_strength = (
            data["institutional_strength"]
            + strength * data["learning_capacity"]
            + strength * data["repair_capacity"]
            + 0.04 * data["information_quality"]
            + 0.04 * data["memory_retention"]
            + 0.04 * data["legitimacy_strength"]
            + 0.04 * data["trust_reinforcement"]
            - 0.06 * data["fragmentation_pressure"]
            - 0.05 * data["opacity_pressure"]
            - 0.05 * data["administrative_burden"]
            - 0.04 * data["historical_harm_pressure"]
        ).clip(0, 100)

        adjusted_alignment = (
            data["behavioral_alignment"]
            + 0.10 * adjusted_strength
            + 0.05 * data["role_clarity"]
            + 0.05 * data["normative_stability"]
            - 0.05 * data["fragmentation_pressure"]
            - 0.04 * data["administrative_burden"]
        ).clip(0, 100)

        rows.append(
            {
                "repair_learning_strength": strength,
                "mean_adjusted_institutional_strength": adjusted_strength.mean(),
                "mean_adjusted_behavioral_alignment": adjusted_alignment.mean(),
                "high_institutional_alignment_rate_adjusted": (adjusted_strength >= 60).mean(),
                "high_behavioral_alignment_rate_adjusted": (adjusted_alignment >= 60).mean(),
                "fragile_institutional_environment_rate": data["fragile_institutional_environment"].mean(),
                "high_fragmentation_environment_rate": data["high_fragmentation_environment"].mean(),
            }
        )

    return pd.DataFrame(rows)


def main() -> None:
    data = generate_data()
    sensitivity = run_sensitivity(data)
    output_path = OUTPUT_DIR / "institutional_repair_learning_sensitivity.csv"
    sensitivity.to_csv(output_path, index=False)
    print(sensitivity)
    print(f"Wrote {output_path}")


if __name__ == "__main__":
    main()
