"""
Capture-risk sensitivity analysis for crisis-driven institutional reform.

The goal is to show how reform probability and transformation quality can
diverge when capture risk is high.
"""

from __future__ import annotations

from pathlib import Path
import pandas as pd

from generate_crisis_reform_data import generate_data


ROOT = Path(__file__).resolve().parents[1]
OUTPUT_DIR = ROOT / "outputs" / "tables"
OUTPUT_DIR.mkdir(parents=True, exist_ok=True)


def run_capture_sensitivity(data: pd.DataFrame) -> pd.DataFrame:
    """Evaluate transformation score under different capture-risk penalties."""
    penalties = [0.00, 0.05, 0.10, 0.15, 0.20]
    rows = []

    for penalty in penalties:
        adjusted_score = (
            data["transformation_score"]
            - penalty * data["capture_risk"]
            + 0.04 * data["distributional_attention"]
        ).clip(0, 100)

        rows.append(
            {
                "capture_penalty": penalty,
                "mean_adjusted_transformation": adjusted_score.mean(),
                "major_reform_rate_adjusted": (adjusted_score >= 60).mean(),
                "deep_transformation_rate_adjusted": (adjusted_score >= 75).mean(),
                "high_capture_cases_above_major_threshold": (
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
