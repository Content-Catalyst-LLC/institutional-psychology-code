-- Decision-making in institutional systems analysis queries.

-- Aggregate decision-quality profile.
SELECT
    AVG(decision_quality) AS avg_decision_quality,
    AVG(high_quality_decision) AS high_quality_decision_rate,
    AVG(fragile_decision_environment) AS fragile_decision_environment_rate,
    AVG(high_distortion_environment) AS high_distortion_environment_rate,
    AVG(information_flow_effectiveness) AS avg_information_flow,
    AVG(corrective_capacity) AS avg_corrective_capacity,
    AVG(legitimacy) AS avg_legitimacy,
    AVG(uncertainty_management) AS avg_uncertainty_management,
    AVG(bounded_rationality_pressure) AS avg_bounded_rationality_pressure,
    AVG(bias_distortion) AS avg_bias_distortion
FROM decision_quality_units;

-- Fragile decision environments.
SELECT
    unit_id,
    decision_quality,
    high_quality_decision,
    organizational_structure_quality,
    information_flow_effectiveness,
    legitimacy,
    uncertainty_management,
    corrective_capacity,
    feedback_openness,
    bounded_rationality_pressure,
    bias_distortion,
    power_protection
FROM decision_quality_units
WHERE high_quality_decision = 1
  AND corrective_capacity < 40
  AND information_flow_effectiveness < 45
ORDER BY corrective_capacity ASC, information_flow_effectiveness ASC;

-- High-distortion environments.
SELECT
    unit_id,
    decision_quality,
    bias_distortion,
    power_protection,
    feedback_openness,
    metric_fixation,
    siloing,
    premature_closure,
    justice_voice,
    legitimacy
FROM decision_quality_units
WHERE bias_distortion > 70
  AND power_protection > 65
  AND feedback_openness < 40
ORDER BY bias_distortion DESC, power_protection DESC;

-- Decision outcomes by legitimacy band.
SELECT
    CASE
        WHEN legitimacy < 35 THEN 'low_legitimacy'
        WHEN legitimacy < 70 THEN 'moderate_legitimacy'
        ELSE 'high_legitimacy'
    END AS legitimacy_band,
    COUNT(*) AS units,
    AVG(decision_quality) AS avg_decision_quality,
    AVG(high_quality_decision) AS high_quality_decision_rate,
    AVG(justice_voice) AS avg_justice_voice,
    AVG(corrective_capacity) AS avg_corrective_capacity,
    AVG(feedback_openness) AS avg_feedback_openness,
    AVG(power_protection) AS avg_power_protection
FROM decision_quality_units
GROUP BY legitimacy_band
ORDER BY avg_decision_quality DESC;
