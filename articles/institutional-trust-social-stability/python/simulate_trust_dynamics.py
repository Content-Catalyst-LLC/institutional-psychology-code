"""
Dynamic simulation of institutional trust and social stability.

This is a synthetic demonstration for institutional psychology research.
It should not be used for automated decisions about real people, workers,
students, communities, agencies, firms, or institutions.
"""

from __future__ import annotations

from pathlib import Path
import numpy as np
import pandas as pd


ROOT = Path(__file__).resolve().parents[1]
OUTPUT_DIR = ROOT / "outputs" / "tables"
OUTPUT_DIR.mkdir(parents=True, exist_ok=True)


def clamp(value: float, lower: float = 0.0, upper: float = 1.0) -> float:
    """Keep a value within a defined range."""
    return max(lower, min(upper, value))


def initialize_units(n_units: int = 260, seed: int = 1717) -> pd.DataFrame:
    """Initialize synthetic institutional trust units."""
    rng = np.random.default_rng(seed)

    return pd.DataFrame(
        {
            "unit_id": np.arange(1, n_units + 1),
            "consistency": rng.uniform(0.20, 0.90, n_units),
            "competence": rng.uniform(0.20, 0.90, n_units),
            "fairness": rng.uniform(0.20, 0.90, n_units),
            "accountability": rng.uniform(0.20, 0.90, n_units),
            "integrity": rng.uniform(0.20, 0.90, n_units),
            "recognition_voice": rng.uniform(0.20, 0.90, n_units),
            "repair_capacity": rng.uniform(0.20, 0.90, n_units),
            "legitimacy": rng.uniform(0.20, 0.90, n_units),
        }
    )


def run_simulation(n_units: int = 260, n_periods: int = 24, seed: int = 1717) -> pd.DataFrame:
    """Run repeated institutional trust and stability simulation."""
    rng = np.random.default_rng(seed)
    units = initialize_units(n_units, seed)
    records: list[dict[str, float]] = []

    for period in range(1, n_periods + 1):
        transparency = rng.uniform(0.15, 0.95)
        arbitrariness_pressure = rng.uniform(0.10, 0.85)
        visible_violation_pressure = rng.uniform(0.05, 0.80)
        fragmentation_pressure = rng.uniform(0.05, 0.80)
        administrative_burden = rng.uniform(0.05, 0.80)

        for index, row in units.iterrows():
            trust_score = (
                0.12 * row["consistency"]
                + 0.12 * row["competence"]
                + 0.15 * row["fairness"]
                + 0.11 * transparency
                + 0.14 * row["accountability"]
                + 0.12 * row["integrity"]
                + 0.09 * row["recognition_voice"]
                + 0.09 * row["repair_capacity"]
                - 0.14 * arbitrariness_pressure
                - 0.12 * visible_violation_pressure
                - 0.08 * administrative_burden
            )

            trust_score = clamp(trust_score)

            stability_score = (
                0.20 * trust_score
                + 0.16 * row["legitimacy"]
                + 0.14 * row["fairness"]
                + 0.12 * row["accountability"]
                + 0.10 * row["repair_capacity"]
                - 0.12 * fragmentation_pressure
                - 0.10 * arbitrariness_pressure
                - 0.08 * visible_violation_pressure
            )

            stability_score = clamp(stability_score)

            units.at[index, "consistency"] = clamp(
                row["consistency"] + 0.018 * (trust_score - 0.40)
            )

            units.at[index, "fairness"] = clamp(
                row["fairness"]
                + 0.020 * (trust_score - 0.40)
                - 0.006 * arbitrariness_pressure
            )

            units.at[index, "accountability"] = clamp(
                row["accountability"]
                + 0.020 * (trust_score - 0.40)
                + 0.006 * row["repair_capacity"]
                - 0.006 * visible_violation_pressure
            )

            units.at[index, "integrity"] = clamp(
                row["integrity"]
                + 0.015 * (trust_score - 0.40)
                - 0.006 * visible_violation_pressure
            )

            units.at[index, "recognition_voice"] = clamp(
                row["recognition_voice"]
                + 0.016 * (trust_score - 0.40)
                + 0.005 * row["legitimacy"]
                - 0.006 * administrative_burden
            )

            units.at[index, "repair_capacity"] = clamp(
                row["repair_capacity"]
                + 0.018 * (trust_score - 0.40)
                + 0.006 * row["accountability"]
                - 0.005 * visible_violation_pressure
            )

            units.at[index, "legitimacy"] = clamp(
                row["legitimacy"]
                + 0.017 * (stability_score - 0.40)
                + 0.005 * row["fairness"]
                - 0.006 * arbitrariness_pressure
            )

            records.append(
                {
                    "period": period,
                    "unit_id": row["unit_id"],
                    "transparency": transparency,
                    "arbitrariness_pressure": arbitrariness_pressure,
                    "visible_violation_pressure": visible_violation_pressure,
                    "fragmentation_pressure": fragmentation_pressure,
                    "administrative_burden": administrative_burden,
                    "trust_score": trust_score,
                    "stability_score": stability_score,
                    "consistency": units.at[index, "consistency"],
                    "competence": units.at[index, "competence"],
                    "fairness": units.at[index, "fairness"],
                    "accountability": units.at[index, "accountability"],
                    "integrity": units.at[index, "integrity"],
                    "recognition_voice": units.at[index, "recognition_voice"],
                    "repair_capacity": units.at[index, "repair_capacity"],
                    "legitimacy": units.at[index, "legitimacy"],
                    "fragile_trust_environment": int(
                        trust_score >= 0.60
                        and units.at[index, "fairness"] < 0.40
                        and units.at[index, "accountability"] < 0.40
                    ),
                    "high_distrust_pressure": int(
                        arbitrariness_pressure >= 0.70
                        and visible_violation_pressure >= 0.65
                        and units.at[index, "repair_capacity"] < 0.40
                    ),
                }
            )

    return pd.DataFrame(records)


