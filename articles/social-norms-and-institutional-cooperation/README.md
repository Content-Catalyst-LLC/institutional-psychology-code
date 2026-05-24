# Social Norms and Institutional Cooperation

This advanced companion repository supports the article **Social Norms and Institutional Cooperation** in the Institutional Psychology knowledge series.

The repository provides a research-grade, synthetic-data scaffold for studying how social norms shape institutional cooperation through descriptive expectations, injunctive expectations, trust, legitimacy, sanction intensity, transmission, institutional reinforcement, norm conflict, hypocrisy visibility, unequal enforcement, performative compliance, and distributional attention.

## Research purpose

This repository is designed for:

- synthetic-data research
- norm-based cooperation modeling
- descriptive and injunctive norm analysis
- trust and legitimacy modeling
- social sanction diagnostics
- norm transmission and institutional reinforcement analysis
- norm conflict and fragmentation modeling
- norm erosion simulation
- fragile norm-environment diagnostics
- unequal enforcement review
- performative compliance analysis
- distributional norm-burden review
- reproducible multi-language workflows
- teaching and public-interest methods demonstration

It is not designed for automated decision-making about real people, employees, citizens, patients, students, applicants, agencies, communities, or institutions.

## Core research question

How do shared expectations become institutional cooperation, and under what conditions do norms support legitimacy, trust, accountability, and collective order rather than exclusion, silence, unequal scrutiny, or performative compliance?

## Conceptual frame

The scaffold models norm-based institutional cooperation as a function of:

- descriptive norm strength
- injunctive norm strength
- trust
- legitimacy
- sanction intensity
- transmission strength
- institutional reinforcement
- norm conflict
- hypocrisy visibility
- unequal enforcement
- performative compliance
- distributional attention
- compliance cost
- norm fragility
- norm repair capacity

## Article folder structure

```text
articles/social-norms-and-institutional-cooperation/
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
| descriptive_norm | Belief about what others usually do |
| injunctive_norm | Belief about what others approve or disapprove |
| trust | Belief that others will reciprocate or comply |
| legitimacy | Perceived rightfulness and fairness of the institution |
| sanction_intensity | Expected social sanction for norm violation |
| transmission_strength | Strength of socialization, learning, onboarding, mentoring, and ritual transmission |
| institutional_reinforcement | Degree to which formal routines, incentives, and leadership signals reinforce the norm |
| norm_conflict | Conflict among competing social, organizational, professional, civic, or cultural norms |
| hypocrisy_visibility | Visibility of powerful actors violating norms without accountability |
| unequal_enforcement | Degree to which informal sanctions are applied unevenly |
| performative_compliance | Surface-level conformity without substantive norm enactment |
| distributional_attention | Attention to who bears norm-compliance burdens |
| cooperation_score | Composite synthetic norm-based cooperation score |
| high_norm_compliance | Binary threshold indicator for high norm compliance |
| fragile_norm_environment | High compliance paired with low trust |
| high_burden_norm_environment | High compliance paired with unequal enforcement and weak distributional attention |

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
- suppressing dissent under the language of norm enforcement
- enforcing conformity without accountability
- legitimacy laundering for already-decided culture-change agendas

Any real-world adaptation must include legal review, ethical review, qualitative evidence, historical analysis, stakeholder participation, and attention to marginalized communities.

## Suggested workflow

1. Read `docs/research-design.md`.
2. Review `ethics/responsible-use-boundaries.md`.
3. Generate synthetic norm-cooperation data with `python/generate_social_norms_data.py`.
4. Run dynamic norm simulation with `python/simulate_norm_formation_erosion.py`.
5. Run fragile norm-environment diagnostics with `python/fragile_norm_environment_review.py`.
6. Run unequal enforcement review with `python/unequal_enforcement_review.py`.
7. Run norm-conflict sensitivity analysis with `python/norm_conflict_sensitivity.py`.
8. Analyze norm-based cooperation in R with `r/social_norms_modeling.R`.
9. Create SQLite schema with `sql/schema.sql`.
10. Review `validation/validation-plan.md` and `validation/checklist.md`.
11. Use `docs/github-embed-wordpress.html` for the WordPress GitHub block.

## WordPress embed block

The WordPress GitHub block is available at:

```text
docs/github-embed-wordpress.html
```
