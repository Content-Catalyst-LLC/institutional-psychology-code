-- Institutional Enforcement and Behavioral Incentives synthetic research schema.
-- This schema is for demonstration and reproducible analysis only.

DROP TABLE IF EXISTS institutional_enforcement_units;
DROP TABLE IF EXISTS institutional_enforcement_periods;

CREATE TABLE institutional_enforcement_units (
    unit_id INTEGER PRIMARY KEY,
    monitoring_quality REAL NOT NULL,
    legitimacy REAL NOT NULL,
    incentive_alignment REAL NOT NULL,
    sanction_credibility REAL NOT NULL,
    information_quality REAL NOT NULL,
    adaptive_learning REAL NOT NULL,
    accountability_reach REAL NOT NULL,
    compliance_burden REAL NOT NULL,
    selective_enforcement REAL NOT NULL,
    evasion_pressure REAL NOT NULL,
    hypocrisy_visibility REAL NOT NULL,
    defensive_compliance REAL NOT NULL,
    enforcement_effectiveness REAL,
    high_compliance_quality INTEGER,
    fragile_enforcement INTEGER,
    high_burden_enforcement INTEGER
);

CREATE TABLE institutional_enforcement_periods (
    period INTEGER NOT NULL,
    unit_id INTEGER NOT NULL,
    monitoring REAL NOT NULL,
    sanctions REAL NOT NULL,
    incentive_alignment REAL NOT NULL,
    compliance_burden REAL NOT NULL,
    selective_enforcement REAL NOT NULL,
    hypocrisy_visibility REAL NOT NULL,
    enforcement_score REAL NOT NULL,
    legitimacy REAL NOT NULL,
    information_quality REAL NOT NULL,
    adaptive_learning REAL NOT NULL,
    accountability_reach REAL NOT NULL,
    evasion_pressure REAL NOT NULL,
    fragile_enforcement INTEGER,
    high_burden_enforcement INTEGER,
    PRIMARY KEY (period, unit_id)
);

CREATE INDEX idx_institutional_enforcement_units_effectiveness
ON institutional_enforcement_units (enforcement_effectiveness);

CREATE INDEX idx_institutional_enforcement_units_high
ON institutional_enforcement_units (high_compliance_quality);

CREATE INDEX idx_institutional_enforcement_units_fragile
ON institutional_enforcement_units (fragile_enforcement);

CREATE INDEX idx_institutional_enforcement_units_burden
ON institutional_enforcement_units (high_burden_enforcement);

CREATE INDEX idx_institutional_enforcement_periods_score
ON institutional_enforcement_periods (enforcement_score);
