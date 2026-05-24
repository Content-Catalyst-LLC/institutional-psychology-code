-- Information flow and organizational communication analysis queries.

-- Aggregate information-flow profile.
SELECT
    AVG(information_effectiveness) AS avg_information_effectiveness,
    AVG(high_integration) AS high_integration_rate,
    AVG(fragile_communication) AS fragile_communication_rate,
    AVG(high_overload_system) AS high_overload_system_rate,
    AVG(signal_quality) AS avg_signal_quality,
    AVG(communication_quality) AS avg_communication_quality,
    AVG(interpretive_integration) AS avg_interpretive_integration,
    AVG(openness) AS avg_openness,
    AVG(distortion_loss) AS avg_distortion_loss,
    AVG(overload) AS avg_overload
FROM information_flow_units;

-- High information effectiveness but low openness and high distortion.
SELECT
    unit_id,
    information_effectiveness,
    high_integration,
    signal_quality,
    communication_quality,
    openness,
    escalation_access,
    trust,
    distortion_loss,
    suppression_pressure
FROM information_flow_units
WHERE high_integration = 1
  AND openness < 40
  AND distortion_loss > 65
ORDER BY openness ASC, distortion_loss DESC;

-- Information outcomes by overload band.
SELECT
    CASE
        WHEN overload < 35 THEN 'low_overload'
        WHEN overload < 70 THEN 'moderate_overload'
        ELSE 'high_overload'
    END AS overload_band,
    COUNT(*) AS units,
    AVG(information_effectiveness) AS avg_information_effectiveness,
    AVG(high_integration) AS high_integration_rate,
    AVG(high_overload_system) AS high_overload_system_rate,
    AVG(metric_tunnel_vision) AS avg_metric_tunnel_vision,
    AVG(distortion_loss) AS avg_distortion_loss,
    AVG(interpretive_integration) AS avg_interpretive_integration,
    AVG(memory_retention) AS avg_memory_retention,
    AVG(community_voice) AS avg_community_voice
FROM information_flow_units
GROUP BY overload_band
ORDER BY avg_information_effectiveness DESC;

-- Dynamic periods with high information score but high overload and metric tunnel vision.
SELECT
    period,
    AVG(info_score) AS avg_info_score,
    AVG(signal_quality) AS avg_signal_quality,
    AVG(communication_quality) AS avg_communication_quality,
    AVG(openness) AS avg_openness,
    AVG(trust) AS avg_trust,
    AVG(escalation_access) AS avg_escalation_access,
    AVG(distortion_loss) AS avg_distortion_loss,
    AVG(overload) AS avg_overload,
    AVG(metric_tunnel_vision) AS avg_metric_tunnel_vision
FROM information_flow_periods
GROUP BY period
HAVING avg_info_score >= 0.60
   AND avg_overload >= 0.70
   AND avg_metric_tunnel_vision >= 0.65
ORDER BY period;
