"""
Dynamic simulation of institutional memory, knowledge retention, and continuity.

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


def initialize_units(n_units: int = 260, seed: int = 1313) -> pd.DataFrame:
    """Initialize synthetic institutional memory units."""
    rng = np.random.default_rng(seed)

    return pd.DataFrame(
        {
            "unit_id": np.arange(1, n_units + 1),
            "documented_retention": rng.uniform(0.20, 0.90, n_units),
            "tacit_transfer": rng.uniform(0.20, 0.90, n_units),
            "accessibility": rng.uniform(0.20, 0.90, n_units),
            "technical_continuity": rng.uniform(0.20, 0.90, n_units),
            "metadata_quality": rng.uniform(0.20, 0.90, n_units),
            "loss_fragmentation": rng.uniform(0.10, 0.90, n_units),
            "key_person_dependency": rng.uniform(0.10, 0.90, n_units),
        }
    )


def run_simulation(n_units: int = 260, n_periods: int = 24, seed: int = 1313) -> pd.DataFrame:
    """Run repeated institutional memory simulation."""
    rng = np.random.default_rng(seed)
    units = initialize_units(n_units, seed)
    records: list[dict[str, float]] = []

    for period in range(1, n_periods + 1):
        interpretive_use = rng.uniform(0.15, 0.95)
        revisability = rng.uniform(0.15, 0.95)
        path_dependence_pressure = rng.uniform(0.10, 0.85)
        selective_narration = rng.uniform(0.05, 0.85)
        distributed_integration = rng.uniform(0.15, 0.95)
        memory_justice = rng.uniform(0.15, 0.95)

        for index, row in units.iterrows():
            memory_score = (
                0.14 * row["documented_retention"]
                + 0.13 * row["tacit_transfer"]
                + 0.13 * row["accessibility"]
                + 0.10 * row["technical_continuity"]
                + 0.09 * row["metadata_quality"]
                + 0.11 * interpretive_use
                + 0.11 * revisability
                + 0.08 * distributed_integration
                + 0.07 * memory_justice
                - 0.12 * path_dependence_pressure
                - 0.12 * row["loss_fragmentation"]
                - 0.08 * selective_narration
                - 0.07 * row["key_person_dependency"]
            )

            memory_score = clamp(memory_score)

            units.at[index, "documented_retention"] = clamp(
                row["documented_retention"] + 0.022 * (memory_score - 0.40)
            )

            units.at[index, "tacit_transfer"] = clamp(
                row["tacit_transfer"]
                + 0.020 * (memory_score - 0.40)
                - 0.006 * row["key_person_dependency"]
            )

            units.at[index, "accessibility"] = clamp(
                row["accessibility"]
                + 0.020 * (memory_score - 0.40)
                + 0.006 * row["metadata_quality"]
                - 0.006 * row["loss_fragmentation"]
            )

            units.at[index, "technical_continuity"] = clamp(
                row["technical_continuity"]
                + 0.018 * (memory_score - 0.40)
                - 0.006 * row["loss_fragmentation"]
            )

            units.at[index, "metadata_quality"] = clamp(
                row["metadata_quality"]
                + 0.018 * (memory_score - 0.40)
                + 0.006 * distributed_integration
            )

            units.at[index, "loss_fragmentation"] = clamp(
                row["loss_fragmentation"]
                - 0.012 * memory_score
                + 0.006 * selective_narration
            )

            units.at[index, "key_person_dependency"] = clamp(
                row["key_person_dependency"]
                - 0.010 * row["tacit_transfer"]
                - 0.008 * row["documented_retention"]
                + 0.004 * path_dependence_pressure
            )

            records.append(
                {
                    "period": period,
                    "unit_id": row["unit_id"],
                    "interpretive_use": interpretive_use,
                    "revisability": revisability,
                    "path_dependence_pressure": path_dependence_pressure,
                    "selective_narration": selective_narration,
                    "distributed_integration": distributed_integration,
                    "memory_justice": memory_justice,
                    "memory_score": memory_score,
                    "documented_retention": units.at[index, "documented_retention"],
                    "tacit_transfer": units.at[index, "tacit_transfer"],
                    "accessibility": units.at[index, "accessibility"],
                    "technical_continuity": units.at[index, "technical_continuity"],
                    "metadata_quality": units.at[index, "metadata_quality"],
                    "loss_fragmentation": units.at[index, "loss_fragmentation"],
                    "key_person_dependency": units.at[index, "key_person_dependency"],
                    "fragile_memory": int(
                        memory_score >= 0.60
                        and units.at[index, "documented_retention"] < 0.40
                        and units.at[index, "tacit_transfer"] < 0.40
                    ),
                    "high_path_dependence_memory": int(
                        memory_score >= 0.60
                        and path_dependence_pressure >= 0.65
                        and revisability <= 0.40
                    ),
                }
            )

    return pd.DataFrame(records)


def main() -> None:
    results = run_simulation()

    period_summary = (
        results.groupby("period")[
            [
                "interpretive_use",
                "revisability",
                "path_dependence_pressure",
                "selective_narration",
                "distributed_integration",
                "memory_justice",
                "memory_score",
                "documented_retention",
                "tacit_transfer",
                "accessibility",
                "technical_continuity",
                "metadata_quality",
                "loss_fragmentation",
                "key_person_dependency",
                "fragile_memory",
                "high_path_dependence_memory",
            ]
        ]
        .mean()
        .reset_index()
    )

    unit_summary = (
        results.groupby("unit_id")[
            [
                "memory_score",
                "documented_retention",
                "tacit_transfer",
                "accessibility",
                "technical_continuity",
                "metadata_quality",
                "loss_fragmentation",
                "key_person_dependency",
            ]
        ]
        .mean()
        .reset_index()
    )

    results["high_memory"] = (results["memory_score"] >= 0.65).astype(int)

    high_rates = (
        results.groupby("period")["high_memory"]
        .mean()
        .reset_index(name="high_memory_rate")
    )

    fragile_periods = (
        period_summary[
            (period_summary["memory_score"] >= 0.60)
            & (period_summary["documented_retention"] < 0.40)
            & (period_summary["tacit_transfer"] < 0.40)
        ]
        .sort_values("memory_score", ascending=False)
    )

    high_path_periods = (
        period_summary[
            (period_summary["memory_score"] >= 0.60)
            & (period_summary["path_dependence_pressure"] >= 0.65)
            & (period_summary["revisability"] <= 0.40)
        ]
        .sort_values("path_dependence_pressure", ascending=False)
    )

    results.to_csv(OUTPUT_DIR / "institutional_memory_knowledge_retention_simulation.csv", index=False)
    period_summary.to_csv(OUTPUT_DIR / "institutional_memory_period_summary.csv", index=False)
    unit_summary.to_csv(OUTPUT_DIR / "institutional_memory_unit_summary.csv", index=False)
    high_rates.to_csv(OUTPUT_DIR / "institutional_memory_high_rates.csv", index=False)
    fragile_periods.to_csv(OUTPUT_DIR / "institutional_memory_fragile_periods.csv", index=False)
    high_path_periods.to_csv(OUTPUT_DIR / "institutional_memory_high_path_dependence_periods.csv", index=False)

    print("Simulation complete.")
    print(period_summary.head())
    print(f"Wrote outputs to {OUTPUT_DIR}")


if __name__ == "__main__":
    main()
