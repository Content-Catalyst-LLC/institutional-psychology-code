-- Institutional Responses to Public Goods Problems synthetic research schema.
-- This schema is for demonstration and reproducible analysis only.

DROP TABLE IF EXISTS public_goods_units;
DROP TABLE IF EXISTS public_goods_periods;

CREATE TABLE public_goods_units (
    unit_id INTEGER PRIMARY KEY,
    trust REAL NOT NULL,
    legitimacy REAL NOT NULL,
    enforcement REAL NOT NULL,
    norm_strength REAL NOT NULL,
    coordination REAL NOT NULL,
    monitoring REAL NOT NULL,
    selective_incentives REAL NOT NULL,
    scale_complexity REAL NOT NULL,
    perceived_fairness REAL NOT NULL,
    capture_risk REAL NOT NULL,
    distributional_attention REAL NOT NULL,
    contribution_rate REAL,
    provision_quality REAL,
    high_provision INTEGER,
    fragile_public_good INTEGER,
    high_burden_risk INTEGER
);

CREATE TABLE public_goods_periods (
    period INTEGER NOT NULL,
    agent_id INTEGER NOT NULL,
    enforcement REAL NOT NULL,
    monitoring REAL NOT NULL,
    scale_complexity REAL NOT NULL,
    institutional_competence REAL NOT NULL,
    contribution INTEGER NOT NULL,
    provision_level REAL NOT NULL,
    provision_quality REAL NOT NULL,
    trust REAL NOT NULL,
    legitimacy REAL NOT NULL,
    norm_strength REAL NOT NULL,
    perceived_fairness REAL NOT NULL,
    free_ride_opportunity REAL NOT NULL,
    PRIMARY KEY (period, agent_id)
);

CREATE INDEX idx_public_goods_units_provision
ON public_goods_units (provision_quality);

CREATE INDEX idx_public_goods_units_legitimacy
ON public_goods_units (legitimacy);

CREATE INDEX idx_public_goods_units_fragile
ON public_goods_units (fragile_public_good);

CREATE INDEX idx_public_goods_units_burden
ON public_goods_units (high_burden_risk);

CREATE INDEX idx_public_goods_periods_provision
ON public_goods_periods (provision_quality);
