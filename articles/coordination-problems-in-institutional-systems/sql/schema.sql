-- Coordination Problems in Institutional Systems synthetic research schema.
-- This schema is for demonstration and reproducible analysis only.

DROP TABLE IF EXISTS coordination_units;
DROP TABLE IF EXISTS coordination_periods;

CREATE TABLE coordination_units (
    unit_id INTEGER PRIMARY KEY,
    trust REAL NOT NULL,
    information_quality REAL NOT NULL,
    communication_clarity REAL NOT NULL,
    focal_salience REAL NOT NULL,
    authority_signal REAL NOT NULL,
    norm_strength REAL NOT NULL,
    learning_capacity REAL NOT NULL,
    uncertainty REAL NOT NULL,
    adaptation_burden REAL NOT NULL,
    competing_standards REAL NOT NULL,
    competing_authority REAL NOT NULL,
    distributional_attention REAL NOT NULL,
    coordination_quality REAL,
    high_alignment INTEGER,
    fragile_coordination INTEGER,
    high_burden_coordination INTEGER
);

CREATE TABLE coordination_periods (
    period INTEGER NOT NULL,
    agent_id INTEGER NOT NULL,
    communication REAL NOT NULL,
    authority REAL NOT NULL,
    information_quality REAL NOT NULL,
    uncertainty REAL NOT NULL,
    competing_standards REAL NOT NULL,
    adaptation_burden REAL NOT NULL,
    aligned INTEGER NOT NULL,
    coordination_rate REAL NOT NULL,
    coordination_quality REAL NOT NULL,
    trust REAL NOT NULL,
    focal_salience REAL NOT NULL,
    norm_strength REAL NOT NULL,
    adaptation_capacity REAL NOT NULL,
    fragile_coordination INTEGER,
    high_burden_coordination INTEGER,
    PRIMARY KEY (period, agent_id)
);

CREATE INDEX idx_coordination_units_quality
ON coordination_units (coordination_quality);

CREATE INDEX idx_coordination_units_high_alignment
ON coordination_units (high_alignment);

CREATE INDEX idx_coordination_units_fragile
ON coordination_units (fragile_coordination);

CREATE INDEX idx_coordination_units_burden
ON coordination_units (high_burden_coordination);

CREATE INDEX idx_coordination_periods_quality
ON coordination_periods (coordination_quality);
