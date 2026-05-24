"""
Norm-conflict sensitivity analysis for norm-based cooperation.

The goal is to show how cooperation quality changes when norm conflict,
hypocrisy visibility, and unequal enforcement are penalized more strongly.
"""

from __future__ import annotations

from pathlib import Path
import pandas as pd

from generate_social_norms_data import generate_data


ROOT = Path(__file__).resolve().parents[1]
OUTPUT_DIR = ROOT / "outputs" / "tables"
OUTPUT_DIR.mkdir(parents=True, exist_ok=True)


def run_norm_conflict_sensitivity(data: pd.DataFrame) -> pd.DataFrame:
    """Evaluate cooperation quality under different norm-conflict penalties."""
    penalties = [0.00, 0.05, 0.10, 0.15, 0.20]
    rows = []

    for penalty in penalties:
        adjusted_score = (
            data["cooperation_score"]
            - penalty * data["norm_conflict"]
            - 0.06 * data["hypocrisy_visibility"]
            - 0.05 * data["unequal_enforcement"]
            + 0.04 * data["distributional_attention"]
        ).clip(0, 100)

        rows.append(
            {
                "norm_conflict_penalty": penalty,
                "mean_adjusted_cooperation": adjusted_score.mean(),
                "high_compliance_rate_adjusted": (adjusted_score >= 60).mean(),
                "fragile_norm_rate_adjusted": (
                    (adjusted_score >= 60) & (data["trust"] < 40)
                ).mean(),
                "high_burden_norm_rate_adjusted": (
                    (adjusted_score >= 60)
                    & (data["unequal_enforcement"] > 65)
                    & (data["distributional_attention"] < 40)
                ).mean(),
            }
        )

    return pd.DataFrame(rows)


def main() -> None:
    data = generate_data()
    sensitivity = run_norm_conflict_sensitivity(data)
    output_path = OUTPUT_DIR / "norm_conflict_sensitivity.csv"
    sensitivity.to_csv(output_path, index=False)
    print(sensitivity)
    print(f"Wrote {output_path}")


if __name__ == "__main__":
    main()
