-- Behavioral governance analysis queries.

-- Aggregate governance profile.
SELECT
    AVG(governance_effectiveness) AS avg_governance_effectiveness,
    AVG(high_governance) AS high_governance_rate,
    AVG(fragile_governance) AS fragile_governance_rate,
    AVG(high_burden_governance) AS high_burden_governance_rate,
    AVG(legitimacy) AS avg_legitimacy,
    AVG(trust) AS avg_trust,
    AVG(behavioral_burden) AS avg_behavioral_burden,
    AVG(power_asymmetry) AS avg_power_asymmetry
FROM behavioral_governance_units;

-- High governance but low trust cases.
SELECT
    unit_id,
    governance_effectiveness,
    high_governance,
    trust,
    legitimacy,
    cognitive_interpretability,
    coordination_quality,
    enforcement_credibility,
    behavioral_burden,
    hypocrisy_visibility
FROM behavioral_governance_units
WHERE high_governance = 1
  AND trust < 40
ORDER BY trust ASC;

-- Governance outcomes by behavioral burden band.
SELECT
    CASE
        WHEN behavioral_burden < 35 THEN 'low_behavioral_burden'
        WHEN behavioral_burden < 65 THEN 'moderate_behavioral_burden'
        ELSE 'high_behavioral_burden'
    END AS behavioral_burden_band,
    COUNT(*) AS units,
    AVG(governance_effectiveness) AS avg_governance_effectiveness,
    AVG(high_governance) AS high_governance_rate,
    AVG(high_burden_governance) AS high_burden_governance_rate,
    AVG(perceived_fairness) AS avg_perceived_fairness,
    AVG(legitimacy) AS avg_legitimacy,
    AVG(trust) AS avg_trust
FROM behavioral_governance_units
GROUP BY behavioral_burden_band
ORDER BY avg_governance_effectiveness DESC;

-- Dynamic periods with high governance but high behavioral burden.
SELECT
    period,
    AVG(governance_score) AS avg_governance_score,
    AVG(legitimacy) AS avg_legitimacy,
    AVG(trust) AS avg_trust,
    AVG(behavioral_burden) AS avg_behavioral_burden,
    AVG(hypocrisy_visibility) AS avg_hypocrisy_visibility,
    AVG(power_asymmetry) AS avg_power_asymmetry
FROM behavioral_governance_periods
GROUP BY period
HAVING avg_governance_score >= 0.60
   AND avg_behavioral_burden >= 0.65
ORDER BY period;
