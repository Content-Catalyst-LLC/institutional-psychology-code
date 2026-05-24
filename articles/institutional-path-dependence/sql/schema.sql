-- Institutional Path Dependence synthetic research schema.
-- This schema is for demonstration and reproducible analysis only.

DROP TABLE IF EXISTS path_dependence_cases;
DROP TABLE IF EXISTS path_dependence_periods;

CREATE TABLE path_dependence_cases (
    institution_id INTEGER PRIMARY KEY,
    initial_conditions REAL NOT NULL,
    behavioral_reinforcement REAL NOT NULL,
    feedback_strength REAL NOT NULL,
    increasing_returns REAL NOT NULL,
    coordination_effects REAL NOT NULL,
    learning_effects REAL NOT NULL,
    legitimacy REAL NOT NULL,
    switching_costs REAL NOT NULL,
    complementarity REAL NOT NULL,
    disruption_pressure REAL NOT NULL,
    reform_capacity REAL NOT NULL,
    distributional_burden REAL NOT NULL,
    path_dependence_score REAL,
    lock_in INTEGER,
    strong_lock_in INTEGER,
    high_burden_lock_in INTEGER
);

CREATE TABLE path_dependence_periods (
    period INTEGER NOT NULL,
    institution_id INTEGER NOT NULL,
    disruption_pressure REAL NOT NULL,
    path_strength REAL NOT NULL,
    stay_probability REAL NOT NULL,
    legitimacy REAL NOT NULL,
    switching_costs REAL NOT NULL,
    increasing_returns REAL NOT NULL,
    coordination_effects REAL NOT NULL,
    learning_effects REAL NOT NULL,
    complementarity REAL NOT NULL,
    reform_capacity REAL NOT NULL,
    distributional_burden REAL NOT NULL,
    strong_lock_in INTEGER,
    high_burden_lock_in INTEGER,
    PRIMARY KEY (period, institution_id)
);

CREATE INDEX idx_path_cases_score
ON path_dependence_cases (path_dependence_score);

CREATE INDEX idx_path_cases_lock_in
ON path_dependence_cases (lock_in);

CREATE INDEX idx_path_cases_burden
ON path_dependence_cases (distributional_burden);

CREATE INDEX idx_path_periods_stay_probability
ON path_dependence_periods (stay_probability);
