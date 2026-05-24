-- Collective action and cooperation analysis queries.

-- Aggregate cooperation profile.
SELECT
    AVG(cooperation_score) AS avg_cooperation_score,
    AVG(high_cooperation) AS high_cooperation_rate,
    AVG(fragile_cooperation) AS fragile_cooperation_rate,
    AVG(high_burden_cooperation) AS high_burden_cooperation_rate,
    AVG(trust) AS avg_trust,
    AVG(legitimacy) AS avg_legitimacy,
    AVG(free_riding_pressure) AS avg_free_riding_pressure,
    AVG(burden_inequality) AS avg_burden_inequality
FROM collective_action_units;

-- High cooperation but low trust cases.
SELECT
    unit_id,
    cooperation_score,
    high_cooperation,
    trust,
    legitimacy,
    norm_strength,
    enforcement_credibility,
    free_riding_pressure,
    burden_inequality
FROM collective_action_units
WHERE high_cooperation = 1
  AND trust < 40
ORDER BY trust ASC;

-- Cooperation outcomes by burden inequality band.
SELECT
    CASE
        WHEN burden_inequality < 35 THEN 'low_burden_inequality'
        WHEN burden_inequality < 65 THEN 'moderate_burden_inequality'
        ELSE 'high_burden_inequality'
    END AS burden_inequality_band,
    COUNT(*) AS units,
    AVG(cooperation_score) AS avg_cooperation_score,
    AVG(high_cooperation) AS high_cooperation_rate,
    AVG(high_burden_cooperation) AS high_burden_cooperation_rate,
    AVG(perceived_fairness) AS avg_perceived_fairness,
    AVG(trust) AS avg_trust,
    AVG(legitimacy) AS avg_legitimacy
FROM collective_action_units
GROUP BY burden_inequality_band
ORDER BY avg_cooperation_score DESC;

-- Dynamic periods with high cooperation but high burden inequality.
SELECT
    period,
    AVG(collective_action_quality) AS avg_collective_action_quality,
    AVG(cooperation_rate) AS avg_cooperation_rate,
    AVG(trust) AS avg_trust,
    AVG(legitimacy) AS avg_legitimacy,
    AVG(burden_inequality) AS avg_burden_inequality,
    AVG(hypocrisy_visibility) AS avg_hypocrisy_visibility
FROM collective_action_periods
GROUP BY period
HAVING avg_collective_action_quality >= 0.60
   AND avg_burden_inequality >= 0.65
ORDER BY period;
