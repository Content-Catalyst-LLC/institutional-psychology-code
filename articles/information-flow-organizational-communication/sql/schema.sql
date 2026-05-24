-- Information Flow and Organizational Communication synthetic research schema.
-- This schema is for demonstration and reproducible analysis only.

DROP TABLE IF EXISTS information_flow_units;
DROP TABLE IF EXISTS information_flow_periods;

CREATE TABLE information_flow_units (
    unit_id INTEGER PRIMARY KEY,
    signal_quality REAL NOT NULL,
    communication_quality REAL NOT NULL,
    interpretive_integration REAL NOT NULL,
    feedback_usability REAL NOT NULL,
    memory_retention REAL NOT NULL,
    openness REAL NOT NULL,
    escalation_access REAL NOT NULL,
    trust REAL NOT NULL,
    community_voice REAL NOT NULL,
    digital_transparency REAL NOT NULL,
    distortion_loss REAL NOT NULL,
    overload REAL NOT NULL,
    siloing REAL NOT NULL,
    suppression_pressure REAL NOT NULL,
    metric_tunnel_vision REAL NOT NULL,
    information_effectiveness REAL,
    high_integration INTEGER,
    fragile_communication INTEGER,
    high_overload_system INTEGER
);

CREATE TABLE information_flow_periods (
    period INTEGER NOT NULL,
    unit_id INTEGER NOT NULL,
    signal_quality REAL NOT NULL,
    interpretive_integration REAL NOT NULL,
    feedback_usability REAL NOT NULL,
    community_voice REAL NOT NULL,
    digital_transparency REAL NOT NULL,
    metric_tunnel_vision REAL NOT NULL,
    info_score REAL NOT NULL,
    communication_quality REAL NOT NULL,
    memory_retention REAL NOT NULL,
    openness REAL NOT NULL,
    trust REAL NOT NULL,
    escalation_access REAL NOT NULL,
    distortion_loss REAL NOT NULL,
    overload REAL NOT NULL,
    suppression_pressure REAL NOT NULL,
    fragile_communication INTEGER,
    high_overload_system INTEGER,
    PRIMARY KEY (period, unit_id)
);

CREATE INDEX idx_information_flow_units_effectiveness
ON information_flow_units (information_effectiveness);

CREATE INDEX idx_information_flow_units_high
ON information_flow_units (high_integration);

CREATE INDEX idx_information_flow_units_fragile
ON information_flow_units (fragile_communication);

CREATE INDEX idx_information_flow_units_overload
ON information_flow_units (high_overload_system);

CREATE INDEX idx_information_flow_periods_score
ON information_flow_periods (info_score);
