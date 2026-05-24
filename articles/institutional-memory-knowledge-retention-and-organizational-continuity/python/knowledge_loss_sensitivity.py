"""
Knowledge-loss sensitivity analysis for institutional memory.

The goal is to show how memory effectiveness changes when loss fragmentation,
turnover pressure, key-person dependency, and selective narration are penalized
more strongly.
"""

from __future__ import annotations

from pathlib import Path
import pandas as pd

from generate_institutional_memory_data import generate_data


ROOT = Path(__file__).resolve().parents[1]
OUTPUT_DIR = ROOT / "outputs" / "tables"
OUTPUT_DIR.mkdir(parents=True, exist_ok=True)


def run_sensitivity(data: pd.DataFrame) -> pd.DataFrame:
    """Evaluate memory effectiveness under different knowledge-loss penalties."""
    penalties = [0.00, 0.05, 0.10, 0.15, 0.20]
    rows = []

    for penalty in penalties:
        adjusted_score = (
            data["memory_effectiveness"]
            - penalty * data["loss_fragmentation"]
            - 0.06 * data["turnover_pressure"]
            - 0.05 * data["key_person_dependency"]
            - 0.05 * data["selective_narration"]
            - 0.04 * data["path_dependence_pressure"]
            + 0.05 * data["documented_retention"]
            + 0.04 * data["tacit_transfer"]
            + 0.04 * data["metadata_quality"]
            + 0.04 * data["memory_justice"]
        ).clip(0, 100)

        rows.append(
            {
                "knowledge_loss_penalty": penalty,
                "mean_adjusted_memory_effectiveness": adjusted_score.mean(),
                "high_resilience_memory_rate_adjusted": (adjusted_score >= 60).mean(),
                "fragile_memory_rate_adjusted": (
                    (adjusted_score >= 60)
                    & (data["documented_retention"] < 40)
                    & (data["tacit_transfer"] < 40)
                ).mean(),
                "high_path_dependence_memory_rate_adjusted": (
                    (adjusted_score >= 60)
                    & (data["path_dependence_pressure"] > 65)
                    & (data["revisability"] < 40)
                ).mean(),
            }
        )

    return pd.DataFrame(rows)


def main() -> None:
    data = generate_data()
    sensitivity = run_sensitivity(data)
    output_path = OUTPUT_DIR / "knowledge_loss_sensitivity.csv"
    sensitivity.to_csv(output_path, index=False)
    print(sensitivity)
    print(f"Wrote {output_path}")


if __name__ == "__main__":
    main()
