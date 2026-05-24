-- Institutional resilience synthetic research schema.
-- This schema is for demonstration and reproducible analysis only.

DROP TABLE IF EXISTS institutional_resilience;

CREATE TABLE institutional_resilience (
    institution_id INTEGER PRIMARY KEY,
    robustness REAL NOT NULL,
    adaptive_capacity REAL NOT NULL,
    recovery_capacity REAL NOT NULL,
    transformational_capacity REAL NOT NULL,
    legitimacy REAL NOT NULL,
    trust REAL NOT NULL,
    feedback_quality REAL NOT NULL,
    learning_rate REAL NOT NULL,
    redundancy REAL NOT NULL,
    modularity REAL NOT NULL,
    coordination REAL NOT NULL,
    shock_intensity REAL NOT NULL,
    resilience_index REAL,
    continuity_score REAL,
    maintained_core_function INTEGER,
    failure_flag INTEGER
);

CREATE INDEX idx_institutional_resilience_resilience
ON institutional_resilience (resilience_index);

CREATE INDEX idx_institutional_resilience_continuity
ON institutional_resilience (continuity_score);

CREATE INDEX idx_institutional_resilience_legitimacy
ON institutional_resilience (legitimacy);
