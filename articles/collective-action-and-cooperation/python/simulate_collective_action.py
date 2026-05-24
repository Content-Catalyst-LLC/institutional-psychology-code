"""
Dynamic simulation of collective action and cooperation.

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


def initialize_agents(n_agents: int = 260, seed: int = 606) -> pd.DataFrame:
    """Initialize synthetic agents."""
    rng = np.random.default_rng(seed)

    return pd.DataFrame(
        {
            "agent_id": np.arange(1, n_agents + 1),
            "trust": rng.uniform(0.20, 0.90, n_agents),
            "legitimacy": rng.uniform(0.20, 0.90, n_agents),
            "norm_strength": rng.uniform(0.20, 0.90, n_agents),
            "perceived_fairness": rng.uniform(0.20, 0.90, n_agents),
            "free_riding_pressure": rng.uniform(0.10, 0.95, n_agents),
            "burden_sensitivity": rng.uniform(0.10, 0.90, n_agents),
        }
    )


def run_simulation(n_agents: int = 260, n_periods: int = 24, seed: int = 606) -> pd.DataFrame:
    """Run repeated collective action simulation."""
    rng = np.random.default_rng(seed)
    agents = initialize_agents(n_agents, seed)
    records: list[dict[str, float]] = []

    for period in range(1, n_periods + 1):
        enforcement = rng.uniform(0.15, 0.95)
        communication = rng.uniform(0.15, 0.95)
        coordination = rng.uniform(0.15, 0.95)
        burden_inequality = rng.uniform(0.05, 0.85)
        hypocrisy_visibility = rng.uniform(0.05, 0.85)

        cooperation_list = []

        for row_index, row in agents.iterrows():
            z = (
                -0.9
                + 1.35 * row["trust"]
                + 1.30 * row["legitimacy"]
                + 1.20 * row["norm_strength"]
                + 1.00 * enforcement
                + 0.90 * communication
                + 0.85 * coordination
                + 0.80 * row["perceived_fairness"]
                - 1.55 * row["free_riding_pressure"]
                - 0.75 * burden_inequality * row["burden_sensitivity"]
                - 0.65 * hypocrisy_visibility
            )

            cooperate_prob = 1 / (1 + np.exp(-z))
            cooperate = rng.binomial(1, cooperate_prob)
            cooperation_list.append(cooperate)

            agents.at[row_index, "trust"] = clamp(
                row["trust"]
                + 0.035 * (cooperate - 0.40)
                + 0.015 * communication
                - 0.025 * hypocrisy_visibility
            )

            agents.at[row_index, "legitimacy"] = clamp(
                row["legitimacy"]
                + 0.020 * enforcement
                + 0.020 * row["perceived_fairness"]
                - 0.025 * burden_inequality
                - 0.020 * hypocrisy_visibility
            )

            agents.at[row_index, "norm_strength"] = clamp(
                row["norm_strength"]
                + 0.030 * (cooperate - 0.40)
                + 0.015 * coordination
                - 0.020 * hypocrisy_visibility
            )

            agents.at[row_index, "perceived_fairness"] = clamp(
                row["perceived_fairness"]
                + 0.015 * (1 - burden_inequality)
                - 0.020 * burden_inequality
                - 0.015 * hypocrisy_visibility
            )

        cooperation_rate = sum(cooperation_list) / n_agents

        collective_action_quality = clamp(
            0.38 * cooperation_rate
            + 0.17 * agents["trust"].mean()
            + 0.16 * agents["legitimacy"].mean()
            + 0.14 * agents["norm_strength"].mean()
            + 0.10 * enforcement
            + 0.08 * communication
            + 0.08 * coordination
            - 0.12 * burden_inequality
            - 0.10 * hypocrisy_visibility
        )

        fragile_collective_action = int(
            collective_action_quality >= 0.60 and agents["trust"].mean() < 0.40
        )

        high_burden_collective_action = int(
            collective_action_quality >= 0.60 and burden_inequality >= 0.65
        )

        for idx, cooperate in enumerate(cooperation_list):
            records.append(
                {
                    "period": period,
                    "agent_id": idx + 1,
                    "enforcement": enforcement,
                    "communication": communication,
                    "coordination": coordination,
                    "burden_inequality": burden_inequality,
                    "hypocrisy_visibility": hypocrisy_visibility,
                    "cooperate": cooperate,
                    "cooperation_rate": cooperation_rate,
                    "collective_action_quality": collective_action_quality,
                    "trust": agents.at[idx, "trust"],
                    "legitimacy": agents.at[idx, "legitimacy"],
                    "norm_strength": agents.at[idx, "norm_strength"],
                    "perceived_fairness": agents.at[idx, "perceived_fairness"],
                    "free_riding_pressure": agents.at[idx, "free_riding_pressure"],
                    "fragile_collective_action": fragile_collective_action,
                    "high_burden_collective_action": high_burden_collective_action,
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
                "coordination",
                "burden_inequality",
                "hypocrisy_visibility",
                "cooperate",
                "cooperation_rate",
                "collective_action_quality",
                "trust",
                "legitimacy",
                "norm_strength",
                "perceived_fairness",
                "fragile_collective_action",
                "high_burden_collective_action",
            ]
        ]
        .mean()
        .reset_index()
    )

    agent_summary = (
        results.groupby("agent_id")[
            [
                "cooperate",
                "trust",
                "legitimacy",
                "norm_strength",
                "perceived_fairness",
                "free_riding_pressure",
            ]
        ]
        .mean()
        .reset_index()
    )

    results["high_cooperation"] = (results["cooperation_rate"] >= 0.65).astype(int)

    cooperation_rates = (
        results.groupby("period")["high_cooperation"]
        .mean()
        .reset_index(name="high_cooperation_rate")
    )

    fragile_periods = (
        period_summary[period_summary["fragile_collective_action"] > 0]
        .sort_values(["fragile_collective_action", "collective_action_quality"], ascending=False)
    )

    high_burden_periods = (
        period_summary[period_summary["high_burden_collective_action"] > 0]
        .sort_values(["high_burden_collective_action", "burden_inequality"], ascending=False)
    )

    results.to_csv(OUTPUT_DIR / "collective_action_institutional_systems_simulation.csv", index=False)
    period_summary.to_csv(OUTPUT_DIR / "collective_action_period_summary.csv", index=False)
    agent_summary.to_csv(OUTPUT_DIR / "collective_action_agent_summary.csv", index=False)
    cooperation_rates.to_csv(OUTPUT_DIR / "collective_action_cooperation_rates.csv", index=False)
    fragile_periods.to_csv(OUTPUT_DIR / "collective_action_fragile_periods.csv", index=False)
    high_burden_periods.to_csv(OUTPUT_DIR / "collective_action_high_burden_periods.csv", index=False)

    print("Simulation complete.")
    print(period_summary.head())
    print(f"Wrote outputs to {OUTPUT_DIR}")


if __name__ == "__main__":
    main()
