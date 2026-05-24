-- Institutional learning analysis queries.

-- Aggregate learning profile.
SELECT
    AVG(learning_capacity) AS avg_learning_capacity,
    AVG(high_adaptation) AS high_adaptation_rate,
    AVG(fragile_learning) AS fragile_learning_rate,
    AVG(high_inertia_learning) AS high_inertia_learning_rate,
    AVG(feedback_quality) AS avg_feedback_quality,
    AVG(memory_retention) AS avg_memory_retention,
    AVG(communication_openness) AS avg_communication_openness,
    AVG(decision_revisability) AS avg_decision_revisability,
    AVG(institutional_inertia) AS avg_institutional_inertia,
    AVG(signal_distortion) AS avg_signal_distortion
FROM institutional_learning_units;

-- High learning capacity but weak communication openness.
SELECT
    unit_id,
    learning_capacity,
    high_adaptation,
    feedback_quality,
    communication_openness,
    psychological_safety,
    decision_revisability,
    institutional_inertia,
    signal_distortion,
    power_protection
FROM institutional_learning_units
WHERE high_adaptation = 1
  AND communication_openness < 40
ORDER BY communication_openness ASC;

-- Learning outcomes by institutional inertia band.
SELECT
    CASE
        WHEN institutional_inertia < 35 THEN 'low_inertia'
        WHEN institutional_inertia < 65 THEN 'moderate_inertia'
        ELSE 'high_inertia'
    END AS institutional_inertia_band,
    COUNT(*) AS units,
    AVG(learning_capacity) AS avg_learning_capacity,
    AVG(high_adaptation) AS high_adaptation_rate,
    AVG(high_inertia_learning) AS high_inertia_learning_rate,
    AVG(signal_distortion) AS avg_signal_distortion,
    AVG(memory_decay) AS avg_memory_decay,
    AVG(power_protection) AS avg_power_protection,
    AVG(feedback_quality) AS avg_feedback_quality,
    AVG(decision_revisability) AS avg_decision_revisability
FROM institutional_learning_units
GROUP BY institutional_inertia_band
ORDER BY avg_learning_capacity DESC;

-- Dynamic periods with high learning score but high inertia and signal distortion.
SELECT
    period,
    AVG(learning_score) AS avg_learning_score,
    AVG(feedback_quality) AS avg_feedback_quality,
    AVG(memory_retention) AS avg_memory_retention,
    AVG(communication_openness) AS avg_communication_openness,
    AVG(psychological_safety) AS avg_psychological_safety,
    AVG(decision_revisability) AS avg_decision_revisability,
    AVG(institutional_inertia) AS avg_institutional_inertia,
    AVG(signal_distortion) AS avg_signal_distortion,
    AVG(power_protection) AS avg_power_protection
FROM institutional_learning_periods
GROUP BY period
HAVING avg_learning_score >= 0.60
   AND avg_institutional_inertia >= 0.65
   AND avg_signal_distortion >= 0.65
ORDER BY period;
