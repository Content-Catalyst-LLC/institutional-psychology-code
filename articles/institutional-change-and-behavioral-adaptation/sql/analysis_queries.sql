-- Institutional change and behavioral adaptation analysis queries.

-- Aggregate adaptation profile.
SELECT
    AVG(change_score) AS avg_change_score,
    AVG(successful_adaptation) AS successful_adaptation_rate,
    AVG(fragile_adaptation) AS fragile_adaptation_rate,
    AVG(high_transition_burden) AS high_transition_burden_rate,
    AVG(feedback_quality) AS avg_feedback_quality,
    AVG(governance_capacity) AS avg_governance_capacity,
    AVG(path_dependence) AS avg_path_dependence
FROM institutional_change_cases;

-- High-change but fragile adaptation cases.
SELECT
    institution_id,
    change_score,
    legitimacy,
    governance_capacity,
    coordination_quality,
    transition_burden,
    distributional_attention
FROM institutional_change_cases
WHERE successful_adaptation = 1
  AND legitimacy < 45
ORDER BY legitimacy ASC;

-- Adaptation outcomes by transition burden band.
SELECT
    CASE
        WHEN transition_burden < 35 THEN 'low_transition_burden'
        WHEN transition_burden < 65 THEN 'moderate_transition_burden'
        ELSE 'high_transition_burden'
    END AS transition_burden_band,
    COUNT(*) AS institutions,
    AVG(change_score) AS avg_change_score,
    AVG(successful_adaptation) AS successful_adaptation_rate,
    AVG(fragile_adaptation) AS fragile_adaptation_rate,
    AVG(legitimacy) AS avg_legitimacy,
    AVG(distributional_attention) AS avg_distributional_attention
FROM institutional_change_cases
GROUP BY transition_burden_band
ORDER BY avg_change_score DESC;

-- Dynamic high-change periods with fragile adaptation.
SELECT
    period,
    institution_id,
    adaptation_pressure,
    institutional_strength,
    legitimacy,
    path_dependence,
    transition_burden
FROM institutional_change_periods
WHERE high_change = 1
  AND fragile_adaptation = 1
ORDER BY period, adaptation_pressure DESC;
