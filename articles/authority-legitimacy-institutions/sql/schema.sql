-- Authority and Legitimacy in Institutions synthetic research schema.
-- This schema is for demonstration and reproducible analysis only.

DROP TABLE IF EXISTS authority_legitimacy_units;
DROP TABLE IF EXISTS authority_legitimacy_periods;

CREATE TABLE authority_legitimacy_units (
    unit_id INTEGER PRIMARY KEY,
    formal_authority_clarity REAL NOT NULL,
    procedural_legitimacy REAL NOT NULL,
    outcome_legitimacy REAL NOT NULL,
    trust REAL NOT NULL,
    rule_clarity REAL NOT NULL,
    social_recognition REAL NOT NULL,
    accountability REAL NOT NULL,
    repair_capacity REAL NOT NULL,
    fairness REAL NOT NULL,
    shared_norm_support REAL NOT NULL,
    arbitrariness_pressure REAL NOT NULL,
    visible_inconsistency REAL NOT NULL,
    unequal_burden REAL NOT NULL,
    opacity_pressure REAL NOT NULL,
    enforcement_coercion_pressure REAL NOT NULL,
    authority_legitimacy_strength REAL,
    voluntary_compliance REAL,
    high_legitimacy INTEGER,
    high_voluntary_compliance INTEGER,
    fragile_legitimacy_environment INTEGER,
    high_arbitrariness_environment INTEGER
);

CREATE TABLE authority_legitimacy_periods (
    period INTEGER NOT NULL,
    unit_id INTEGER NOT NULL,
    formal_authority_clarity REAL NOT NULL,
    arbitrariness_pressure REAL NOT NULL,
    visible_inconsistency REAL NOT NULL,
    unequal_burden REAL NOT NULL,
    opacity_pressure REAL NOT NULL,
    enforcement_coercion_pressure REAL NOT NULL,
    legitimacy_score REAL NOT NULL,
    voluntary_compliance_score REAL NOT NULL,
    procedural_legitimacy REAL NOT NULL,
    outcome_legitimacy REAL NOT NULL,
    trust REAL NOT NULL,
    rule_clarity REAL NOT NULL,
    social_recognition REAL NOT NULL,
    accountability REAL NOT NULL,
    repair_capacity REAL NOT NULL,
    fairness REAL NOT NULL,
    fragile_legitimacy_environment INTEGER,
    high_arbitrariness_environment INTEGER,
    PRIMARY KEY (period, unit_id)
);

CREATE INDEX idx_authority_legitimacy_units_legitimacy
ON authority_legitimacy_units (authority_legitimacy_strength);

CREATE INDEX idx_authority_legitimacy_units_compliance
ON authority_legitimacy_units (voluntary_compliance);

CREATE INDEX idx_authority_legitimacy_units_high
ON authority_legitimacy_units (high_legitimacy);

CREATE INDEX idx_authority_legitimacy_units_fragile
ON authority_legitimacy_units (fragile_legitimacy_environment);

CREATE INDEX idx_authority_legitimacy_units_arbitrary
ON authority_legitimacy_units (high_arbitrariness_environment);

CREATE INDEX idx_authority_legitimacy_periods_score
ON authority_legitimacy_periods (legitimacy_score);
