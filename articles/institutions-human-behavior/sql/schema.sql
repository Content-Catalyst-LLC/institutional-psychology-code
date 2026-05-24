-- Institutions and Human Behavior synthetic research schema.
-- This schema is for demonstration and reproducible analysis only.

DROP TABLE IF EXISTS institutional_behavior_units;
DROP TABLE IF EXISTS institutional_behavior_periods;

CREATE TABLE institutional_behavior_units (
    unit_id INTEGER PRIMARY KEY,
    normative_stability REAL NOT NULL,
    legitimacy_strength REAL NOT NULL,
    incentive_alignment REAL NOT NULL,
    information_quality REAL NOT NULL,
    memory_retention REAL NOT NULL,
    learning_capacity REAL NOT NULL,
    trust_reinforcement REAL NOT NULL,
    role_clarity REAL NOT NULL,
    repair_capacity REAL NOT NULL,
    administrative_burden REAL NOT NULL,
    opacity_pressure REAL NOT NULL,
    historical_harm_pressure REAL NOT NULL,
    fragmentation_pressure REAL NOT NULL,
    institutional_strength REAL,
    behavioral_alignment REAL,
    high_institutional_alignment INTEGER,
    high_behavioral_alignment INTEGER,
    fragile_institutional_environment INTEGER,
    high_fragmentation_environment INTEGER
);

CREATE TABLE institutional_behavior_periods (
    period INTEGER NOT NULL,
    unit_id INTEGER NOT NULL,
    incentive_alignment REAL NOT NULL,
    fragmentation_pressure REAL NOT NULL,
    opacity_pressure REAL NOT NULL,
    administrative_burden REAL NOT NULL,
    historical_harm_pressure REAL NOT NULL,
    institution_score REAL NOT NULL,
    behavioral_alignment REAL NOT NULL,
    normative_stability REAL NOT NULL,
    legitimacy_strength REAL NOT NULL,
    information_quality REAL NOT NULL,
    memory_retention REAL NOT NULL,
    learning_capacity REAL NOT NULL,
    trust_reinforcement REAL NOT NULL,
    repair_capacity REAL NOT NULL,
    role_clarity REAL NOT NULL,
    fragile_institutional_environment INTEGER,
    high_fragmentation_environment INTEGER,
    PRIMARY KEY (period, unit_id)
);

CREATE INDEX idx_institutional_behavior_units_strength
ON institutional_behavior_units (institutional_strength);

CREATE INDEX idx_institutional_behavior_units_alignment
ON institutional_behavior_units (behavioral_alignment);

CREATE INDEX idx_institutional_behavior_units_fragile
ON institutional_behavior_units (fragile_institutional_environment);

CREATE INDEX idx_institutional_behavior_units_fragmentation
ON institutional_behavior_units (high_fragmentation_environment);

CREATE INDEX idx_institutional_behavior_periods_score
ON institutional_behavior_periods (institution_score);
