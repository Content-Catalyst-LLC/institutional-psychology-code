"""
Distortion-loss sensitivity analysis for institutional information flow.

The goal is to show how information effectiveness changes when distortion,
overload, suppression pressure, siloing, and metric tunnel vision are penalized
more strongly.
"""

from __future__ import annotations

from pathlib import Path
import pandas as pd

from generate_information_flow_data import generate_data


ROOT = Path(__file__).resolve().parents[1]
OUTPUT_DIR = ROOT / "outputs" / "tables"
OUTPUT_DIR.mkdir(parents=True, exist_ok=True)


def run_sensitivity(data: pd.DataFrame) -> pd.DataFrame:
    """Evaluate information effectiveness under different distortion penalties."""
    penalties = [0.00, 0.05, 0.10, 0.15, 0.20]
    rows = []

    for penalty in penalties:
        adjusted_score = (
            data["information_effectiveness"]
            - penalty * data["distortion_loss"]
            - 0.06 * data["overload"]
            - 0.05 * data["suppression_pressure"]
            - 0.05 * data["siloing"]
            - 0.04 * data["metric_tunnel_vision"]
            + 0.05 * data["signal_quality"]
            + 0.04 * data["openness"]
            + 0.04 * data["escalation_access"]
            + 0.04 * data["community_voice"]
        ).clip(0, 100)

        rows.append(
            {
                "distortion_penalty": penalty,
                "mean_adjusted_information_effectiveness": adjusted_score.mean(),
                "high_integration_rate_adjusted": (adjusted_score >= 60).mean(),
                "fragile_communication_rate_adjusted": (
                    (adjusted_score >= 60)
                    & (data["openness"] < 40)
                    & (data["distortion_loss"] > 65)
                ).mean(),
                "high_overload_system_rate_adjusted": (
                    (adjusted_score >= 60)
                    & (data["overload"] > 70)
                    & (data["metric_tunnel_vision"] > 65)
                ).mean(),
            }
        )

    return pd.DataFrame(rows)


def main() -> None:
    data = generate_data()
    sensitivity = run_sensitivity(data)
    output_path = OUTPUT_DIR / "distortion_sensitivity.csv"
    sensitivity.to_csv(output_path, index=False)
    print(sensitivity)
    print(f"Wrote {output_path}")


if __name__ == "__main__":
    main()
