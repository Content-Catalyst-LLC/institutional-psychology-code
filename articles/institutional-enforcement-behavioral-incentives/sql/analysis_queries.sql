-- Institutional enforcement and behavioral incentives analysis queries.

-- Aggregate enforcement profile.
SELECT
    AVG(enforcement_effectiveness) AS avg_enforcement_effectiveness,
    AVG(high_compliance_quality) AS high_compliance_quality_rate,
    AVG(fragile_enforcement) AS fragile_enforcement_rate,
    AVG(high_burden_enforcement) AS high_burden_enforcement_rate,
    AVG(legitimacy) AS avg_legitimacy,
    AVG(information_quality) AS avg_information_quality,
    AVG(evasion_pressure) AS avg_evasion_pressure,
    AVG(compliance_burden) AS avg_compliance_burden,
    AVG(selective_enforcement) AS avg_selective_enforcement
FROM institutional_enforcement_units;

-- High enforcement but low legitimacy cases.
SELECT
    unit_id,
    enforcement_effectiveness,
    high_compliance_quality,
    legitimacy,
    monitoring_quality,
    information_quality,
    sanction_credibility,
    evasion_pressure,
    compliance_burden,
    selective_enforcement
FROM institutional_enforcement_units
WHERE high_compliance_quality = 1
  AND legitimacy < 40
ORDER BY legitimacy ASC;

-- Enforcement outcomes by compliance burden band.
SELECT
    CASE
        WHEN compliance_burden < 35 THEN 'low_compliance_burden'
        WHEN compliance_burden < 65 THEN 'moderate_compliance_burden'
        ELSE 'high_compliance_burden'
    END AS compliance_burden_band,
    COUNT(*) AS units,
    AVG(enforcement_effectiveness) AS avg_enforcement_effectiveness,
    AVG(high_compliance_quality) AS high_compliance_quality_rate,
    AVG(high_burden_enforcement) AS high_burden_enforcement_rate,
    AVG(selective_enforcement) AS avg_selective_enforcement,
    AVG(legitimacy) AS avg_legitimacy,
    AVG(accountability_reach) AS avg_accountability_reach
FROM institutional_enforcement_units
GROUP BY compliance_burden_band
ORDER BY avg_enforcement_effectiveness DESC;

-- Dynamic periods with high enforcement but high burden and selective enforcement.
SELECT
    period,
    AVG(enforcement_score) AS avg_enforcement_score,
    AVG(legitimacy) AS avg_legitimacy,
    AVG(information_quality) AS avg_information_quality,
    AVG(evasion_pressure) AS avg_evasion_pressure,
    AVG(compliance_burden) AS avg_compliance_burden,
    AVG(selective_enforcement) AS avg_selective_enforcement
FROM institutional_enforcement_periods
GROUP BY period
HAVING avg_enforcement_score >= 0.60
   AND avg_compliance_burden >= 0.65
   AND avg_selective_enforcement >= 0.65
ORDER BY period;
