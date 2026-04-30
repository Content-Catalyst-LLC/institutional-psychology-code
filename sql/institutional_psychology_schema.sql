-- Root schema for institutional psychology, legitimacy, trust,
-- compliance, institutional memory, and governance data.

CREATE TABLE IF NOT EXISTS institutional_units (
    unit_id TEXT PRIMARY KEY,
    unit_name TEXT,
    sector TEXT,
    jurisdiction TEXT,
    institution_type TEXT,
    notes TEXT
);

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
    high_alignment INTEGER,
    created_at TEXT DEFAULT CURRENT_TIMESTAMP
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
    observed_alignment INTEGER,
    created_at TEXT DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS institutional_memory_events (
    memory_event_id INTEGER PRIMARY KEY,
    unit_id TEXT NOT NULL,
    event_date TEXT,
    event_type TEXT,
    retained_knowledge_score REAL,
    learning_update_score REAL,
    notes TEXT
);
