-- Institutional memory analysis queries.

-- Aggregate memory profile.
SELECT
    AVG(memory_effectiveness) AS avg_memory_effectiveness,
    AVG(high_resilience_memory) AS high_resilience_memory_rate,
    AVG(fragile_memory) AS fragile_memory_rate,
    AVG(high_path_dependence_memory) AS high_path_dependence_memory_rate,
    AVG(documented_retention) AS avg_documented_retention,
    AVG(tacit_transfer) AS avg_tacit_transfer,
    AVG(accessibility) AS avg_accessibility,
    AVG(revisability) AS avg_revisability,
    AVG(path_dependence_pressure) AS avg_path_dependence_pressure,
    AVG(loss_fragmentation) AS avg_loss_fragmentation
FROM institutional_memory_units;

-- High memory but weak documentation and weak tacit transfer.
SELECT
    unit_id,
    memory_effectiveness,
    high_resilience_memory,
    documented_retention,
    tacit_transfer,
    accessibility,
    interpretive_use,
    loss_fragmentation,
    turnover_pressure,
    key_person_dependency
FROM institutional_memory_units
WHERE high_resilience_memory = 1
  AND documented_retention < 40
  AND tacit_transfer < 40
ORDER BY documented_retention ASC, tacit_transfer ASC;

-- Memory outcomes by path-dependence pressure band.
SELECT
    CASE
        WHEN path_dependence_pressure < 35 THEN 'low_path_dependence'
        WHEN path_dependence_pressure < 65 THEN 'moderate_path_dependence'
        ELSE 'high_path_dependence'
    END AS path_dependence_band,
    COUNT(*) AS units,
    AVG(memory_effectiveness) AS avg_memory_effectiveness,
    AVG(high_resilience_memory) AS high_resilience_memory_rate,
    AVG(high_path_dependence_memory) AS high_path_dependence_memory_rate,
    AVG(revisability) AS avg_revisability,
    AVG(selective_narration) AS avg_selective_narration,
    AVG(memory_justice) AS avg_memory_justice,
    AVG(distributed_integration) AS avg_distributed_integration,
    AVG(loss_fragmentation) AS avg_loss_fragmentation
FROM institutional_memory_units
GROUP BY path_dependence_band
ORDER BY avg_memory_effectiveness DESC;

-- Dynamic periods with high memory score but high path dependence and low revisability.
SELECT
    period,
    AVG(memory_score) AS avg_memory_score,
    AVG(documented_retention) AS avg_documented_retention,
    AVG(tacit_transfer) AS avg_tacit_transfer,
    AVG(accessibility) AS avg_accessibility,
    AVG(revisability) AS avg_revisability,
    AVG(path_dependence_pressure) AS avg_path_dependence_pressure,
    AVG(selective_narration) AS avg_selective_narration,
    AVG(memory_justice) AS avg_memory_justice,
    AVG(loss_fragmentation) AS avg_loss_fragmentation
FROM institutional_memory_periods
GROUP BY period
HAVING avg_memory_score >= 0.60
   AND avg_path_dependence_pressure >= 0.65
   AND avg_revisability <= 0.40
ORDER BY period;
