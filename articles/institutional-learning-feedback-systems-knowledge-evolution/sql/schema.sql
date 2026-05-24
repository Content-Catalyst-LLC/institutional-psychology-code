-- Institutional Learning, Feedback Systems, and Knowledge Evolution synthetic research schema.
-- This schema is for demonstration and reproducible analysis only.

DROP TABLE IF EXISTS institutional_learning_units;
DROP TABLE IF EXISTS institutional_learning_periods;

CREATE TABLE institutional_learning_units (
    unit_id INTEGER PRIMARY KEY,
    feedback_quality REAL NOT NULL,
    memory_retention REAL NOT NULL,
    communication_openness REAL NOT NULL,
    interpretive_quality REAL NOT NULL,
    decision_revisability REAL NOT NULL,
    psychological_safety REAL NOT NULL,
    accountability_reach REAL NOT NULL,
    disconfirming_evidence REAL NOT NULL,
    institutional_inertia REAL NOT NULL,
    signal_distortion REAL NOT NULL,
    memory_decay REAL NOT NULL,
    defensive_routines REAL NOT NULL,
    power_protection REAL NOT NULL,
    feedback_delay REAL NOT NULL,
    learning_capacity REAL,
    high_adaptation INTEGER,
    fragile_learning INTEGER,
    high_inertia_learning INTEGER
);

CREATE TABLE institutional_learning_periods (
    period INTEGER NOT NULL,
    unit_id INTEGER NOT NULL,
    feedback_quality REAL NOT NULL,
    interpretive_quality REAL NOT NULL,
    disconfirming_evidence REAL NOT NULL,
    feedback_delay REAL NOT NULL,
    defensive_routines REAL NOT NULL,
    learning_score REAL NOT NULL,
    memory_retention REAL NOT NULL,
    communication_openness REAL NOT NULL,
    psychological_safety REAL NOT NULL,
    decision_revisability REAL NOT NULL,
    institutional_inertia REAL NOT NULL,
    signal_distortion REAL NOT NULL,
    power_protection REAL NOT NULL,
    fragile_learning INTEGER,
    high_inertia_learning INTEGER,
    PRIMARY KEY (period, unit_id)
);

CREATE INDEX idx_institutional_learning_units_capacity
ON institutional_learning_units (learning_capacity);

CREATE INDEX idx_institutional_learning_units_high
ON institutional_learning_units (high_adaptation);

CREATE INDEX idx_institutional_learning_units_fragile
ON institutional_learning_units (fragile_learning);

CREATE INDEX idx_institutional_learning_units_inertia
ON institutional_learning_units (high_inertia_learning);

CREATE INDEX idx_institutional_learning_periods_score
ON institutional_learning_periods (learning_score);
