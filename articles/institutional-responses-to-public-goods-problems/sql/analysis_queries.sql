-- Public goods institution analysis queries.

-- Aggregate provision profile.
SELECT
    AVG(contribution_rate) AS avg_contribution_rate,
    AVG(provision_quality) AS avg_provision_quality,
    AVG(high_provision) AS high_provision_rate,
    AVG(fragile_public_good) AS fragile_public_good_rate,
    AVG(high_burden_risk) AS high_burden_risk_rate,
    AVG(trust) AS avg_trust,
    AVG(legitimacy) AS avg_legitimacy
FROM public_goods_units;

-- High provision but low legitimacy cases.
SELECT
    unit_id,
    provision_quality,
    contribution_rate,
    trust,
    legitimacy,
    enforcement,
    monitoring,
    capture_risk,
    distributional_attention
FROM public_goods_units
WHERE high_provision = 1
  AND legitimacy < 40
ORDER BY legitimacy ASC;

-- Provision outcomes by distributional attention band.
SELECT
    CASE
        WHEN distributional_attention < 35 THEN 'low_distributional_attention'
        WHEN distributional_attention < 65 THEN 'moderate_distributional_attention'
        ELSE 'high_distributional_attention'
    END AS distributional_attention_band,
    COUNT(*) AS units,
    AVG(contribution_rate) AS avg_contribution_rate,
    AVG(provision_quality) AS avg_provision_quality,
    AVG(high_provision) AS high_provision_rate,
    AVG(high_burden_risk) AS high_burden_risk_rate,
    AVG(legitimacy) AS avg_legitimacy,
    AVG(perceived_fairness) AS avg_perceived_fairness
FROM public_goods_units
GROUP BY distributional_attention_band
ORDER BY avg_provision_quality DESC;

-- Dynamic periods where provision is high but legitimacy is low.
SELECT
    period,
    AVG(provision_quality) AS avg_provision_quality,
    AVG(legitimacy) AS avg_legitimacy,
    AVG(contribution) AS avg_contribution,
    AVG(enforcement) AS avg_enforcement,
    AVG(monitoring) AS avg_monitoring
FROM public_goods_periods
GROUP BY period
HAVING avg_provision_quality >= 0.60
   AND avg_legitimacy < 0.40
ORDER BY period;
