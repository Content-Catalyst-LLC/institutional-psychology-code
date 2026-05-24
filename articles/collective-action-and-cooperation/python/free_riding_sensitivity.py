"""
Free-riding pressure sensitivity analysis for collective action systems.

The goal is to show how cooperation quality changes when free-riding pressure,
burden inequality, and hypocrisy visibility are penalized more strongly.
"""

from __future__ import annotations

from pathlib import Path
import pandas as pd

from generate_collective_action_data import generate_data


ROOT = Path(__file__).resolve().parents[1]
OUTPUT_DIR = ROOT / "outputs" / "tables"
OUTPUT_DIR.mkdir(parents=True, exist_ok=True)


def run_free_riding_sensitivity(data: pd.DataFrame) -> pd.DataFrame:
    """Evaluate cooperation quality under different free-riding penalties."""
    penalties = [0.00, 0.05, 0.10, 0.15, 0.20]
    rows = []

    for penalty in penalties:
        adjusted_score = (
            data["cooperation_score"]
            - penalty * data["free_riding_pressure"]
            - 0.06 * data["burden_inequality"]
            - 0.05 * data["hypocrisy_visibility"]
            + 0.04 * data["perceived_fairness"]
        ).clip(0, 100)

        rows.append(
            {
                "free_riding_penalty": penalty,
                "mean_adjusted_cooperation": adjusted_score.mean(),
                "high_cooperation_rate_adjusted": (adjusted_score >= 60).mean(),
                "fragile_cooperation_rate_adjusted": (
                    (adjusted_score >= 60) & (data["trust"] < 40)
                ).mean(),
                "high_burden_cooperation_rate_adjusted": (
                    (adjusted_score >= 60)
                    & (data["burden_inequality"] > 65)
                    & (data["perceived_fairness"] < 40)
                ).mean(),
            }
        )

    return pd.DataFrame(rows)


def main() -> None:
    data = generate_data()
    sensitivity = run_free_riding_sensitivity(data)
    output_path = OUTPUT_DIR / "free_riding_sensitivity.csv"
    sensitivity.to_csv(output_path, index=False)
    print(sensitivity)
    print(f"Wrote {output_path}")


if __name__ == "__main__":
    main()
