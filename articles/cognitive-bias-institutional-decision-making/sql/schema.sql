-- Cognitive Bias in Institutional Decision-Making synthetic research schema.
-- This schema is for demonstration and reproducible analysis only.

DROP TABLE IF EXISTS cognitive_bias_units;
DROP TABLE IF EXISTS cognitive_bias_periods;

CREATE TABLE cognitive_bias_units (
    unit_id INTEGER PRIMARY KEY,
    overconfidence REAL NOT NULL,
    anchoring_pressure REAL NOT NULL,
    confirmation_pressure REAL NOT NULL,
    conformity_pressure REAL NOT NULL,
    filtering_distortion REAL NOT NULL,
    path_lock_in REAL NOT NULL,
    metric_tunnel_vision REAL NOT NULL,
    power_protection REAL NOT NULL,
    dissent_capacity REAL NOT NULL,
    corrective_review REAL NOT NULL,
    information_quality REAL NOT NULL,
    feedback_openness REAL NOT NULL,
    psychological_safety REAL NOT NULL,
    justice_voice REAL NOT NULL,
    institutional_bias_pressure REAL,
    decision_quality REAL,
    high_resilience_decision INTEGER,
    fragile_judgment INTEGER,
    high_bias_environment INTEGER
);

CREATE TABLE cognitive_bias_periods (
    period INTEGER NOT NULL,
    unit_id INTEGER NOT NULL,
    overconfidence REAL NOT NULL,
    anchoring_pressure REAL NOT NULL,
    confirmation_pressure REAL NOT NULL,
    filtering_distortion REAL NOT NULL,
    feedback_openness REAL NOT NULL,
    metric_tunnel_vision REAL NOT NULL,
    power_protection REAL NOT NULL,
    bias_pressure REAL NOT NULL,
    decision_score REAL NOT NULL,
    conformity_pressure REAL NOT NULL,
    path_lock_in REAL NOT NULL,
    dissent_capacity REAL NOT NULL,
    corrective_review REAL NOT NULL,
    information_quality REAL NOT NULL,
    psychological_safety REAL NOT NULL,
    justice_voice REAL NOT NULL,
    fragile_judgment INTEGER,
    high_bias_environment INTEGER,
    PRIMARY KEY (period, unit_id)
);

CREATE INDEX idx_cognitive_bias_units_decision_quality
ON cognitive_bias_units (decision_quality);

CREATE INDEX idx_cognitive_bias_units_bias_pressure
ON cognitive_bias_units (institutional_bias_pressure);

CREATE INDEX idx_cognitive_bias_units_high
ON cognitive_bias_units (high_resilience_decision);

CREATE INDEX idx_cognitive_bias_units_fragile
ON cognitive_bias_units (fragile_judgment);

CREATE INDEX idx_cognitive_bias_units_high_bias
ON cognitive_bias_units (high_bias_environment);

CREATE INDEX idx_cognitive_bias_periods_decision_score
ON cognitive_bias_periods (decision_score);
