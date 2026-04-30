"""Synthetic institutional psychology simulation.

This script creates toy longitudinal institutional data for article examples.
It is educational only and not a governance-rating, legal, compliance, or policy tool.
"""

from pathlib import Path
import csv
import math
import random

random.seed(2121)

n_units = 230
n_periods = 20

units = []

for unit_index in range(1, n_units + 1):
    units.append({
        "unit_id": f"U{unit_index:03d}",
        "legitimacy_strength": random.uniform(0.20, 0.90),
        "normative_stability": random.uniform(0.20, 0.90),
        "trust_density": random.uniform(0.20, 0.90),
        "information_flow_effectiveness": random.uniform(0.20, 0.90),
        "learning_capacity": random.uniform(0.20, 0.90),
        "memory_retention": random.uniform(0.20, 0.90),
    })

records = []
compliance_records = []
observation_id = 1
compliance_id = 1

def logistic(x: float) -> float:
    return 1.0 / (1.0 + math.exp(-x))

for period in range(1, n_periods + 1):
    cognitive_processing_quality = random.uniform(0.15, 0.95)
    fragmentation_pressure = random.uniform(0.10, 0.85)

    for unit in units:
        institutional_effectiveness = (
            0.14 * unit["legitimacy_strength"] +
            0.14 * unit["normative_stability"] +
            0.13 * unit["trust_density"] +
            0.12 * cognitive_processing_quality +
            0.12 * unit["information_flow_effectiveness"] +
            0.12 * unit["memory_retention"] +
            0.13 * unit["learning_capacity"] -
            0.16 * fragmentation_pressure +
            random.gauss(0.0, 0.03)
        )

        institutional_effectiveness = max(0.0, min(1.0, institutional_effectiveness))
        high_alignment = int(institutional_effectiveness >= 0.65)

        records.append({
            "observation_id": observation_id,
            "unit_id": unit["unit_id"],
            "period": period,
            "legitimacy_strength": round(unit["legitimacy_strength"], 3),
            "normative_stability": round(unit["normative_stability"], 3),
            "trust_density": round(unit["trust_density"], 3),
            "cognitive_processing_quality": round(cognitive_processing_quality, 3),
            "information_flow_effectiveness": round(unit["information_flow_effectiveness"], 3),
            "memory_retention": round(unit["memory_retention"], 3),
            "learning_capacity": round(unit["learning_capacity"], 3),
            "fragmentation_pressure": round(fragmentation_pressure, 3),
            "institutional_effectiveness": round(institutional_effectiveness, 3),
            "high_alignment": high_alignment,
        })

        perceived_legitimacy = unit["legitimacy_strength"]
        expected_compliance = unit["normative_stability"]
        procedural_trust = unit["trust_density"]
        norm_support = random.uniform(0.20, 0.90)
        role_identification = random.uniform(0.20, 0.90)
        uncertainty_pressure = fragmentation_pressure

        z = (
            -1.2 +
            1.1 * perceived_legitimacy +
            0.9 * expected_compliance +
            1.0 * procedural_trust +
            0.7 * norm_support +
            0.6 * role_identification -
            1.2 * uncertainty_pressure
        )

        alignment_probability = logistic(z)
        observed_alignment = int(random.random() < alignment_probability)

        compliance_records.append({
            "record_id": compliance_id,
            "unit_id": unit["unit_id"],
            "period": period,
            "perceived_legitimacy": round(perceived_legitimacy, 3),
            "expectation_of_others_compliance": round(expected_compliance, 3),
            "procedural_trust": round(procedural_trust, 3),
            "norm_support": round(norm_support, 3),
            "role_identification": round(role_identification, 3),
            "uncertainty_pressure": round(uncertainty_pressure, 3),
            "alignment_probability": round(alignment_probability, 3),
            "observed_alignment": observed_alignment,
        })

        unit["legitimacy_strength"] = max(
            0.0,
            min(1.0, unit["legitimacy_strength"] + 0.02 * (institutional_effectiveness - 0.4))
        )
        unit["trust_density"] = max(
            0.0,
            min(1.0, unit["trust_density"] + 0.02 * (institutional_effectiveness - 0.4))
        )
        unit["learning_capacity"] = max(
            0.0,
            min(1.0, unit["learning_capacity"] + 0.02 * (institutional_effectiveness - 0.4))
        )
        unit["memory_retention"] = max(
            0.0,
            min(1.0, unit["memory_retention"] + 0.015 * unit["learning_capacity"] - 0.010 * fragmentation_pressure)
        )

        observation_id += 1
        compliance_id += 1

processed = Path(__file__).resolve().parents[1] / "data" / "processed"
processed.mkdir(parents=True, exist_ok=True)

observations_path = processed / "synthetic_institutional_observations.csv"
compliance_path = processed / "synthetic_compliance_records.csv"

for path, rows in [
    (observations_path, records),
    (compliance_path, compliance_records),
]:
    with path.open("w", newline="", encoding="utf-8") as handle:
        writer = csv.DictWriter(handle, fieldnames=rows[0].keys())
        writer.writeheader()
        writer.writerows(rows)

print(f"Wrote {len(records)} institutional observations to {observations_path}")
print(f"Wrote {len(compliance_records)} compliance records to {compliance_path}")
