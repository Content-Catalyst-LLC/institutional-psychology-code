# Institutional Resilience

This companion repository supports the article **Institutional Resilience** in the Institutional Psychology knowledge series.

The repository provides a research-grade, synthetic-data scaffold for studying how institutions absorb disruption, preserve core functions, adapt under uncertainty, and maintain legitimacy, trust, coordination, and behavioral cooperation during stress.

## Research purpose

This repository is designed for:

- synthetic-data demonstration
- resilience-index construction
- institutional stress testing
- scenario analysis
- multi-language reproducible workflows
- institutional learning and governance research
- teaching and methods demonstration

It is not designed for automated decision-making about real people, employees, citizens, patients, students, applicants, or communities.

## Core research question

How do structural capacity, legitimacy, trust, feedback quality, redundancy, coordination, and shock exposure interact to shape institutional continuity under stress?

## Article folder structure

```text
articles/institutional-resilience/
├── c/
├── cpp/
├── data/
│   ├── raw/
│   └── processed/
├── docs/
├── fortran/
├── go/
├── julia/
├── notebooks/
├── outputs/
│   ├── figures/
│   └── tables/
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
| robustness | Ability to withstand immediate pressure |
| adaptive_capacity | Ability to revise routines under changing conditions |
| recovery_capacity | Ability to restore core functions |
| transformational_capacity | Ability to reorganize when inherited arrangements fail |
| legitimacy | Perceived rightfulness of institutional authority |
| trust | Confidence in institutional competence, fairness, and intelligibility |
| feedback_quality | Ability to detect, transmit, and act on stress signals |
| learning_rate | Ability to convert feedback into improved routines |
| redundancy | Backup capacity and overlap |
| modularity | Ability to contain local failures |
| coordination | Quality of cross-unit alignment |
| shock_intensity | Strength of external or internal disruption |
| resilience_index | Composite synthetic resilience score |
| continuity_score | Estimated preservation of core functions |
| maintained_core_function | Binary continuity threshold indicator |

## Responsible-use note

This repository uses synthetic data only. It is intended for conceptual modeling, public-interest research, education, and transparent methods demonstration.

Do not use this scaffold for:

- workplace surveillance
- individual psychological assessment
- hiring, firing, promotion, compensation, or discipline
- automated eligibility decisions
- predictive policing
- ranking real people or communities
- coercive public administration
- institutional blame assignment without context
- replacing participatory, qualitative, historical, or legal analysis

Institutional resilience should be evaluated with attention to legitimacy, justice, accountability, distributional burden, and marginalized communities.

## Suggested workflow

1. Review `docs/research-design.md`.
2. Generate synthetic data with `python/generate_institutional_resilience_data.py`.
3. Analyze the resilience index in R with `r/institutional_resilience_index.R`.
4. Run the Python simulation in `python/institutional_resilience_simulation.py`.
5. Create a local SQLite database with `sql/schema.sql`.
6. Review validation and ethics notes before adapting the model.

## WordPress embed block

The WordPress GitHub block is available at:

```text
docs/github-embed-wordpress.html
```
