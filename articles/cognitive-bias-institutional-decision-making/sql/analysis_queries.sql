-- Cognitive bias and institutional decision-making analysis queries.

-- Aggregate decision-quality and bias-pressure profile.
SELECT
    AVG(decision_quality) AS avg_decision_quality,
    AVG(institutional_bias_pressure) AS avg_bias_pressure,
    AVG(high_resilience_decision) AS high_resilience_decision_rate,
    AVG(fragile_judgment) AS fragile_judgment_rate,
    AVG(high_bias_environment) AS high_bias_environment_rate,
    AVG(dissent_capacity) AS avg_dissent_capacity,
    AVG(corrective_review) AS avg_corrective_review,
    AVG(information_quality) AS avg_information_quality,
    AVG(filtering_distortion) AS avg_filtering_distortion,
    AVG(path_lock_in) AS avg_path_lock_in
FROM cognitive_bias_units;

-- High apparent decision quality but weak dissent and high distortion.
SELECT
    unit_id,
    decision_quality,
    institutional_bias_pressure,
    dissent_capacity,
    corrective_review,
    information_quality,
    feedback_openness,
    filtering_distortion,
    conformity_pressure,
    path_lock_in,
    metric_tunnel_vision
FROM cognitive_bias_units
WHERE high_resilience_decision = 1
  AND dissent_capacity < 40
  AND filtering_distortion > 65
ORDER BY dissent_capacity ASC, filtering_distortion DESC;

-- Decision outcomes by bias-pressure band.
SELECT
    CASE
        WHEN institutional_bias_pressure < 35 THEN 'low_bias_pressure'
        WHEN institutional_bias_pressure < 65 THEN 'moderate_bias_pressure'
        ELSE 'high_bias_pressure'
    END AS bias_pressure_band,
    COUNT(*) AS units,
    AVG(decision_quality) AS avg_decision_quality,
    AVG(institutional_bias_pressure) AS avg_bias_pressure,
    AVG(high_resilience_decision) AS high_resilience_decision_rate,
    AVG(high_bias_environment) AS high_bias_environment_rate,
    AVG(corrective_review) AS avg_corrective_review,
    AVG(feedback_openness) AS avg_feedback_openness,
    AVG(dissent_capacity) AS avg_dissent_capacity,
    AVG(power_protection) AS avg_power_protection,
    AVG(metric_tunnel_vision) AS avg_metric_tunnel_vision
FROM cognitive_bias_units
GROUP BY bias_pressure_band
ORDER BY avg_decision_quality DESC;

-- Dynamic periods with high bias pressure and weak correction.
SELECT
    period,
    AVG(bias_pressure) AS avg_bias_pressure,
    AVG(decision_score) AS avg_decision_score,
    AVG(overconfidence) AS avg_overconfidence,
    AVG(filtering_distortion) AS avg_filtering_distortion,
    AVG(conformity_pressure) AS avg_conformity_pressure,
    AVG(path_lock_in) AS avg_path_lock_in,
    AVG(dissent_capacity) AS avg_dissent_capacity,
    AVG(corrective_review) AS avg_corrective_review,
    AVG(feedback_openness) AS avg_feedback_openness
FROM cognitive_bias_periods
GROUP BY period
HAVING avg_bias_pressure >= 0.65
   AND avg_corrective_review < 0.40
   AND avg_feedback_openness < 0.40
ORDER BY period;
