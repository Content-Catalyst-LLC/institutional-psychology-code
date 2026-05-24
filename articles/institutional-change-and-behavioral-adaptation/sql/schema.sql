-- Institutional Change and Behavioral Adaptation synthetic research schema.
-- This schema is for demonstration and reproducible analysis only.

DROP TABLE IF EXISTS institutional_change_cases;
DROP TABLE IF EXISTS institutional_change_periods;

CREATE TABLE institutional_change_cases (
    institution_id INTEGER PRIMARY KEY,
    feedback_quality REAL NOT NULL,
    adaptive_capacity REAL NOT NULL,
    legitimacy REAL NOT NULL,
    incentive_alignment REAL NOT NULL,
    normative_support REAL NOT NULL,
    governance_capacity REAL NOT NULL,
    path_dependence REAL NOT NULL,
    behavioral_flexibility REAL NOT NULL,
    coordination_quality REAL NOT NULL,
    environmental_change REAL NOT NULL,
    distributional_attention REAL NOT NULL,
    transition_burden REAL NOT NULL,
    change_score REAL,
    successful_adaptation INTEGER,
    high_transition_burden INTEGER,
    fragile_adaptation INTEGER
);

CREATE TABLE institutional_change_periods (
    period INTEGER NOT NULL,
    institution_id INTEGER NOT NULL,
    environmental_change REAL NOT NULL,
    adaptation_pressure REAL NOT NULL,
    institutional_strength REAL NOT NULL,
    legitimacy REAL NOT NULL,
    path_dependence REAL NOT NULL,
    transition_burden REAL NOT NULL,
    coordination_quality REAL NOT NULL,
    distributional_attention REAL NOT NULL,
    high_change INTEGER,
    fragile_adaptation INTEGER,
    PRIMARY KEY (period, institution_id)
);

CREATE INDEX idx_change_cases_score
ON institutional_change_cases (change_score);

CREATE INDEX idx_change_cases_success
ON institutional_change_cases (successful_adaptation);

CREATE INDEX idx_change_cases_fragile
ON institutional_change_cases (fragile_adaptation);

CREATE INDEX idx_change_cases_burden
ON institutional_change_cases (transition_burden);

CREATE INDEX idx_change_periods_adaptation_pressure
ON institutional_change_periods (adaptation_pressure);
