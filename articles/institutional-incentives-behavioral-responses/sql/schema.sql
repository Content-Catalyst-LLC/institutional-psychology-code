-- Institutional Incentives and Behavioral Responses synthetic research schema.
-- This schema is for demonstration and reproducible analysis only.

DROP TABLE IF EXISTS institutional_incentive_units;
DROP TABLE IF EXISTS institutional_incentive_periods;

CREATE TABLE institutional_incentive_units (
    unit_id INTEGER PRIMARY KEY,
    value_alignment REAL NOT NULL,
    fairness REAL NOT NULL,
    information_quality REAL NOT NULL,
    legitimacy REAL NOT NULL,
    learning_support REAL NOT NULL,
    accountability REAL NOT NULL,
    bias_pressure REAL NOT NULL,
    metric_substitution REAL NOT NULL,
    reporting_distortion REAL NOT NULL,
    behavioral_burden REAL NOT NULL,
    short_termism REAL NOT NULL,
    status_inequality REAL NOT NULL,
    motivation_crowding REAL NOT NULL,
    incentive_effectiveness REAL,
    high_alignment INTEGER,
    fragile_incentive_system INTEGER,
    high_burden_incentive_system INTEGER
);

CREATE TABLE institutional_incentive_periods (
    period INTEGER NOT NULL,
    unit_id INTEGER NOT NULL,
    value_alignment REAL NOT NULL,
    information_quality REAL NOT NULL,
    bias_pressure REAL NOT NULL,
    reporting_distortion REAL NOT NULL,
    behavioral_burden REAL NOT NULL,
    short_termism REAL NOT NULL,
    incentive_score REAL NOT NULL,
    fairness REAL NOT NULL,
    legitimacy REAL NOT NULL,
    learning_support REAL NOT NULL,
    accountability REAL NOT NULL,
    metric_substitution REAL NOT NULL,
    fragile_incentive_system INTEGER,
    high_burden_incentive_system INTEGER,
    PRIMARY KEY (period, unit_id)
);

CREATE INDEX idx_institutional_incentive_units_effectiveness
ON institutional_incentive_units (incentive_effectiveness);

CREATE INDEX idx_institutional_incentive_units_high
ON institutional_incentive_units (high_alignment);

CREATE INDEX idx_institutional_incentive_units_fragile
ON institutional_incentive_units (fragile_incentive_system);

CREATE INDEX idx_institutional_incentive_units_burden
ON institutional_incentive_units (high_burden_incentive_system);

CREATE INDEX idx_institutional_incentive_periods_score
ON institutional_incentive_periods (incentive_score);
