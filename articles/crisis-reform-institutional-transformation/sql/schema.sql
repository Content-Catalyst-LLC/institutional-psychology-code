-- Crisis, Reform, and Institutional Transformation synthetic research schema.
-- This schema is for demonstration and reproducible analysis only.

DROP TABLE IF EXISTS crisis_reform_cases;
DROP TABLE IF EXISTS crisis_reform_periods;

CREATE TABLE crisis_reform_cases (
    case_id INTEGER PRIMARY KEY,
    crisis_severity REAL NOT NULL,
    feedback_breakdown REAL NOT NULL,
    legitimacy_failure REAL NOT NULL,
    adaptive_capacity REAL NOT NULL,
    reform_window REAL NOT NULL,
    coalition_strength REAL NOT NULL,
    coordination_quality REAL NOT NULL,
    learning_rate REAL NOT NULL,
    governance_alignment REAL NOT NULL,
    power_concentration REAL NOT NULL,
    capture_risk REAL NOT NULL,
    distributional_attention REAL NOT NULL,
    transformation_score REAL,
    major_reform INTEGER,
    deep_transformation INTEGER,
    high_capture_risk INTEGER,
    low_distributional_attention INTEGER
);

CREATE TABLE crisis_reform_periods (
    period INTEGER NOT NULL,
    institution_id INTEGER NOT NULL,
    shock REAL NOT NULL,
    feedback_breakdown REAL NOT NULL,
    legitimacy REAL NOT NULL,
    reform_window REAL NOT NULL,
    transformation_pressure REAL NOT NULL,
    reform_probability REAL NOT NULL,
    adaptive_capacity REAL NOT NULL,
    coalition_strength REAL NOT NULL,
    governance_alignment REAL NOT NULL,
    capture_risk REAL NOT NULL,
    distributional_attention REAL NOT NULL,
    high_reform_likelihood INTEGER,
    capture_warning INTEGER,
    PRIMARY KEY (period, institution_id)
);

CREATE INDEX idx_crisis_reform_cases_transformation
ON crisis_reform_cases (transformation_score);

CREATE INDEX idx_crisis_reform_cases_capture
ON crisis_reform_cases (capture_risk);

CREATE INDEX idx_crisis_reform_cases_distribution
ON crisis_reform_cases (distributional_attention);

CREATE INDEX idx_crisis_reform_periods_reform_probability
ON crisis_reform_periods (reform_probability);
