# Institutional Responses to Public Goods Problems

This advanced companion repository supports the article **Institutional Responses to Public Goods Problems** in the Institutional Psychology knowledge series.

The repository provides a research-grade, synthetic-data scaffold for studying how institutions respond to public goods problems through incentive compatibility, trust, legitimacy, enforcement, monitoring, norm strength, coordination quality, selective incentives, perceived fairness, capture risk, scale complexity, and distributional attention.

## Research purpose

This repository is designed for:

- synthetic-data research
- public goods contribution modeling
- free-riding simulation
- trust and legitimacy analysis
- enforcement and monitoring diagnostics
- collective action modeling
- norm strength and reciprocity analysis
- provision-quality estimation
- fragile public goods diagnostics
- distributional-burden review
- capture-risk sensitivity analysis
- polycentric governance analysis
- reproducible multi-language workflows
- teaching and public-interest methods demonstration

It is not designed for automated decision-making about real people, employees, citizens, patients, students, applicants, agencies, communities, or institutions.

## Core research question

How do institutions transform individually fragile contribution incentives into durable, legitimate, and fairly distributed public goods provision?

## Conceptual frame

The scaffold models public goods provision as a function of:

- contribution rate
- trust
- legitimacy
- enforcement
- norm strength
- monitoring
- coordination
- selective incentives
- perceived fairness
- scale complexity
- capture risk
- distributional attention
- free-riding opportunity
- institutional competence

## Article folder structure

```text
articles/institutional-responses-to-public-goods-problems/
├── c/
├── cpp/
├── data/
│   ├── external/
│   ├── processed/
│   ├── raw/
│   └── synthetic/
├── docs/
├── ethics/
├── figures/
├── fortran/
├── go/
├── julia/
├── methods/
├── models/
├── notebooks/
├── outputs/
│   ├── figures/
│   ├── models/
│   ├── reports/
│   └── tables/
├── policy/
├── python/
├── r/
├── rust/
├── sql/
├── stata/
├── tests/
├── validation/
├── config/
├── article-metadata.yml
└── README.md
```

## Main variables

| Variable | Meaning |
|---|---|
| trust | Belief that others will contribute and institutions will use contributions competently |
| legitimacy | Perceived rightfulness, fairness, and credibility of contribution rules |
| enforcement | Strength of formal sanctions or mandatory contribution mechanisms |
| norm_strength | Degree to which contribution is socially expected or morally internalized |
| coordination | Alignment of expectations around who contributes, how, and why |
| monitoring | Observability of contribution, defection, use, and allocation |
| selective_incentives | Private incentives or rewards tied to contribution |
| scale_complexity | Difficulty caused by scale, heterogeneity, anonymity, or jurisdictional fragmentation |
| perceived_fairness | Perceived fairness of contribution burdens and benefit distribution |
| capture_risk | Risk that the public goods system is redirected toward narrow interests |
| distributional_attention | Degree to which unequal burdens and marginalized voices are considered |
| contribution_rate | Synthetic contribution rate |
| provision_quality | Composite synthetic quality of public goods provision |
| high_provision | Binary threshold indicator for strong provision outcomes |
| fragile_public_good | High provision paired with low legitimacy |
| high_burden_risk | High provision paired with weak distributional attention |

## Responsible-use note

All data is synthetic. The repository is intended for conceptual modeling, public-interest research, education, and transparent methods demonstration.

Do not use this repository for:

- employee screening
- employment selection
- hiring
- promotion
- compensation
- discipline
- termination
- workplace surveillance
- individual performance management
- psychological assessment
- predictive policing
- automated eligibility determination
- coercive public administration
- ranking real communities or institutions without context
- legitimacy laundering for already-decided policy or governance agendas

Any real-world adaptation must include legal review, ethical review, qualitative evidence, historical analysis, stakeholder participation, and attention to marginalized communities.

## Suggested workflow

1. Read `docs/research-design.md`.
2. Review `ethics/responsible-use-boundaries.md`.
3. Generate synthetic public goods data with `python/generate_public_goods_data.py`.
4. Run repeated contribution simulation with `python/simulate_public_goods_dynamics.py`.
5. Run fragile provision diagnostics with `python/fragile_public_goods_review.py`.
6. Run distributional burden review with `python/distributional_burden_review.py`.
7. Run capture-risk sensitivity analysis with `python/capture_risk_sensitivity.py`.
8. Analyze provision quality in R with `r/public_goods_modeling.R`.
9. Create SQLite schema with `sql/schema.sql`.
10. Review `validation/validation-plan.md` and `validation/checklist.md`.
11. Use `docs/github-embed-wordpress.html` for the WordPress GitHub block.

## WordPress embed block

The WordPress GitHub block is available at:

```text
docs/github-embed-wordpress.html
```
