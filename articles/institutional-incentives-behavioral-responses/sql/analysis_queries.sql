-- Institutional incentives and behavioral responses analysis queries.

-- Aggregate incentive profile.
SELECT
    AVG(incentive_effectiveness) AS avg_incentive_effectiveness,
    AVG(high_alignment) AS high_alignment_rate,
    AVG(fragile_incentive_system) AS fragile_incentive_system_rate,
    AVG(high_burden_incentive_system) AS high_burden_incentive_system_rate,
    AVG(value_alignment) AS avg_value_alignment,
    AVG(fairness) AS avg_fairness,
    AVG(information_quality) AS avg_information_quality,
    AVG(legitimacy) AS avg_legitimacy,
    AVG(metric_substitution) AS avg_metric_substitution,
    AVG(behavioral_burden) AS avg_behavioral_burden
FROM institutional_incentive_units;

-- High incentive effectiveness but low legitimacy cases.
SELECT
    unit_id,
    incentive_effectiveness,
    high_alignment,
    legitimacy,
    fairness,
    value_alignment,
    information_quality,
    metric_substitution,
    reporting_distortion,
    behavioral_burden
FROM institutional_incentive_units
WHERE high_alignment = 1
  AND legitimacy < 40
ORDER BY legitimacy ASC;

-- Incentive outcomes by behavioral burden band.
SELECT
    CASE
        WHEN behavioral_burden < 35 THEN 'low_behavioral_burden'
        WHEN behavioral_burden < 65 THEN 'moderate_behavioral_burden'
        ELSE 'high_behavioral_burden'
    END AS behavioral_burden_band,
    COUNT(*) AS units,
    AVG(incentive_effectiveness) AS avg_incentive_effectiveness,
    AVG(high_alignment) AS high_alignment_rate,
    AVG(high_burden_incentive_system) AS high_burden_incentive_system_rate,
    AVG(metric_substitution) AS avg_metric_substitution,
    AVG(reporting_distortion) AS avg_reporting_distortion,
    AVG(legitimacy) AS avg_legitimacy,
    AVG(fairness) AS avg_fairness,
    AVG(accountability) AS avg_accountability
FROM institutional_incentive_units
GROUP BY behavioral_burden_band
ORDER BY avg_incentive_effectiveness DESC;

-- Dynamic periods with high incentive effectiveness but high burden and metric substitution.
SELECT
    period,
    AVG(incentive_score) AS avg_incentive_score,
    AVG(legitimacy) AS avg_legitimacy,
    AVG(fairness) AS avg_fairness,
    AVG(information_quality) AS avg_information_quality,
    AVG(metric_substitution) AS avg_metric_substitution,
    AVG(behavioral_burden) AS avg_behavioral_burden,
    AVG(reporting_distortion) AS avg_reporting_distortion
FROM institutional_incentive_periods
GROUP BY period
HAVING avg_incentive_score >= 0.60
   AND avg_behavioral_burden >= 0.65
   AND avg_metric_substitution >= 0.65
ORDER BY period;
