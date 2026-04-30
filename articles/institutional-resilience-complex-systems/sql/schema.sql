-- Article-level synthetic institutional psychology schema.

CREATE TABLE IF NOT EXISTS institutional_observations (
    observation_id INTEGER PRIMARY KEY,
    unit_id TEXT NOT NULL,
    period INTEGER NOT NULL,
    legitimacy_strength REAL,
    normative_stability REAL,
    trust_density REAL,
    cognitive_processing_quality REAL,
    information_flow_effectiveness REAL,
    memory_retention REAL,
    learning_capacity REAL,
    fragmentation_pressure REAL,
    institutional_effectiveness REAL,
    high_alignment INTEGER
);

CREATE TABLE IF NOT EXISTS compliance_records (
    record_id INTEGER PRIMARY KEY,
    unit_id TEXT NOT NULL,
    period INTEGER NOT NULL,
    perceived_legitimacy REAL,
    expectation_of_others_compliance REAL,
    procedural_trust REAL,
    norm_support REAL,
    role_identification REAL,
    uncertainty_pressure REAL,
    alignment_probability REAL,
    observed_alignment INTEGER
);

CREATE INDEX IF NOT EXISTS idx_inst_obs_unit
ON institutional_observations(unit_id);

CREATE INDEX IF NOT EXISTS idx_inst_obs_period
ON institutional_observations(period);

CREATE INDEX IF NOT EXISTS idx_compliance_unit
ON compliance_records(unit_id);

CREATE INDEX IF NOT EXISTS idx_compliance_period
ON compliance_records(period);
