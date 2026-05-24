-- Institutional path dependence analysis queries.

-- Aggregate lock-in profile.
SELECT
    AVG(path_dependence_score) AS avg_path_dependence,
    AVG(lock_in) AS lock_in_rate,
    AVG(strong_lock_in) AS strong_lock_in_rate,
    AVG(high_burden_lock_in) AS high_burden_lock_in_rate,
    AVG(disruption_pressure) AS avg_disruption_pressure,
    AVG(reform_capacity) AS avg_reform_capacity
FROM path_dependence_cases;

-- Highest path-dependence cases.
SELECT
    institution_id,
    path_dependence_score,
    legitimacy,
    switching_costs,
    increasing_returns,
    coordination_effects,
    complementarity,
    disruption_pressure,
    reform_capacity,
    distributional_burden
FROM path_dependence_cases
ORDER BY path_dependence_score DESC
LIMIT 10;

-- Lock-in outcomes by distributional burden band.
SELECT
    CASE
        WHEN distributional_burden < 35 THEN 'low_burden'
        WHEN distributional_burden < 65 THEN 'moderate_burden'
        ELSE 'high_burden'
    END AS burden_band,
    COUNT(*) AS institutions,
    AVG(path_dependence_score) AS avg_path_dependence,
    AVG(lock_in) AS lock_in_rate,
    AVG(strong_lock_in) AS strong_lock_in_rate,
    AVG(reform_capacity) AS avg_reform_capacity
FROM path_dependence_cases
GROUP BY burden_band
ORDER BY avg_path_dependence DESC;

-- Dynamic strong lock-in periods with high burden.
SELECT
    period,
    institution_id,
    path_strength,
    stay_probability,
    legitimacy,
    switching_costs,
    reform_capacity,
    distributional_burden
FROM path_dependence_periods
WHERE strong_lock_in = 1
  AND high_burden_lock_in = 1
ORDER BY period, path_strength DESC;
