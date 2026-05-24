-- Compliance and rule-following behavior analysis queries.

-- Aggregate compliance profile.
SELECT
    AVG(compliance_quality) AS avg_compliance_quality,
    AVG(high_compliance) AS high_compliance_rate,
    AVG(fragile_compliance) AS fragile_compliance_rate,
    AVG(high_burden_compliance) AS high_burden_compliance_rate,
    AVG(legitimacy) AS avg_legitimacy,
    AVG(fairness) AS avg_fairness,
    AVG(cognitive_clarity) AS avg_cognitive_clarity,
    AVG(compliance_burden) AS avg_compliance_burden,
    AVG(selective_rule_application) AS avg_selective_rule_application
FROM compliance_rule_following_units;

-- High compliance but low legitimacy cases.
SELECT
    unit_id,
    compliance_quality,
    high_compliance,
    legitimacy,
    fairness,
    trust,
    communication_quality,
    cognitive_clarity,
    compliance_burden,
    selective_rule_application
FROM compliance_rule_following_units
WHERE high_compliance = 1
  AND legitimacy < 40
ORDER BY legitimacy ASC;

-- Compliance outcomes by compliance burden band.
SELECT
    CASE
        WHEN compliance_burden < 35 THEN 'low_compliance_burden'
        WHEN compliance_burden < 65 THEN 'moderate_compliance_burden'
        ELSE 'high_compliance_burden'
    END AS compliance_burden_band,
    COUNT(*) AS units,
    AVG(compliance_quality) AS avg_compliance_quality,
    AVG(high_compliance) AS high_compliance_rate,
    AVG(high_burden_compliance) AS high_burden_compliance_rate,
    AVG(selective_rule_application) AS avg_selective_rule_application,
    AVG(legitimacy) AS avg_legitimacy,
    AVG(cognitive_clarity) AS avg_cognitive_clarity
FROM compliance_rule_following_units
GROUP BY compliance_burden_band
ORDER BY avg_compliance_quality DESC;

-- Dynamic periods with high compliance but high burden and selective rule application.
SELECT
    period,
    AVG(comply) AS avg_compliance_rate,
    AVG(legitimacy) AS avg_legitimacy,
    AVG(fairness) AS avg_fairness,
    AVG(norm_support) AS avg_norm_support,
    AVG(trust) AS avg_trust,
    AVG(compliance_burden) AS avg_compliance_burden,
    AVG(selective_rule_application) AS avg_selective_rule_application
FROM compliance_rule_following_periods
GROUP BY period
HAVING avg_compliance_rate >= 0.65
   AND avg_compliance_burden >= 0.65
   AND avg_selective_rule_application >= 0.65
ORDER BY period;
