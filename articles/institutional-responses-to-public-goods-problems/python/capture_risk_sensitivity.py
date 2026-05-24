"""
Capture-risk sensitivity analysis for public goods provision.

The goal is to show how provision quality can change when capture risk
is penalized more strongly.
"""

from __future__ import annotations

from pathlib import Path
import pandas as pd

from generate_public_goods_data import generate_data


ROOT = Path(__file__).resolve().parents[1]
OUTPUT_DIR = ROOT / "outputs" / "tables"
OUTPUT_DIR.mkdir(parents=True, exist_ok=True)


def run_capture_sensitivity(data: pd.DataFrame) -> pd.DataFrame:
    """Evaluate provision quality under different capture-risk penalties."""
    penalties = [0.00, 0.05, 0.10, 0.15, 0.20]
    rows = []

    for penalty in penalties:
        adjusted_score = (
            data["provision_quality"]
            - penalty * data["capture_risk"]
            + 0.04 * data["distributional_attention"]
        ).clip(0, 100)

        rows.append(
            {
                "capture_penalty": penalty,
                "mean_adjusted_provision": adjusted_score.mean(),
                "high_provision_rate_adjusted": (adjusted_score >= 60).mean(),
                "fragile_high_provision_rate_adjusted": (
                    (adjusted_score >= 60) & (data["legitimacy"] < 40)
                ).mean(),
                "high_capture_cases_above_threshold": (
                    (adjusted_score >= 60) & (data["capture_risk"] >= 65)
                ).mean(),
            }
        )

    return pd.DataFrame(rows)


def main() -> None:
    data = generate_data()
    sensitivity = run_capture_sensitivity(data)
    output_path = OUTPUT_DIR / "capture_risk_sensitivity.csv"
    sensitivity.to_csv(output_path, index=False)
    print(sensitivity)
    print(f"Wrote {output_path}")


if __name__ == "__main__":
    main()
