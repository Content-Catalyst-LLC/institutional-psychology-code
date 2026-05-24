-- Regulatory Behavior and Institutional Accountability synthetic research schema.
-- This schema is for demonstration and reproducible analysis only.

DROP TABLE IF EXISTS regulatory_accountability_units;
DROP TABLE IF EXISTS regulatory_accountability_periods;

CREATE TABLE regulatory_accountability_units (
    unit_id INTEGER PRIMARY KEY,
    oversight_strength REAL NOT NULL,
    legitimacy REAL NOT NULL,
    incentive_alignment REAL NOT NULL,
    enforcement_credibility REAL NOT NULL,
    information_quality REAL NOT NULL,
    adaptive_learning REAL NOT NULL,
    accountability_reach REAL NOT NULL,
    capture_pressure REAL NOT NULL,
    regulatory_burden REAL NOT NULL,
    evasion_pressure REAL NOT NULL,
    hypocrisy_visibility REAL NOT NULL,
    unequal_accountability REAL NOT NULL,
    accountability_effectiveness REAL,
    high_accountability INTEGER,
    fragile_regulation INTEGER,
    high_burden_regulation INTEGER
);

CREATE TABLE regulatory_accountability_periods (
    period INTEGER NOT NULL,
    unit_id INTEGER NOT NULL,
    oversight REAL NOT NULL,
    enforcement REAL NOT NULL,
    incentive_alignment REAL NOT NULL,
    regulatory_burden REAL NOT NULL,
    hypocrisy_visibility REAL NOT NULL,
    unequal_accountability REAL NOT NULL,
    accountability_score REAL NOT NULL,
    legitimacy REAL NOT NULL,
    information_quality REAL NOT NULL,
    adaptive_learning REAL NOT NULL,
    accountability_reach REAL NOT NULL,
    capture_pressure REAL NOT NULL,
    fragile_regulation INTEGER,
    high_burden_regulation INTEGER,
    PRIMARY KEY (period, unit_id)
);

CREATE INDEX idx_regulatory_accountability_units_effectiveness
ON regulatory_accountability_units (accountability_effectiveness);

CREATE INDEX idx_regulatory_accountability_units_high
ON regulatory_accountability_units (high_accountability);

CREATE INDEX idx_regulatory_accountability_units_fragile
ON regulatory_accountability_units (fragile_regulation);

CREATE INDEX idx_regulatory_accountability_units_burden
ON regulatory_accountability_units (high_burden_regulation);

CREATE INDEX idx_regulatory_accountability_periods_score
ON regulatory_accountability_periods (accountability_score);
