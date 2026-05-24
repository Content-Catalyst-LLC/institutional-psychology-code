-- Institutional Norms and Social Expectations synthetic research schema.
-- This schema is for demonstration and reproducible analysis only.

DROP TABLE IF EXISTS institutional_norm_units;
DROP TABLE IF EXISTS institutional_norm_periods;

CREATE TABLE institutional_norm_units (
    unit_id INTEGER PRIMARY KEY,
    norm_repetition REAL NOT NULL,
    expectation_convergence REAL NOT NULL,
    internalization REAL NOT NULL,
    social_enforcement REAL NOT NULL,
    legitimacy_alignment REAL NOT NULL,
    trust_reinforcement REAL NOT NULL,
    role_clarity REAL NOT NULL,
    learning_capacity REAL NOT NULL,
    alternative_norm_visibility REAL NOT NULL,
    sanction_cost REAL NOT NULL,
    suppressive_pressure REAL NOT NULL,
    fragmentation_pressure REAL NOT NULL,
    unequal_normative_burden REAL NOT NULL,
    rigidity_pressure REAL NOT NULL,
    normative_stability REAL,
    high_coordination INTEGER,
    fragile_normative_environment INTEGER,
    suppressive_norm_environment INTEGER,
    norm_change_readiness REAL
);

CREATE TABLE institutional_norm_periods (
    period INTEGER NOT NULL,
    unit_id INTEGER NOT NULL,
    norm_repetition REAL NOT NULL,
    fragmentation_pressure REAL NOT NULL,
    suppressive_pressure REAL NOT NULL,
    unequal_normative_burden REAL NOT NULL,
    alternative_norm_visibility REAL NOT NULL,
    sanction_cost REAL NOT NULL,
    rigidity_pressure REAL NOT NULL,
    norm_score REAL NOT NULL,
    change_readiness REAL NOT NULL,
    expectation_convergence REAL NOT NULL,
    internalization REAL NOT NULL,
    social_enforcement REAL NOT NULL,
    legitimacy_alignment REAL NOT NULL,
    trust_reinforcement REAL NOT NULL,
    learning_capacity REAL NOT NULL,
    fragile_normative_environment INTEGER,
    suppressive_norm_environment INTEGER,
    PRIMARY KEY (period, unit_id)
);

CREATE INDEX idx_institutional_norm_units_stability
ON institutional_norm_units (normative_stability);

CREATE INDEX idx_institutional_norm_units_coordination
ON institutional_norm_units (high_coordination);

CREATE INDEX idx_institutional_norm_units_fragile
ON institutional_norm_units (fragile_normative_environment);

CREATE INDEX idx_institutional_norm_units_suppressive
ON institutional_norm_units (suppressive_norm_environment);

CREATE INDEX idx_institutional_norm_units_change
ON institutional_norm_units (norm_change_readiness);

CREATE INDEX idx_institutional_norm_periods_score
ON institutional_norm_periods (norm_score);
