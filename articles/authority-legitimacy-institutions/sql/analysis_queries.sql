-- Authority and legitimacy analysis queries.

-- Aggregate legitimacy and voluntary-compliance profile.
SELECT
    AVG(authority_legitimacy_strength) AS avg_authority_legitimacy_strength,
    AVG(voluntary_compliance) AS avg_voluntary_compliance,
    AVG(high_legitimacy) AS high_legitimacy_rate,
    AVG(high_voluntary_compliance) AS high_voluntary_compliance_rate,
    AVG(fragile_legitimacy_environment) AS fragile_legitimacy_environment_rate,
    AVG(high_arbitrariness_environment) AS high_arbitrariness_environment_rate,
    AVG(procedural_legitimacy) AS avg_procedural_legitimacy,
    AVG(trust) AS avg_trust,
    AVG(accountability) AS avg_accountability,
    AVG(repair_capacity) AS avg_repair_capacity,
    AVG(arbitrariness_pressure) AS avg_arbitrariness_pressure
FROM authority_legitimacy_units;

-- Fragile legitimacy environments.
SELECT
    unit_id,
    authority_legitimacy_strength,
    voluntary_compliance,
    procedural_legitimacy,
    trust,
    accountability,
    repair_capacity,
    fairness,
    social_recognition,
    arbitrariness_pressure,
    visible_inconsistency
FROM authority_legitimacy_units
WHERE high_legitimacy = 1
  AND procedural_legitimacy < 40
  AND trust < 40
ORDER BY procedural_legitimacy ASC, trust ASC;

-- High-arbitrariness environments.
SELECT
    unit_id,
    authority_legitimacy_strength,
    voluntary_compliance,
    arbitrariness_pressure,
    visible_inconsistency,
    unequal_burden,
    opacity_pressure,
    repair_capacity,
    procedural_legitimacy,
    trust
FROM authority_legitimacy_units
WHERE arbitrariness_pressure > 70
  AND visible_inconsistency > 65
  AND repair_capacity < 40
ORDER BY arbitrariness_pressure DESC, visible_inconsistency DESC;

-- Legitimacy and compliance by repair-capacity band.
SELECT
    CASE
        WHEN repair_capacity < 35 THEN 'low_repair_capacity'
        WHEN repair_capacity < 70 THEN 'moderate_repair_capacity'
        ELSE 'high_repair_capacity'
    END AS repair_capacity_band,
    COUNT(*) AS units,
    AVG(authority_legitimacy_strength) AS avg_authority_legitimacy_strength,
    AVG(voluntary_compliance) AS avg_voluntary_compliance,
    AVG(high_legitimacy) AS high_legitimacy_rate,
    AVG(high_voluntary_compliance) AS high_voluntary_compliance_rate,
    AVG(procedural_legitimacy) AS avg_procedural_legitimacy,
    AVG(trust) AS avg_trust,
    AVG(arbitrariness_pressure) AS avg_arbitrariness_pressure,
    AVG(visible_inconsistency) AS avg_visible_inconsistency
FROM authority_legitimacy_units
GROUP BY repair_capacity_band
ORDER BY avg_authority_legitimacy_strength DESC;
