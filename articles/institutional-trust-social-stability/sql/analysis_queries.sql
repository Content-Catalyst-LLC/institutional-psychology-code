-- Institutional trust and social stability analysis queries.

-- Aggregate trust and stability profile.
SELECT
    AVG(trust_score) AS avg_trust_score,
    AVG(social_stability) AS avg_social_stability,
    AVG(high_trust) AS high_trust_rate,
    AVG(high_stability) AS high_stability_rate,
    AVG(fragile_trust_environment) AS fragile_trust_environment_rate,
    AVG(high_distrust_pressure) AS high_distrust_pressure_rate,
    AVG(fairness) AS avg_fairness,
    AVG(accountability) AS avg_accountability,
    AVG(repair_capacity) AS avg_repair_capacity,
    AVG(arbitrariness_pressure) AS avg_arbitrariness_pressure
FROM institutional_trust_units;

-- Fragile trust environments.
SELECT
    unit_id,
    trust_score,
    social_stability,
    fairness,
    accountability,
    transparency,
    integrity,
    recognition_voice,
    repair_capacity,
    arbitrariness_pressure,
    visible_violation_pressure
FROM institutional_trust_units
WHERE high_trust = 1
  AND fairness < 40
  AND accountability < 40
ORDER BY fairness ASC, accountability ASC;

-- High-distrust pressure environments.
SELECT
    unit_id,
    trust_score,
    social_stability,
    arbitrariness_pressure,
    visible_violation_pressure,
    administrative_burden,
    repair_capacity,
    fairness,
    accountability,
    recognition_voice
FROM institutional_trust_units
WHERE arbitrariness_pressure > 70
  AND visible_violation_pressure > 65
  AND repair_capacity < 40
ORDER BY arbitrariness_pressure DESC, visible_violation_pressure DESC;

-- Trust and stability by repair-capacity band.
SELECT
    CASE
        WHEN repair_capacity < 35 THEN 'low_repair_capacity'
        WHEN repair_capacity < 70 THEN 'moderate_repair_capacity'
        ELSE 'high_repair_capacity'
    END AS repair_capacity_band,
    COUNT(*) AS units,
    AVG(trust_score) AS avg_trust_score,
    AVG(social_stability) AS avg_social_stability,
    AVG(high_trust) AS high_trust_rate,
    AVG(high_stability) AS high_stability_rate,
    AVG(fairness) AS avg_fairness,
    AVG(accountability) AS avg_accountability,
    AVG(arbitrariness_pressure) AS avg_arbitrariness_pressure,
    AVG(visible_violation_pressure) AS avg_visible_violation_pressure
FROM institutional_trust_units
GROUP BY repair_capacity_band
ORDER BY avg_trust_score DESC;
