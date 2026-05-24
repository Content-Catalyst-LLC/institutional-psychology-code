-- Compliance and Rule-Following Behavior synthetic research schema.
-- This schema is for demonstration and reproducible analysis only.

DROP TABLE IF EXISTS compliance_rule_following_units;
DROP TABLE IF EXISTS compliance_rule_following_periods;

CREATE TABLE compliance_rule_following_units (
    unit_id INTEGER PRIMARY KEY,
    legitimacy REAL NOT NULL,
    fairness REAL NOT NULL,
    incentive_alignment REAL NOT NULL,
    norm_support REAL NOT NULL,
    enforcement_credibility REAL NOT NULL,
    communication_quality REAL NOT NULL,
    cognitive_clarity REAL NOT NULL,
    trust REAL NOT NULL,
    adaptive_learning REAL NOT NULL,
    compliance_burden REAL NOT NULL,
    selective_rule_application REAL NOT NULL,
    defensive_compliance REAL NOT NULL,
    hypocrisy_visibility REAL NOT NULL,
    norm_failure REAL NOT NULL,
    compliance_quality REAL,
    high_compliance INTEGER,
    fragile_compliance INTEGER,
    high_burden_compliance INTEGER
);

CREATE TABLE compliance_rule_following_periods (
    period INTEGER NOT NULL,
    agent_id INTEGER NOT NULL,
    enforcement REAL NOT NULL,
    communication REAL NOT NULL,
    clarity REAL NOT NULL,
    compliance_burden REAL NOT NULL,
    selective_rule_application REAL NOT NULL,
    hypocrisy_visibility REAL NOT NULL,
    comply_probability REAL NOT NULL,
    comply INTEGER NOT NULL,
    legitimacy REAL NOT NULL,
    fairness REAL NOT NULL,
    norm_support REAL NOT NULL,
    trust REAL NOT NULL,
    PRIMARY KEY (period, agent_id)
);

CREATE INDEX idx_compliance_rule_following_units_quality
ON compliance_rule_following_units (compliance_quality);

CREATE INDEX idx_compliance_rule_following_units_high
ON compliance_rule_following_units (high_compliance);

CREATE INDEX idx_compliance_rule_following_units_fragile
ON compliance_rule_following_units (fragile_compliance);

CREATE INDEX idx_compliance_rule_following_units_burden
ON compliance_rule_following_units (high_burden_compliance);

CREATE INDEX idx_compliance_rule_following_periods_comply
ON compliance_rule_following_periods (comply);
