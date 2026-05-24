-- Behavioral Foundations of Governance Systems synthetic research schema.
-- This schema is for demonstration and reproducible analysis only.

DROP TABLE IF EXISTS behavioral_governance_units;
DROP TABLE IF EXISTS behavioral_governance_periods;

CREATE TABLE behavioral_governance_units (
    unit_id INTEGER PRIMARY KEY,
    incentive_alignment REAL NOT NULL,
    legitimacy REAL NOT NULL,
    norm_support REAL NOT NULL,
    cognitive_interpretability REAL NOT NULL,
    trust REAL NOT NULL,
    coordination_quality REAL NOT NULL,
    enforcement_credibility REAL NOT NULL,
    adaptive_learning REAL NOT NULL,
    perceived_fairness REAL NOT NULL,
    behavioral_burden REAL NOT NULL,
    hypocrisy_visibility REAL NOT NULL,
    power_asymmetry REAL NOT NULL,
    governance_effectiveness REAL,
    high_governance INTEGER,
    fragile_governance INTEGER,
    high_burden_governance INTEGER
);

CREATE TABLE behavioral_governance_periods (
    period INTEGER NOT NULL,
    unit_id INTEGER NOT NULL,
    incentive_alignment REAL NOT NULL,
    enforcement REAL NOT NULL,
    cognitive_interpretability REAL NOT NULL,
    behavioral_burden REAL NOT NULL,
    hypocrisy_visibility REAL NOT NULL,
    power_asymmetry REAL NOT NULL,
    governance_score REAL NOT NULL,
    legitimacy REAL NOT NULL,
    trust REAL NOT NULL,
    norm_support REAL NOT NULL,
    coordination_quality REAL NOT NULL,
    adaptive_learning REAL NOT NULL,
    perceived_fairness REAL NOT NULL,
    fragile_governance INTEGER,
    high_burden_governance INTEGER,
    PRIMARY KEY (period, unit_id)
);

CREATE INDEX idx_behavioral_governance_units_effectiveness
ON behavioral_governance_units (governance_effectiveness);

CREATE INDEX idx_behavioral_governance_units_high
ON behavioral_governance_units (high_governance);

CREATE INDEX idx_behavioral_governance_units_fragile
ON behavioral_governance_units (fragile_governance);

CREATE INDEX idx_behavioral_governance_units_burden
ON behavioral_governance_units (high_burden_governance);

CREATE INDEX idx_behavioral_governance_periods_score
ON behavioral_governance_periods (governance_score);
