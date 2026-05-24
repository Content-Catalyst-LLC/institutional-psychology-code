-- Social norms and institutional cooperation analysis queries.

-- Aggregate norm cooperation profile.
SELECT
    AVG(cooperation_score) AS avg_cooperation_score,
    AVG(high_norm_compliance) AS high_norm_compliance_rate,
    AVG(fragile_norm_environment) AS fragile_norm_environment_rate,
    AVG(high_burden_norm_environment) AS high_burden_norm_environment_rate,
    AVG(trust) AS avg_trust,
    AVG(legitimacy) AS avg_legitimacy,
    AVG(norm_conflict) AS avg_norm_conflict,
    AVG(unequal_enforcement) AS avg_unequal_enforcement
FROM social_norm_units;

-- High compliance but low trust cases.
SELECT
    unit_id,
    cooperation_score,
    high_norm_compliance,
    trust,
    legitimacy,
    descriptive_norm,
    injunctive_norm,
    norm_conflict,
    hypocrisy_visibility,
    unequal_enforcement
FROM social_norm_units
WHERE high_norm_compliance = 1
  AND trust < 40
ORDER BY trust ASC;

-- Norm cooperation outcomes by unequal enforcement band.
SELECT
    CASE
        WHEN unequal_enforcement < 35 THEN 'low_unequal_enforcement'
        WHEN unequal_enforcement < 65 THEN 'moderate_unequal_enforcement'
        ELSE 'high_unequal_enforcement'
    END AS unequal_enforcement_band,
    COUNT(*) AS units,
    AVG(cooperation_score) AS avg_cooperation_score,
    AVG(high_norm_compliance) AS high_norm_compliance_rate,
    AVG(high_burden_norm_environment) AS high_burden_norm_environment_rate,
    AVG(distributional_attention) AS avg_distributional_attention,
    AVG(trust) AS avg_trust,
    AVG(legitimacy) AS avg_legitimacy
FROM social_norm_units
GROUP BY unequal_enforcement_band
ORDER BY avg_cooperation_score DESC;

-- Dynamic periods with high norm quality but high unequal enforcement.
SELECT
    period,
    AVG(norm_cooperation_quality) AS avg_norm_cooperation_quality,
    AVG(compliance_rate) AS avg_compliance_rate,
    AVG(trust) AS avg_trust,
    AVG(legitimacy) AS avg_legitimacy,
    AVG(unequal_enforcement) AS avg_unequal_enforcement,
    AVG(hypocrisy_visibility) AS avg_hypocrisy_visibility
FROM social_norm_periods
GROUP BY period
HAVING avg_norm_cooperation_quality >= 0.60
   AND avg_unequal_enforcement >= 0.65
ORDER BY period;
