-- Institutional Trust and Social Stability synthetic research schema.
-- This schema is for demonstration and reproducible analysis only.

DROP TABLE IF EXISTS institutional_trust_units;
DROP TABLE IF EXISTS institutional_trust_periods;

CREATE TABLE institutional_trust_units (
    unit_id INTEGER PRIMARY KEY,
    consistency REAL NOT NULL,
    competence REAL NOT NULL,
    fairness REAL NOT NULL,
    transparency REAL NOT NULL,
    accountability REAL NOT NULL,
    integrity REAL NOT NULL,
    recognition_voice REAL NOT NULL,
    repair_capacity REAL NOT NULL,
    legitimacy REAL NOT NULL,
    voluntary_compliance REAL NOT NULL,
    cooperation_capacity REAL NOT NULL,
    learning_repair REAL NOT NULL,
    arbitrariness_pressure REAL NOT NULL,
    visible_violation_pressure REAL NOT NULL,
    fragmentation_pressure REAL NOT NULL,
    administrative_burden REAL NOT NULL,
    trust_score REAL,
    social_stability REAL,
    high_trust INTEGER,
    high_stability INTEGER,
    fragile_trust_environment INTEGER,
    high_distrust_pressure INTEGER
);

CREATE TABLE institutional_trust_periods (
    period INTEGER NOT NULL,
    unit_id INTEGER NOT NULL,
    transparency REAL NOT NULL,
    arbitrariness_pressure REAL NOT NULL,
    visible_violation_pressure REAL NOT NULL,
    fragmentation_pressure REAL NOT NULL,
    administrative_burden REAL NOT NULL,
    trust_score REAL NOT NULL,
    stability_score REAL NOT NULL,
    consistency REAL NOT NULL,
    competence REAL NOT NULL,
    fairness REAL NOT NULL,
    accountability REAL NOT NULL,
    integrity REAL NOT NULL,
    recognition_voice REAL NOT NULL,
    repair_capacity REAL NOT NULL,
    legitimacy REAL NOT NULL,
    fragile_trust_environment INTEGER,
    high_distrust_pressure INTEGER,
    PRIMARY KEY (period, unit_id)
);

CREATE INDEX idx_institutional_trust_units_trust
ON institutional_trust_units (trust_score);

CREATE INDEX idx_institutional_trust_units_stability
ON institutional_trust_units (social_stability);

CREATE INDEX idx_institutional_trust_units_high
ON institutional_trust_units (high_trust);

CREATE INDEX idx_institutional_trust_units_fragile
ON institutional_trust_units (fragile_trust_environment);

CREATE INDEX idx_institutional_trust_units_distrust
ON institutional_trust_units (high_distrust_pressure);

CREATE INDEX idx_institutional_trust_periods_score
ON institutional_trust_periods (trust_score);
