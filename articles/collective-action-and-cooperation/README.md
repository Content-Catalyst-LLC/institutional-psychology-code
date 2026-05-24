# Collective Action and Cooperation

This advanced companion repository supports the article **Collective Action and Cooperation** in the Institutional Psychology knowledge series.

The repository provides a research-grade, synthetic-data scaffold for studying how institutions enable or undermine collective action through incentive alignment, trust, legitimacy, norm strength, enforcement credibility, communication quality, coordination quality, perceived fairness, free-riding pressure, burden inequality, hypocrisy visibility, and scale complexity.

## Research purpose

This repository is designed for:

- synthetic-data research
- collective action capacity modeling
- cooperation and defection simulation
- free-riding pressure diagnostics
- public goods and common-pool resource analysis
- trust and legitimacy modeling
- norm and enforcement interaction analysis
- burden inequality review
- fragile cooperation diagnostics
- high-burden cooperation review
- collective risk and threshold participation analysis
- institutional learning and feedback analysis
- reproducible multi-language workflows
- teaching and public-interest methods demonstration

It is not designed for automated decision-making about real people, employees, citizens, patients, students, applicants, agencies, communities, or institutions.

## Core research question

How do institutions transform scattered individual capacities into legitimate, durable, and fairly distributed collective action?

## Conceptual frame

The scaffold models collective action capacity as a function of:

- incentive alignment
- trust
- legitimacy
- norm strength
- enforcement credibility
- communication quality
- coordination quality
- perceived fairness
- free-riding pressure
- burden inequality
- hypocrisy visibility
- scale complexity
- institutional learning
- monitoring quality
- participation and voice

## Article folder structure

```text
articles/collective-action-and-cooperation/
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
| incentive_alignment | Degree to which individual incentives support collective outcomes |
| trust | Belief that others will cooperate and institutions will administer contributions fairly |
| legitimacy | Perceived rightfulness, competence, and procedural fairness of the institution |
| norm_strength | Strength of cooperative expectations and reciprocal obligations |
| enforcement_credibility | Credibility and fairness of monitoring and sanctions |
| communication_quality | Quality, clarity, and reach of institutional information flows |
| coordination_quality | Degree to which actors can align timing, roles, standards, and expectations |
| perceived_fairness | Perceived fairness of contribution burdens and benefit distribution |
| free_riding_pressure | Incentive or opportunity to benefit without contributing |
| burden_inequality | Unequal distribution of contribution costs, risk, or hidden labor |
| hypocrisy_visibility | Visibility of powerful actors defecting without accountability |
| scale_complexity | Difficulty caused by scale, heterogeneity, anonymity, or jurisdictional fragmentation |
| cooperation_score | Composite synthetic cooperation-quality score |
| high_cooperation | Binary threshold indicator for strong cooperation |
| fragile_cooperation | High cooperation paired with low trust |
| high_burden_cooperation | High cooperation paired with high burden inequality and weak fairness |

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
- suppressing dissent under the language of cooperation
- labeling inability, exclusion, or distrust as free-riding
- legitimacy laundering for already-decided policy or governance agendas

Any real-world adaptation must include legal review, ethical review, qualitative evidence, historical analysis, stakeholder participation, and attention to marginalized communities.

## Suggested workflow

1. Read `docs/research-design.md`.
2. Review `ethics/responsible-use-boundaries.md`.
3. Generate synthetic collective action data with `python/generate_collective_action_data.py`.
4. Run repeated cooperation simulation with `python/simulate_collective_action.py`.
5. Run fragile cooperation diagnostics with `python/fragile_cooperation_review.py`.
6. Run burden inequality review with `python/burden_inequality_review.py`.
7. Run free-riding sensitivity analysis with `python/free_riding_sensitivity.py`.
8. Analyze cooperation outcomes in R with `r/collective_action_modeling.R`.
9. Create SQLite schema with `sql/schema.sql`.
10. Review `validation/validation-plan.md` and `validation/checklist.md`.
11. Use `docs/github-embed-wordpress.html` for the WordPress GitHub block.

## WordPress embed block

The WordPress GitHub block is available at:

```text
docs/github-embed-wordpress.html
```
