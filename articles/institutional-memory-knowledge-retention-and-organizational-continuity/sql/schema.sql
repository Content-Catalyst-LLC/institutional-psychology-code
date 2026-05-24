-- Institutional Memory, Knowledge Retention, and Organizational Continuity synthetic research schema.
-- This schema is for demonstration and reproducible analysis only.

DROP TABLE IF EXISTS institutional_memory_units;
DROP TABLE IF EXISTS institutional_memory_periods;

CREATE TABLE institutional_memory_units (
    unit_id INTEGER PRIMARY KEY,
    documented_retention REAL NOT NULL,
    tacit_transfer REAL NOT NULL,
    accessibility REAL NOT NULL,
    interpretive_use REAL NOT NULL,
    revisability REAL NOT NULL,
    technical_continuity REAL NOT NULL,
    metadata_quality REAL NOT NULL,
    distributed_integration REAL NOT NULL,
    memory_justice REAL NOT NULL,
    path_dependence_pressure REAL NOT NULL,
    loss_fragmentation REAL NOT NULL,
    selective_narration REAL NOT NULL,
    turnover_pressure REAL NOT NULL,
    key_person_dependency REAL NOT NULL,
    memory_effectiveness REAL,
    high_resilience_memory INTEGER,
    fragile_memory INTEGER,
    high_path_dependence_memory INTEGER
);

CREATE TABLE institutional_memory_periods (
    period INTEGER NOT NULL,
    unit_id INTEGER NOT NULL,
    interpretive_use REAL NOT NULL,
    revisability REAL NOT NULL,
    path_dependence_pressure REAL NOT NULL,
    selective_narration REAL NOT NULL,
    distributed_integration REAL NOT NULL,
    memory_justice REAL NOT NULL,
    memory_score REAL NOT NULL,
    documented_retention REAL NOT NULL,
    tacit_transfer REAL NOT NULL,
    accessibility REAL NOT NULL,
    technical_continuity REAL NOT NULL,
    metadata_quality REAL NOT NULL,
    loss_fragmentation REAL NOT NULL,
    key_person_dependency REAL NOT NULL,
    fragile_memory INTEGER,
    high_path_dependence_memory INTEGER,
    PRIMARY KEY (period, unit_id)
);

CREATE INDEX idx_institutional_memory_units_effectiveness
ON institutional_memory_units (memory_effectiveness);

CREATE INDEX idx_institutional_memory_units_high
ON institutional_memory_units (high_resilience_memory);

CREATE INDEX idx_institutional_memory_units_fragile
ON institutional_memory_units (fragile_memory);

CREATE INDEX idx_institutional_memory_units_path
ON institutional_memory_units (high_path_dependence_memory);

CREATE INDEX idx_institutional_memory_periods_score
ON institutional_memory_periods (memory_score);
