# Institutional Path Dependence

This advanced companion repository supports the article **Institutional Path Dependence** in the Institutional Psychology knowledge series.

The repository provides a research-grade, synthetic-data scaffold for studying how historical sequences, initial conditions, increasing returns, coordination effects, legitimacy, learning effects, switching costs, complementarity, reform capacity, and disruption pressure shape institutional persistence and lock-in.

## Research purpose

This repository is designed for:

- synthetic-data research
- institutional lock-in modeling
- path-dependence simulation
- switching-cost analysis
- legitimacy-threshold modeling
- historical sequence analysis
- institutional network and complementarity analysis
- high-burden lock-in diagnostics
- distributional review of path-dependent systems
- reproducible multi-language workflows
- teaching and public-interest methods demonstration

It is not designed for automated decision-making about real people, employees, citizens, patients, students, applicants, agencies, communities, or institutions.

## Core research question

How do early institutional arrangements become self-reinforcing paths, and under what conditions do disruption, reform capacity, legitimacy change, or coordinated alternatives make path-breaking transformation possible?

## Conceptual frame

The scaffold models institutional path dependence as a function of:

- initial conditions
- behavioral reinforcement
- feedback strength
- increasing returns
- coordination effects
- learning effects
- legitimacy
- switching costs
- complementarity
- disruption pressure
- reform capacity
- distributional burden

## Article folder structure

```text
articles/institutional-path-dependence/
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
| initial_conditions | Early institutional arrangements and starting constraints |
| behavioral_reinforcement | Repeated behavior that reproduces the institutional path |
| feedback_strength | Degree to which existing arrangements reward continued alignment |
| increasing_returns | Advantages that grow as the path becomes more widely used |
| coordination_effects | Benefits of alignment around common rules, roles, and expectations |
| learning_effects | Competence and familiarity built within the inherited system |
| legitimacy | Perceived rightfulness, normality, or acceptability of the path |
| switching_costs | Material, legal, cognitive, political, or organizational cost of changing paths |
| complementarity | Interdependence between the focal institution and surrounding institutions |
| disruption_pressure | Shock, crisis, mobilization, or reform pressure weakening the path |
| reform_capacity | Capacity to build and implement credible alternatives |
| distributional_burden | Unequal harm or constraint created by the inherited path |
| path_dependence_score | Composite synthetic score for path dependence intensity |
| lock_in | Binary threshold indicator for institutional lock-in |
| strong_lock_in | Stronger threshold indicator for entrenched path dependence |
| high_burden_lock_in | Lock-in combined with high distributional burden |

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
- legitimacy laundering for already-decided reform agendas

Any real-world adaptation must include legal review, ethical review, qualitative evidence, historical analysis, stakeholder participation, and attention to marginalized communities.

## Suggested workflow

1. Read `docs/research-design.md`.
2. Review `ethics/responsible-use-boundaries.md`.
3. Generate synthetic lock-in data with `python/generate_path_dependence_data.py`.
4. Run dynamic path-strength simulation with `python/simulate_path_dependence_lock_in.py`.
5. Run high-burden lock-in review with `python/high_burden_lock_in_review.py`.
6. Analyze lock-in probability in R with `r/path_dependence_modeling.R`.
7. Create SQLite schema with `sql/schema.sql`.
8. Review `validation/validation-plan.md` and `validation/checklist.md`.
9. Use `docs/github-embed-wordpress.html` for the WordPress GitHub block.

## WordPress embed block

The WordPress GitHub block is available at:

```text
docs/github-embed-wordpress.html
```
