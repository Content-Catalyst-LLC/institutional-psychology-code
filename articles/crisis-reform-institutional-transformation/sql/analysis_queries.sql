-- Crisis, reform, and institutional transformation analysis queries.

-- Aggregate transformation profile.
SELECT
    AVG(crisis_severity) AS avg_crisis_severity,
    AVG(legitimacy_failure) AS avg_legitimacy_failure,
    AVG(transformation_score) AS avg_transformation_score,
    AVG(major_reform) AS major_reform_rate,
    AVG(deep_transformation) AS deep_transformation_rate,
    AVG(high_capture_risk) AS high_capture_risk_rate
FROM crisis_reform_cases;

-- High transformation but high capture risk.
SELECT
    case_id,
    transformation_score,
    crisis_severity,
    legitimacy_failure,
    reform_window,
    coalition_strength,
    capture_risk,
    distributional_attention
FROM crisis_reform_cases
WHERE transformation_score >= 70
  AND capture_risk >= 65
ORDER BY transformation_score DESC;

-- Reform outcomes by distributional attention band.
SELECT
    CASE
        WHEN distributional_attention < 35 THEN 'low_distributional_attention'
        WHEN distributional_attention < 65 THEN 'moderate_distributional_attention'
        ELSE 'high_distributional_attention'
    END AS distributional_attention_band,
    COUNT(*) AS cases,
    AVG(transformation_score) AS avg_transformation_score,
    AVG(major_reform) AS major_reform_rate,
    AVG(deep_transformation) AS deep_transformation_rate,
    AVG(capture_risk) AS avg_capture_risk
FROM crisis_reform_cases
GROUP BY distributional_attention_band
ORDER BY avg_transformation_score DESC;

-- Dynamic periods where reform probability is high but capture warning is also high.
SELECT
    period,
    institution_id,
    reform_probability,
    legitimacy,
    reform_window,
    coalition_strength,
    capture_risk,
    distributional_attention
FROM crisis_reform_periods
WHERE high_reform_likelihood = 1
  AND capture_warning = 1
ORDER BY period, reform_probability DESC;
