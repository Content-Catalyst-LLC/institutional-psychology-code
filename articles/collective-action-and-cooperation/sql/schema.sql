-- Collective Action and Cooperation synthetic research schema.
-- This schema is for demonstration and reproducible analysis only.

DROP TABLE IF EXISTS collective_action_units;
DROP TABLE IF EXISTS collective_action_periods;

CREATE TABLE collective_action_units (
    unit_id INTEGER PRIMARY KEY,
    incentive_alignment REAL NOT NULL,
    trust REAL NOT NULL,
    legitimacy REAL NOT NULL,
    norm_strength REAL NOT NULL,
    enforcement_credibility REAL NOT NULL,
    communication_quality REAL NOT NULL,
    coordination_quality REAL NOT NULL,
    perceived_fairness REAL NOT NULL,
    free_riding_pressure REAL NOT NULL,
    burden_inequality REAL NOT NULL,
    hypocrisy_visibility REAL NOT NULL,
    scale_complexity REAL NOT NULL,
    cooperation_score REAL,
    high_cooperation INTEGER,
    fragile_cooperation INTEGER,
    high_burden_cooperation INTEGER
);

CREATE TABLE collective_action_periods (
    period INTEGER NOT NULL,
    agent_id INTEGER NOT NULL,
    enforcement REAL NOT NULL,
    communication REAL NOT NULL,
    coordination REAL NOT NULL,
    burden_inequality REAL NOT NULL,
    hypocrisy_visibility REAL NOT NULL,
    cooperate INTEGER NOT NULL,
    cooperation_rate REAL NOT NULL,
    collective_action_quality REAL NOT NULL,
    trust REAL NOT NULL,
    legitimacy REAL NOT NULL,
    norm_strength REAL NOT NULL,
    perceived_fairness REAL NOT NULL,
    free_riding_pressure REAL NOT NULL,
    fragile_collective_action INTEGER,
    high_burden_collective_action INTEGER,
    PRIMARY KEY (period, agent_id)
);

CREATE INDEX idx_collective_action_units_score
ON collective_action_units (cooperation_score);

CREATE INDEX idx_collective_action_units_high
ON collective_action_units (high_cooperation);

CREATE INDEX idx_collective_action_units_fragile
ON collective_action_units (fragile_cooperation);

CREATE INDEX idx_collective_action_units_burden
ON collective_action_units (high_burden_cooperation);

CREATE INDEX idx_collective_action_periods_quality
ON collective_action_periods (collective_action_quality);
