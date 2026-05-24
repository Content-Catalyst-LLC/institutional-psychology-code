-- Regulatory behavior and institutional accountability analysis queries.

-- Aggregate regulatory accountability profile.
SELECT
    AVG(accountability_effectiveness) AS avg_accountability_effectiveness,
    AVG(high_accountability) AS high_accountability_rate,
    AVG(fragile_regulation) AS fragile_regulation_rate,
    AVG(high_burden_regulation) AS high_burden_regulation_rate,
    AVG(legitimacy) AS avg_legitimacy,
    AVG(information_quality) AS avg_information_quality,
    AVG(capture_pressure) AS avg_capture_pressure,
    AVG(regulatory_burden) AS avg_regulatory_burden,
    AVG(unequal_accountability) AS avg_unequal_accountability
FROM regulatory_accountability_units;

-- High accountability but low legitimacy cases.
SELECT
    unit_id,
    accountability_effectiveness,
    high_accountability,
    legitimacy,
    oversight_strength,
    information_quality,
    enforcement_credibility,
    capture_pressure,
    regulatory_burden,
    unequal_accountability
FROM regulatory_accountability_units
WHERE high_accountability = 1
  AND legitimacy < 40
ORDER BY legitimacy ASC;

-- Accountability outcomes by regulatory burden band.
SELECT
    CASE
        WHEN regulatory_burden < 35 THEN 'low_regulatory_burden'
        WHEN regulatory_burden < 65 THEN 'moderate_regulatory_burden'
        ELSE 'high_regulatory_burden'
    END AS regulatory_burden_band,
    COUNT(*) AS units,
    AVG(accountability_effectiveness) AS avg_accountability_effectiveness,
    AVG(high_accountability) AS high_accountability_rate,
    AVG(high_burden_regulation) AS high_burden_regulation_rate,
    AVG(unequal_accountability) AS avg_unequal_accountability,
    AVG(legitimacy) AS avg_legitimacy,
    AVG(accountability_reach) AS avg_accountability_reach
FROM regulatory_accountability_units
GROUP BY regulatory_burden_band
ORDER BY avg_accountability_effectiveness DESC;

-- Dynamic periods with high accountability but high burden and unequal accountability.
SELECT
    period,
    AVG(accountability_score) AS avg_accountability_score,
    AVG(legitimacy) AS avg_legitimacy,
    AVG(information_quality) AS avg_information_quality,
    AVG(capture_pressure) AS avg_capture_pressure,
    AVG(regulatory_burden) AS avg_regulatory_burden,
    AVG(unequal_accountability) AS avg_unequal_accountability
FROM regulatory_accountability_periods
GROUP BY period
HAVING avg_accountability_score >= 0.60
   AND avg_regulatory_burden >= 0.65
   AND avg_unequal_accountability >= 0.65
ORDER BY period;
