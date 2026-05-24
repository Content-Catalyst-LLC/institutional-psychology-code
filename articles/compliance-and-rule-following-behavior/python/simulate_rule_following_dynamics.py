"""
Dynamic simulation of compliance and rule-following behavior.

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


def initialize_agents(n_agents: int = 260, seed: int = 1001) -> pd.DataFrame:
    """Initialize synthetic agents."""
    rng = np.random.default_rng(seed)

    return pd.DataFrame(
        {
            "agent_id": np.arange(1, n_agents + 1),
            "legitimacy": rng.uniform(0.20, 0.90, n_agents),
            "fairness": rng.uniform(0.20, 0.90, n_agents),
            "norm_support": rng.uniform(0.20, 0.90, n_agents),
            "trust": rng.uniform(0.20, 0.90, n_agents),
            "burden_sensitivity": rng.uniform(0.10, 0.90, n_agents),
        }
    )


def run_simulation(n_agents: int = 260, n_periods: int = 24, seed: int = 1001) -> pd.DataFrame:
    """Run repeated rule-following simulation."""
    rng = np.random.default_rng(seed)
    agents = initialize_agents(n_agents, seed)
    records: list[dict[str, float]] = []

    for period in range(1, n_periods + 1):
        enforcement = rng.uniform(0.15, 0.95)
        communication = rng.uniform(0.15, 0.95)
        clarity = rng.uniform(0.15, 0.95)
        compliance_burden = rng.uniform(0.05, 0.85)
        selective_rule_application = rng.uniform(0.05, 0.85)
        hypocrisy_visibility = rng.uniform(0.05, 0.85)

        for index, row in agents.iterrows():
            z = (
                -0.95
                + 1.35 * row["legitimacy"]
                + 1.25 * row["fairness"]
                + 1.10 * row["norm_support"]
                + 1.05 * row["trust"]
                + 1.00 * enforcement
                + 1.10 * communication
                + 1.15 * clarity
                - 1.45 * compliance_burden * row["burden_sensitivity"]
                - 1.05 * selective_rule_application
                - 0.90 * hypocrisy_visibility
            )

            comply_probability = 1 / (1 + np.exp(-z))
            comply = rng.binomial(1, comply_probability)

            agents.at[index, "legitimacy"] = clamp(
                row["legitimacy"]
                + 0.025 * (comply - 0.45)
                + 0.015 * row["fairness"]
                - 0.020 * selective_rule_application
                - 0.015 * hypocrisy_visibility
                - 0.010 * compliance_burden
            )

            agents.at[index, "fairness"] = clamp(
                row["fairness"]
                + 0.020 * (comply - 0.45)
                + 0.015 * communication
                - 0.020 * selective_rule_application
                - 0.010 * compliance_burden
            )

            agents.at[index, "trust"] = clamp(
                row["trust"]
                + 0.020 * (comply - 0.45)
                + 0.015 * clarity
                - 0.020 * hypocrisy_visibility
                - 0.015 * selective_rule_application
            )

            agents.at[index, "norm_support"] = clamp(
                row["norm_support"]
                + 0.015 * (comply - 0.40)
                - 0.015 * selective_rule_application
                - 0.010 * hypocrisy_visibility
            )

            records.append(
                {
                    "period": period,
                    "agent_id": row["agent_id"],
                    "enforcement": enforcement,
                    "communication": communication,
                    "clarity": clarity,
                    "compliance_burden": compliance_burden,
                    "selective_rule_application": selective_rule_application,
                    "hypocrisy_visibility": hypocrisy_visibility,
                    "comply_probability": comply_probability,
                    "comply": comply,
                    "legitimacy": agents.at[index, "legitimacy"],
                    "fairness": agents.at[index, "fairness"],
                    "norm_support": agents.at[index, "norm_support"],
                    "trust": agents.at[index, "trust"],
                }
            )

    return pd.DataFrame(records)


def main() -> None:
    results = run_simulation()

    period_summary = (
        results.groupby("period")[
            [
                "enforcement",
                "communication",
                "clarity",
                "compliance_burden",
                "selective_rule_application",
                "hypocrisy_visibility",
                "comply",
                "comply_probability",
                "legitimacy",
                "fairness",
                "norm_support",
                "trust",
            ]
        ]
        .mean()
        .reset_index()
    )

    period_summary["high_compliance"] = (period_summary["comply"] >= 0.65).astype(int)
    period_summary["fragile_compliance"] = (
        (period_summary["comply"] >= 0.65)
        & (period_summary["legitimacy"] < 0.40)
    ).astype(int)
    period_summary["high_burden_compliance"] = (
        (period_summary["comply"] >= 0.65)
        & (period_summary["compliance_burden"] >= 0.65)
        & (period_summary["selective_rule_application"] >= 0.65)
    ).astype(int)

    agent_summary = (
        results.groupby("agent_id")[
            [
                "comply",
                "comply_probability",
                "legitimacy",
                "fairness",
                "norm_support",
                "trust",
            ]
        ]
        .mean()
        .reset_index()
    )

    fragile_periods = period_summary[
        (period_summary["high_compliance"] == 1)
        & (period_summary["legitimacy"] < 0.40)
    ].sort_values("comply", ascending=False)

    high_burden_periods = period_summary[
        (period_summary["high_compliance"] == 1)
        & (period_summary["compliance_burden"] >= 0.65)
        & (period_summary["selective_rule_application"] >= 0.65)
    ].sort_values("compliance_burden", ascending=False)

    results.to_csv(OUTPUT_DIR / "compliance_rule_following_behavior_simulation.csv", index=False)
    period_summary.to_csv(OUTPUT_DIR / "compliance_rule_following_period_summary.csv", index=False)
    agent_summary.to_csv(OUTPUT_DIR / "compliance_rule_following_agent_summary.csv", index=False)
    fragile_periods.to_csv(OUTPUT_DIR / "compliance_rule_following_fragile_periods.csv", index=False)
    high_burden_periods.to_csv(OUTPUT_DIR / "compliance_rule_following_high_burden_periods.csv", index=False)

    print("Simulation complete.")
    print(period_summary.head())
    print(f"Wrote outputs to {OUTPUT_DIR}")


if __name__ == "__main__":
    main()