def main() -> None:
    results = run_simulation()

    period_summary = (
        results.groupby("period")[
            [
                "transparency",
                "arbitrariness_pressure",
                "visible_violation_pressure",
                "fragmentation_pressure",
                "administrative_burden",
                "trust_score",
                "stability_score",
                "consistency",
                "competence",
                "fairness",
                "accountability",
                "integrity",
                "recognition_voice",
                "repair_capacity",
                "legitimacy",
                "fragile_trust_environment",
                "high_distrust_pressure",
            ]
        ]
        .mean()
        .reset_index()
    )

    unit_summary = (
        results.groupby("unit_id")[
            [
                "trust_score",
                "stability_score",
                "fairness",
                "accountability",
                "integrity",
                "recognition_voice",
                "repair_capacity",
                "legitimacy",
            ]
        ]
        .mean()
        .reset_index()
    )

    results["high_trust"] = (results["trust_score"] >= 0.65).astype(int)
    results["high_stability"] = (results["stability_score"] >= 0.65).astype(int)

    high_trust_rates = (
        results.groupby("period")["high_trust"]
        .mean()
        .reset_index(name="high_trust_rate")
    )

    high_stability_rates = (
        results.groupby("period")["high_stability"]
        .mean()
        .reset_index(name="high_stability_rate")
    )

    fragile_periods = (
        period_summary[
            (period_summary["trust_score"] >= 0.60)
            & (period_summary["fairness"] < 0.40)
            & (period_summary["accountability"] < 0.40)
        ]
        .sort_values("trust_score", ascending=False)
    )

    high_distrust_periods = (
        period_summary[
            (period_summary["arbitrariness_pressure"] >= 0.70)
            & (period_summary["visible_violation_pressure"] >= 0.65)
            & (period_summary["repair_capacity"] < 0.40)
        ]
        .sort_values("arbitrariness_pressure", ascending=False)
    )

    results.to_csv(OUTPUT_DIR / "institutional_trust_social_stability_simulation.csv", index=False)
    period_summary.to_csv(OUTPUT_DIR / "institutional_trust_period_summary.csv", index=False)
    unit_summary.to_csv(OUTPUT_DIR / "institutional_trust_unit_summary.csv", index=False)
    high_trust_rates.to_csv(OUTPUT_DIR / "institutional_trust_high_trust_rates.csv", index=False)
    high_stability_rates.to_csv(OUTPUT_DIR / "institutional_trust_high_stability_rates.csv", index=False)
    fragile_periods.to_csv(OUTPUT_DIR / "institutional_trust_fragile_periods.csv", index=False)
    high_distrust_periods.to_csv(OUTPUT_DIR / "institutional_trust_high_distrust_periods.csv", index=False)

    print("Simulation complete.")
    print(period_summary.head())
    print(f"Wrote outputs to {OUTPUT_DIR}")


if __name__ == "__main__":
    main()
