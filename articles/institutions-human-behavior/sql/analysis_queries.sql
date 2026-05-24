-- Institutions and human behavior analysis queries.

-- Aggregate institutional-behavior profile.
SELECT
    AVG(institutional_strength) AS avg_institutional_strength,
    AVG(behavioral_alignment) AS avg_behavioral_alignment,
    AVG(high_institutional_alignment) AS high_institutional_alignment_rate,
    AVG(high_behavioral_alignment) AS high_behavioral_alignment_rate,
    AVG(fragile_institutional_environment) AS fragile_institutional_environment_rate,
    AVG(high_fragmentation_environment) AS high_fragmentation_environment_rate,
    AVG(legitimacy_strength) AS avg_legitimacy_strength,
    AVG(normative_stability) AS avg_normative_stability,
    AVG(information_quality) AS avg_information_quality,
    AVG(learning_capacity) AS avg_learning_capacity,
    AVG(fragmentation_pressure) AS avg_fragmentation_pressure
FROM institutional_behavior_units;

-- Fragile institutional environments.
SELECT
    unit_id,
    institutional_strength,
    behavioral_alignment,
    legitimacy_strength,
    normative_stability,
    information_quality,
    learning_capacity,
    trust_reinforcement,
    fragmentation_pressure,
    opacity_pressure,
    administrative_burden
FROM institutional_behavior_units
WHERE institutional_strength >= 60
  AND legitimacy_strength < 40
  AND normative_stability < 40
ORDER BY legitimacy_strength ASC, normative_stability ASC;

-- High-fragmentation environments.
SELECT
    unit_id,
    institutional_strength,
    behavioral_alignment,
    fragmentation_pressure,
    opacity_pressure,
    administrative_burden,
    repair_capacity,
    legitimacy_strength,
    trust_reinforcement,
    learning_capacity
FROM institutional_behavior_units
WHERE fragmentation_pressure > 70
  AND opacity_pressure > 65
  AND repair_capacity < 40
ORDER BY fragmentation_pressure DESC, opacity_pressure DESC;

-- Institutions by learning-capacity band.
SELECT
    CASE
        WHEN learning_capacity < 35 THEN 'low_learning_capacity'
        WHEN learning_capacity < 70 THEN 'moderate_learning_capacity'
        ELSE 'high_learning_capacity'
    END AS learning_capacity_band,
    COUNT(*) AS units,
    AVG(institutional_strength) AS avg_institutional_strength,
    AVG(behavioral_alignment) AS avg_behavioral_alignment,
    AVG(high_institutional_alignment) AS high_institutional_alignment_rate,
    AVG(high_behavioral_alignment) AS high_behavioral_alignment_rate,
    AVG(fragmentation_pressure) AS avg_fragmentation_pressure,
    AVG(opacity_pressure) AS avg_opacity_pressure,
    AVG(administrative_burden) AS avg_administrative_burden,
    AVG(repair_capacity) AS avg_repair_capacity
FROM institutional_behavior_units
GROUP BY learning_capacity_band
ORDER BY avg_institutional_strength DESC;
