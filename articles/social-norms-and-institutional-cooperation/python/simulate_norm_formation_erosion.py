"""
Dynamic simulation of social norm formation and erosion.

This is a synthetic demonstration for institutional psychology research.
It should not be used for automated decisions about real people, workers,
communities, agencies, or institutions.
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


def initialize_agents(n_agents: int = 260, seed: int = 505) -> pd.DataFrame:
    """Initialize synthetic agents."""
    rng = np.random.default_rng(seed)

    return pd.DataFrame(
        {
            "agent_id": np.arange(1, n_agents + 1),
            "trust": rng.uniform(0.20, 0.90, n_agents),
            "descriptive_norm": rng.uniform(0.20, 0.90, n_agents),
            "injunctive_norm": rng.uniform(0.20, 0.90, n_agents),
            "legitimacy": rng.uniform(0.20, 0.90, n_agents),
            "burden_sensitivity": rng.uniform(0.10, 0.90, n_agents),
        }
    )


def run_simulation(n_agents: int = 260, n_periods: int = 24, seed: int = 505) -> pd.DataFrame:
    """Run repeated norm formation and erosion simulation."""
    rng = np.random.default_rng(seed)
    agents = initialize_agents(n_agents, seed)
    records: list[dict[str, float]] = []

    for period in range(1, n_periods + 1):
        institutional_reinforcement = rng.uniform(0.15, 0.95)
        sanction_intensity = rng.uniform(0.10, 0.90)
        norm_conflict = rng.uniform(0.05, 0.80)
        hypocrisy_visibility = rng.uniform(0.05, 0.85)
        unequal_enforcement = rng.uniform(0.05, 0.85)
        distributional_attention = rng.uniform(0.10, 0.90)

        compliance_list = []

        for row_index, row in agents.iterrows():
            z = (
                -0.9
                + 1.35 * row["descriptive_norm"]
                + 1.30 * row["injunctive_norm"]
                + 1.15 * row["trust"]
                + 1.05 * row["legitimacy"]
                + 1.00 * institutional_reinforcement
                + 0.75 * sanction_intensity
                - 1.35 * norm_conflict
                - 1.10 * hypocrisy_visibility
                - 0.70 * unequal_enforcement * row["burden_sensitivity"]
                + 0.45 * distributional_attention
            )

            comply_prob = 1 / (1 + np.exp(-z))
            compliant = rng.binomial(1, comply_prob)
            compliance_list.append(compliant)

            agents.at[row_index, "descriptive_norm"] = clamp(
                row["descriptive_norm"] + 0.035 * (compliant - 0.40)
            )

            agents.at[row_index, "injunctive_norm"] = clamp(
                row["injunctive_norm"]
                + 0.025 * institutional_reinforcement
                + 0.015 * row["legitimacy"]
                - 0.025 * norm_conflict
                - 0.020 * hypocrisy_visibility
            )

            agents.at[row_index, "trust"] = clamp(
                row["trust"]
                + 0.030 * (compliant - 0.40)
                + 0.015 * distributional_attention
                - 0.025 * unequal_enforcement
                - 0.020 * hypocrisy_visibility
            )

            agents.at[row_index, "legitimacy"] = clamp(
                row["legitimacy"]
                + 0.020 * institutional_reinforcement
                + 0.015 * distributional_attention
                - 0.020 * unequal_enforcement
                - 0.025 * hypocrisy_visibility
            )

        compliance_rate = sum(compliance_list) / n_agents

        norm_cooperation_quality = clamp(
            0.38 * compliance_rate
            + 0.18 * agents["trust"].mean()
            + 0.16 * agents["legitimacy"].mean()
            + 0.14 * institutional_reinforcement
            + 0.08 * sanction_intensity
            + 0.06 * distributional_attention
            - 0.15 * norm_conflict
            - 0.12 * hypocrisy_visibility
            - 0.08 * unequal_enforcement
        )

        fragile_norm_environment = int(
            norm_cooperation_quality >= 0.60 and agents["trust"].mean() < 0.40
        )

        high_burden_norm_environment = int(
            norm_cooperation_quality >= 0.60
            and unequal_enforcement >= 0.65
            and distributional_attention < 0.40
        )

        for idx, compliant in enumerate(compliance_list):
            records.append(
                {
                    "period": period,
                    "agent_id": idx + 1,
                    "institutional_reinforcement": institutional_reinforcement,
                    "sanction_intensity": sanction_intensity,
                    "norm_conflict": norm_conflict,
                    "hypocrisy_visibility": hypocrisy_visibility,
                    "unequal_enforcement": unequal_enforcement,
                    "distributional_attention": distributional_attention,
                    "compliant": compliant,
                    "compliance_rate": compliance_rate,
                    "norm_cooperation_quality": norm_cooperation_quality,
                    "trust": agents.at[idx, "trust"],
                    "legitimacy": agents.at[idx, "legitimacy"],
                    "descriptive_norm": agents.at[idx, "descriptive_norm"],
                    "injunctive_norm": agents.at[idx, "injunctive_norm"],
                    "fragile_norm_environment": fragile_norm_environment,
                    "high_burden_norm_environment": high_burden_norm_environment,
                }
            )

    return pd.DataFrame(records)


def main() -> None:
    results = run_simulation()

    period_summary = (
        results.groupby("period")[
            [
                "institutional_reinforcement",
                "sanction_intensity",
                "norm_conflict",
                "hypocrisy_visibility",
                "unequal_enforcement",
                "distributional_attention",
                "compliant",
                "compliance_rate",
                "norm_cooperation_quality",
                "trust",
                "legitimacy",
                "descriptive_norm",
                "injunctive_norm",
                "fragile_norm_environment",
                "high_burden_norm_environment",
            ]
        ]
        .mean()
        .reset_index()
    )

    agent_summary = (
        results.groupby("agent_id")[
            ["compliant", "trust", "legitimacy", "descriptive_norm", "injunctive_norm"]
        ]
        .mean()
        .reset_index()
    )

    results["high_compliance"] = (results["compliance_rate"] >= 0.65).astype(int)

    compliance_rates = (
        results.groupby("period")["high_compliance"]
        .mean()
        .reset_index(name="high_compliance_rate")
    )

    fragile_periods = (
        period_summary[period_summary["fragile_norm_environment"] > 0]
        .sort_values(["fragile_norm_environment", "norm_cooperation_quality"], ascending=False)
    )

    high_burden_periods = (
        period_summary[period_summary["high_burden_norm_environment"] > 0]
        .sort_values(["high_burden_norm_environment", "unequal_enforcement"], ascending=False)
    )

    results.to_csv(OUTPUT_DIR / "social_norms_institutional_cooperation_simulation.csv", index=False)
    period_summary.to_csv(OUTPUT_DIR / "social_norms_period_summary.csv", index=False)
    agent_summary.to_csv(OUTPUT_DIR / "social_norms_agent_summary.csv", index=False)
    compliance_rates.to_csv(OUTPUT_DIR / "social_norms_compliance_rates.csv", index=False)
    fragile_periods.to_csv(OUTPUT_DIR / "social_norms_fragile_periods.csv", index=False)
    high_burden_periods.to_csv(OUTPUT_DIR / "social_norms_high_burden_periods.csv", index=False)

    print("Simulation complete.")
    print(period_summary.head())
    print(f"Wrote outputs to {OUTPUT_DIR}")


if __name__ == "__main__":
    main()
