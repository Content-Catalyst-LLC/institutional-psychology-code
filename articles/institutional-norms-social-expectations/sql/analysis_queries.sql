-- Institutional norms and social expectations analysis queries.

-- Aggregate norm stability and coordination profile.
SELECT
    AVG(normative_stability) AS avg_normative_stability,
    AVG(high_coordination) AS high_coordination_rate,
    AVG(fragile_normative_environment) AS fragile_normative_environment_rate,
    AVG(suppressive_norm_environment) AS suppressive_norm_environment_rate,
    AVG(norm_change_readiness) AS avg_norm_change_readiness,
    AVG(expectation_convergence) AS avg_expectation_convergence,
    AVG(legitimacy_alignment) AS avg_legitimacy_alignment,
    AVG(internalization) AS avg_internalization,
    AVG(fragmentation_pressure) AS avg_fragmentation_pressure
FROM institutional_norm_units;

-- Fragile normative environments.
SELECT
    unit_id,
    normative_stability,
    high_coordination,
    expectation_convergence,
    legitimacy_alignment,
    internalization,
    social_enforcement,
    trust_reinforcement,
    fragmentation_pressure,
    unequal_normative_burden,
    norm_change_readiness
FROM institutional_norm_units
WHERE normative_stability >= 60
  AND expectation_convergence < 40
  AND legitimacy_alignment < 40
ORDER BY expectation_convergence ASC, legitimacy_alignment ASC;

-- Suppressive norm environments.
SELECT
    unit_id,
    normative_stability,
    social_enforcement,
    suppressive_pressure,
    learning_capacity,
    legitimacy_alignment,
    trust_reinforcement,
    unequal_normative_burden,
    norm_change_readiness
FROM institutional_norm_units
WHERE social_enforcement > 70
  AND suppressive_pressure > 65
  AND learning_capacity < 40
ORDER BY social_enforcement DESC, suppressive_pressure DESC;

-- Norms by learning-capacity band.
SELECT
    CASE
        WHEN learning_capacity < 35 THEN 'low_learning_capacity'
        WHEN learning_capacity < 70 THEN 'moderate_learning_capacity'
        ELSE 'high_learning_capacity'
    END AS learning_capacity_band,
    COUNT(*) AS units,
    AVG(normative_stability) AS avg_normative_stability,
    AVG(high_coordination) AS high_coordination_rate,
    AVG(norm_change_readiness) AS avg_norm_change_readiness,
    AVG(suppressive_pressure) AS avg_suppressive_pressure,
    AVG(unequal_normative_burden) AS avg_unequal_normative_burden,
    AVG(fragmentation_pressure) AS avg_fragmentation_pressure
FROM institutional_norm_units
GROUP BY learning_capacity_band
ORDER BY avg_normative_stability DESC;
