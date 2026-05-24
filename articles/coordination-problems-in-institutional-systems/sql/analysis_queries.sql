-- Coordination systems analysis queries.

-- Aggregate coordination profile.
SELECT
    AVG(coordination_quality) AS avg_coordination_quality,
    AVG(high_alignment) AS high_alignment_rate,
    AVG(fragile_coordination) AS fragile_coordination_rate,
    AVG(high_burden_coordination) AS high_burden_coordination_rate,
    AVG(trust) AS avg_trust,
    AVG(communication_clarity) AS avg_communication_clarity,
    AVG(uncertainty) AS avg_uncertainty,
    AVG(adaptation_burden) AS avg_adaptation_burden
FROM coordination_units;

-- High alignment but low trust cases.
SELECT
    unit_id,
    coordination_quality,
    high_alignment,
    trust,
    communication_clarity,
    focal_salience,
    authority_signal,
    uncertainty,
    adaptation_burden,
    competing_standards
FROM coordination_units
WHERE high_alignment = 1
  AND trust < 40
ORDER BY trust ASC;

-- Coordination outcomes by adaptation burden band.
SELECT
    CASE
        WHEN adaptation_burden < 35 THEN 'low_adaptation_burden'
        WHEN adaptation_burden < 65 THEN 'moderate_adaptation_burden'
        ELSE 'high_adaptation_burden'
    END AS adaptation_burden_band,
    COUNT(*) AS units,
    AVG(coordination_quality) AS avg_coordination_quality,
    AVG(high_alignment) AS high_alignment_rate,
    AVG(high_burden_coordination) AS high_burden_coordination_rate,
    AVG(distributional_attention) AS avg_distributional_attention,
    AVG(trust) AS avg_trust,
    AVG(competing_standards) AS avg_competing_standards
FROM coordination_units
GROUP BY adaptation_burden_band
ORDER BY avg_coordination_quality DESC;

-- Dynamic periods with high coordination but high adaptation burden.
SELECT
    period,
    AVG(coordination_quality) AS avg_coordination_quality,
    AVG(coordination_rate) AS avg_coordination_rate,
    AVG(trust) AS avg_trust,
    AVG(adaptation_burden) AS avg_adaptation_burden,
    AVG(competing_standards) AS avg_competing_standards
FROM coordination_periods
GROUP BY period
HAVING avg_coordination_quality >= 0.60
   AND avg_adaptation_burden >= 0.65
ORDER BY period;
