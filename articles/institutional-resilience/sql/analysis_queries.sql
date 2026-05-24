-- Institutional resilience analysis queries.

-- Average resilience and continuity.
SELECT
    AVG(resilience_index) AS avg_resilience,
    AVG(continuity_score) AS avg_continuity,
    AVG(legitimacy) AS avg_legitimacy,
    AVG(trust) AS avg_trust,
    AVG(shock_intensity) AS avg_shock
FROM institutional_resilience;

-- Highest-resilience institutions.
SELECT
    institution_id,
    resilience_index,
    continuity_score,
    legitimacy,
    trust,
    shock_intensity
FROM institutional_resilience
ORDER BY resilience_index DESC
LIMIT 10;

-- Failure risk by legitimacy band.
SELECT
    CASE
        WHEN legitimacy < 40 THEN 'low_legitimacy'
        WHEN legitimacy < 70 THEN 'moderate_legitimacy'
        ELSE 'high_legitimacy'
    END AS legitimacy_band,
    COUNT(*) AS institutions,
    AVG(failure_flag) AS failure_rate,
    AVG(continuity_score) AS avg_continuity
FROM institutional_resilience
GROUP BY legitimacy_band
ORDER BY avg_continuity DESC;

-- Institutions facing high shock but maintaining core function.
SELECT
    institution_id,
    shock_intensity,
    resilience_index,
    continuity_score,
    legitimacy,
    trust,
    coordination
FROM institutional_resilience
WHERE shock_intensity >= 80
  AND maintained_core_function = 1
ORDER BY continuity_score DESC;
