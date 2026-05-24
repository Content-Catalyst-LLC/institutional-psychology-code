-- Decision-Making in Institutional Systems synthetic research schema.
-- This schema is for demonstration and reproducible analysis only.

DROP TABLE IF EXISTS decision_quality_units;
DROP TABLE IF EXISTS decision_quality_periods;

CREATE TABLE decision_quality_units (
    unit_id INTEGER PRIMARY KEY,
    bounded_rationality_pressure REAL NOT NULL,
    organizational_structure_quality REAL NOT NULL,
    incentive_alignment REAL NOT NULL,
    information_flow_effectiveness REAL NOT NULL,
    legitimacy REAL NOT NULL,
    uncertainty_management REAL NOT NULL,
    corrective_capacity REAL NOT NULL,
    justice_voice REAL NOT NULL,
    memory_quality REAL NOT NULL,
    feedback_openness REAL NOT NULL,
    bias_distortion REAL NOT NULL,
    power_protection REAL NOT NULL,
    metric_fixation REAL NOT NULL,
    siloing REAL NOT NULL,
    premature_closure REAL NOT NULL,
    decision_quality REAL,
    high_quality_decision INTEGER,
    fragile_decision_environment INTEGER,
    high_distortion_environment INTEGER
);

CREATE TABLE decision_quality_periods (
    period INTEGER NOT NULL,
    unit_id INTEGER NOT NULL,
    bounded_rationality_pressure REAL NOT NULL,
    uncertainty_management REAL NOT NULL,
    bias_distortion REAL NOT NULL,
    power_protection REAL NOT NULL,
    metric_fixation REAL NOT NULL,
    siloing REAL NOT NULL,
    premature_closure REAL NOT NULL,
    decision_score REAL NOT NULL,
    organizational_structure_quality REAL NOT NULL,
    incentive_alignment REAL NOT NULL,
    information_flow_effectiveness REAL NOT NULL,
    legitimacy REAL NOT NULL,
    corrective_capacity REAL NOT NULL,
    justice_voice REAL NOT NULL,
    memory_quality REAL NOT NULL,
    feedback_openness REAL NOT NULL,
    fragile_decision_environment INTEGER,
    high_distortion_environment INTEGER,
    PRIMARY KEY (period, unit_id)
);

CREATE INDEX idx_decision_quality_units_quality
ON decision_quality_units (decision_quality);

CREATE INDEX idx_decision_quality_units_high
ON decision_quality_units (high_quality_decision);

CREATE INDEX idx_decision_quality_units_fragile
ON decision_quality_units (fragile_decision_environment);

CREATE INDEX idx_decision_quality_units_distortion
ON decision_quality_units (high_distortion_environment);

CREATE INDEX idx_decision_quality_periods_score
ON decision_quality_periods (decision_score);
