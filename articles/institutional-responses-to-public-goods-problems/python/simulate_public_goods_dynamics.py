"""
Dynamic simulation of public goods contribution and provision.

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


def initialize_agents(n_agents: int = 300, seed: int = 303) -> pd.DataFrame:
    """Initialize synthetic agents."""
    rng = np.random.default_rng(seed)

    return pd.DataFrame(
        {
            "agent_id": np.arange(1, n_agents + 1),
            "trust": rng.uniform(0.20, 0.90, n_agents),
            "legitimacy": rng.uniform(0.20, 0.90, n_agents),
            "norm_strength": rng.uniform(0.15, 0.90, n_agents),
            "perceived_fairness": rng.uniform(0.15, 0.90, n_agents),
            "free_ride_opportunity": rng.uniform(0.10, 0.95, n_agents),
            "burden_sensitivity": rng.uniform(0.10, 0.90, n_agents),
        }
    )


def run_simulation(n_agents: int = 300, n_periods: int = 24, seed: int = 303) -> pd.DataFrame:
    """Run repeated public goods contribution simulation."""
    rng = np.random.default_rng(seed)
    agents = initialize_agents(n_agents, seed)
    records: list[dict[str, float]] = []

    for period in range(1, n_periods + 1):
        enforcement = rng.uniform(0.15, 0.95)
        monitoring = rng.uniform(0.15, 0.95)
        scale_complexity = rng.uniform(0.20, 0.90)
        institutional_competence = rng.uniform(0.25, 0.95)

        contributions = []

        for row_index, row in agents.iterrows():
            z = (
                -1.1
                + 1.5 * row["trust"]
                + 1.4 * row["legitimacy"]
                + 1.2 * row["norm_strength"]
                + 1.0 * enforcement
                + 0.9 * monitoring
                + 0.8 * row["perceived_fairness"]
                - 1.6 * row["free_ride_opportunity"]
                - 0.7 * scale_complexity
            )

            contribute_prob = 1 / (1 + np.exp(-z))
            contribution = rng.binomial(1, contribute_prob)
            contributions.append(contribution)

            trust_update = (
                row["trust"]
                + 0.04 * (contribution - 0.40)
                + 0.03 * (institutional_competence - 0.50)
                - 0.02 * row["burden_sensitivity"]
            )

            legitimacy_update = (
                row["legitimacy"]
                + 0.03 * (institutional_competence - 0.50)
                + 0.02 * row["perceived_fairness"]
                + 0.01 * enforcement
                - 0.02 * scale_complexity
            )

            agents.at[row_index, "trust"] = clamp(trust_update)
            agents.at[row_index, "legitimacy"] = clamp(legitimacy_update)

        total_contributions = sum(contributions)
        provision_level = total_contributions / n_agents

        provision_quality = clamp(
            0.65 * provision_level
            + 0.25 * institutional_competence
            + 0.10 * monitoring
            - 0.15 * scale_complexity
        )

        for idx, contribution in enumerate(contributions):
            records.append(
                {
                    "period": period,
                    "agent_id": idx + 1,
                    "enforcement": enforcement,
                    "monitoring": monitoring,
                    "scale_complexity": scale_complexity,
                    "institutional_competence": institutional_competence,
                    "contribution": contribution,
                    "provision_level": provision_level,
                    "provision_quality": provision_quality,
                    "trust": agents.at[idx, "trust"],
                    "legitimacy": agents.at[idx, "legitimacy"],
                    "norm_strength": agents.at[idx, "norm_strength"],
                    "perceived_fairness": agents.at[idx, "perceived_fairness"],
                    "free_ride_opportunity": agents.at[idx, "free_ride_opportunity"],
                }
            )

    return pd.DataFrame(records)


def main() -> None:
    results = run_simulation()

    period_summary = (
        results.groupby("period")[
            [
                "enforcement",
                "monitoring",
                "scale_complexity",
                "institutional_competence",
                "contribution",
                "provision_level",
                "provision_quality",
                "trust",
                "legitimacy",
            ]
        ]
        .mean()
        .reset_index()
    )

    agent_summary = (
        results.groupby("agent_id")[
            [
                "contribution",
                "trust",
                "legitimacy",
                "norm_strength",
                "perceived_fairness",
                "free_ride_opportunity",
            ]
        ]
        .mean()
        .reset_index()
    )

    results["high_provision"] = (results["provision_quality"] >= 0.60).astype(int)

    provision_rates = (
        results.groupby("period")["high_provision"]
        .mean()
        .reset_index(name="high_provision_rate")
    )

    period_summary["fragile_provision"] = (
        (period_summary["provision_quality"] >= 0.60)
        & (period_summary["legitimacy"] < 0.40)
    ).astype(int)

    fragile_periods = period_summary[period_summary["fragile_provision"] == 1]

    results.to_csv(OUTPUT_DIR / "institutional_public_goods_simulation.csv", index=False)
    period_summary.to_csv(OUTPUT_DIR / "institutional_public_goods_period_summary.csv", index=False)
    agent_summary.to_csv(OUTPUT_DIR / "institutional_public_goods_agent_summary.csv", index=False)
    provision_rates.to_csv(OUTPUT_DIR / "institutional_public_goods_provision_rates.csv", index=False)
    fragile_periods.to_csv(OUTPUT_DIR / "institutional_public_goods_fragile_periods.csv", index=False)

    print("Simulation complete.")
    print(period_summary.head())
    print(f"Wrote outputs to {OUTPUT_DIR}")


if __name__ == "__main__":
    main()
