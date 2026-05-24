"""
Dynamic simulation of coordination problems in institutional systems.

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
    """Keep a value inside a defined range."""
    return max(lower, min(upper, value))


def initialize_agents(n_agents: int = 260, seed: int = 404) -> pd.DataFrame:
    """Initialize synthetic agents."""
    rng = np.random.default_rng(seed)

    return pd.DataFrame(
        {
            "agent_id": np.arange(1, n_agents + 1),
            "trust": rng.uniform(0.20, 0.90, n_agents),
            "focal_salience": rng.uniform(0.15, 0.95, n_agents),
            "norm_strength": rng.uniform(0.15, 0.90, n_agents),
            "adaptation_capacity": rng.uniform(0.20, 0.95, n_agents),
            "burden_sensitivity": rng.uniform(0.10, 0.90, n_agents),
        }
    )


def run_simulation(n_agents: int = 260, n_periods: int = 24, seed: int = 404) -> pd.DataFrame:
    """Run repeated coordination simulation."""
    rng = np.random.default_rng(seed)
    agents = initialize_agents(n_agents, seed)
    records: list[dict[str, float]] = []

    for period in range(1, n_periods + 1):
        communication = rng.uniform(0.15, 0.95)
        authority = rng.uniform(0.15, 0.95)
        information_quality = rng.uniform(0.20, 0.95)
        uncertainty = rng.uniform(0.10, 0.85)
        competing_standards = rng.uniform(0.05, 0.80)
        adaptation_burden = rng.uniform(0.05, 0.85)

        alignments = []

        for row_index, row in agents.iterrows():
            z = (
                -0.9
                + 1.35 * row["trust"]
                + 1.25 * row["focal_salience"]
                + 1.05 * row["norm_strength"]
                + 1.20 * communication
                + 1.00 * authority
                + 0.90 * information_quality
                + 0.60 * row["adaptation_capacity"]
                - 1.55 * uncertainty
                - 0.80 * competing_standards
                - 0.55 * adaptation_burden * row["burden_sensitivity"]
            )

            align_prob = 1 / (1 + np.exp(-z))
            aligned = rng.binomial(1, align_prob)
            alignments.append(aligned)

            trust_update = (
                row["trust"]
                + 0.045 * (aligned - 0.40)
                + 0.020 * (communication - 0.50)
                - 0.020 * competing_standards
            )

            focal_update = (
                row["focal_salience"]
                + 0.025 * (authority * communication)
                - 0.020 * uncertainty
                - 0.015 * competing_standards
            )

            agents.at[row_index, "trust"] = clamp(trust_update)
            agents.at[row_index, "focal_salience"] = clamp(focal_update)

        coordination_rate = sum(alignments) / n_agents

        coordination_quality = clamp(
            0.45 * coordination_rate
            + 0.18 * communication
            + 0.15 * information_quality
            + 0.12 * authority
            - 0.16 * uncertainty
            - 0.10 * competing_standards
            - 0.06 * adaptation_burden
        )

        fragile_coordination = int(
            coordination_quality >= 0.60 and agents["trust"].mean() < 0.40
        )

        high_burden_coordination = int(
            coordination_quality >= 0.60 and adaptation_burden >= 0.65
        )

        for idx, aligned in enumerate(alignments):
            records.append(
                {
                    "period": period,
                    "agent_id": idx + 1,
                    "communication": communication,
                    "authority": authority,
                    "information_quality": information_quality,
                    "uncertainty": uncertainty,
                    "competing_standards": competing_standards,
                    "adaptation_burden": adaptation_burden,
                    "aligned": aligned,
                    "coordination_rate": coordination_rate,
                    "coordination_quality": coordination_quality,
                    "trust": agents.at[idx, "trust"],
                    "focal_salience": agents.at[idx, "focal_salience"],
                    "norm_strength": agents.at[idx, "norm_strength"],
                    "adaptation_capacity": agents.at[idx, "adaptation_capacity"],
                    "fragile_coordination": fragile_coordination,
                    "high_burden_coordination": high_burden_coordination,
                }
            )

    return pd.DataFrame(records)


def main() -> None:
    results = run_simulation()

    period_summary = (
        results.groupby("period")[
            [
                "communication",
                "authority",
                "information_quality",
                "uncertainty",
                "competing_standards",
                "adaptation_burden",
                "aligned",
                "coordination_rate",
                "coordination_quality",
                "trust",
                "focal_salience",
                "fragile_coordination",
                "high_burden_coordination",
            ]
        ]
        .mean()
        .reset_index()
    )

    agent_summary = (
        results.groupby("agent_id")[
            [
                "aligned",
                "trust",
                "focal_salience",
                "norm_strength",
                "adaptation_capacity",
            ]
        ]
        .mean()
        .reset_index()
    )

    results["high_coordination"] = (results["coordination_quality"] >= 0.65).astype(int)

    coordination_rates = (
        results.groupby("period")["high_coordination"]
        .mean()
        .reset_index(name="high_coordination_rate")
    )

    fragile_periods = (
        period_summary[period_summary["fragile_coordination"] > 0]
        .sort_values(["fragile_coordination", "coordination_quality"], ascending=False)
    )

    high_burden_periods = (
        period_summary[period_summary["high_burden_coordination"] > 0]
        .sort_values(["high_burden_coordination", "adaptation_burden"], ascending=False)
    )

    results.to_csv(OUTPUT_DIR / "institutional_coordination_simulation.csv", index=False)
    period_summary.to_csv(OUTPUT_DIR / "institutional_coordination_period_summary.csv", index=False)
    agent_summary.to_csv(OUTPUT_DIR / "institutional_coordination_agent_summary.csv", index=False)
    coordination_rates.to_csv(OUTPUT_DIR / "institutional_coordination_rates.csv", index=False)
    fragile_periods.to_csv(OUTPUT_DIR / "institutional_coordination_fragile_periods.csv", index=False)
    high_burden_periods.to_csv(OUTPUT_DIR / "institutional_coordination_high_burden_periods.csv", index=False)

    print("Simulation complete.")
    print(period_summary.head())
    print(f"Wrote outputs to {OUTPUT_DIR}")


if __name__ == "__main__":
    main()
