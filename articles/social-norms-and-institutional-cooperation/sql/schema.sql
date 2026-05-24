-- Social Norms and Institutional Cooperation synthetic research schema.
-- This schema is for demonstration and reproducible analysis only.

DROP TABLE IF EXISTS social_norm_units;
DROP TABLE IF EXISTS social_norm_periods;

CREATE TABLE social_norm_units (
    unit_id INTEGER PRIMARY KEY,
    descriptive_norm REAL NOT NULL,
    injunctive_norm REAL NOT NULL,
    trust REAL NOT NULL,
    legitimacy REAL NOT NULL,
    sanction_intensity REAL NOT NULL,
    transmission_strength REAL NOT NULL,
    institutional_reinforcement REAL NOT NULL,
    norm_conflict REAL NOT NULL,
    hypocrisy_visibility REAL NOT NULL,
    unequal_enforcement REAL NOT NULL,
    performative_compliance REAL NOT NULL,
    distributional_attention REAL NOT NULL,
    cooperation_score REAL,
    high_norm_compliance INTEGER,
    fragile_norm_environment INTEGER,
    high_burden_norm_environment INTEGER
);

CREATE TABLE social_norm_periods (
    period INTEGER NOT NULL,
    agent_id INTEGER NOT NULL,
    institutional_reinforcement REAL NOT NULL,
    sanction_intensity REAL NOT NULL,
    norm_conflict REAL NOT NULL,
    hypocrisy_visibility REAL NOT NULL,
    unequal_enforcement REAL NOT NULL,
    distributional_attention REAL NOT NULL,
    compliant INTEGER NOT NULL,
    compliance_rate REAL NOT NULL,
    norm_cooperation_quality REAL NOT NULL,
    trust REAL NOT NULL,
    legitimacy REAL NOT NULL,
    descriptive_norm REAL NOT NULL,
    injunctive_norm REAL NOT NULL,
    fragile_norm_environment INTEGER,
    high_burden_norm_environment INTEGER,
    PRIMARY KEY (period, agent_id)
);

CREATE INDEX idx_social_norm_units_score
ON social_norm_units (cooperation_score);

CREATE INDEX idx_social_norm_units_high_compliance
ON social_norm_units (high_norm_compliance);

CREATE INDEX idx_social_norm_units_fragile
ON social_norm_units (fragile_norm_environment);

CREATE INDEX idx_social_norm_units_burden
ON social_norm_units (high_burden_norm_environment);

CREATE INDEX idx_social_norm_periods_quality
ON social_norm_periods (norm_cooperation_quality);
