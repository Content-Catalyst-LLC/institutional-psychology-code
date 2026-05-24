# Coordination Problems in Institutional Systems

This advanced companion repository supports the article **Coordination Problems in Institutional Systems** in the Institutional Psychology knowledge series.

The repository provides a research-grade, synthetic-data scaffold for studying how institutions solve—or fail to solve—coordination problems through trust, information quality, communication clarity, focal-point salience, authority signals, norm strength, learning capacity, uncertainty reduction, standards, interoperability, timing, sequencing, and adaptation-burden management.

## Research purpose

This repository is designed for:

- synthetic-data research
- institutional coordination modeling
- expectation-alignment simulation
- focal-point and standardization analysis
- trust and communication diagnostics
- authority-signal analysis
- uncertainty and ambiguity modeling
- fragile coordination review
- high-burden coordination diagnostics
- competing-standards sensitivity analysis
- interoperability and sequencing analysis
- multi-level governance analysis
- reproducible multi-language workflows
- teaching and public-interest methods demonstration

It is not designed for automated decision-making about real people, employees, citizens, patients, students, applicants, agencies, communities, or institutions.

## Core research question

How do institutions transform scattered intentions, uncertain expectations, and competing signals into coordinated action across complex systems?

## Conceptual frame

The scaffold models institutional coordination quality as a function of:

- trust
- information quality
- communication clarity
- focal-point salience
- authority signal strength
- norm strength
- learning capacity
- uncertainty
- adaptation burden
- competing standards
- competing authority
- distributional attention
- interoperability
- timing and sequencing
- feedback capacity

## Article folder structure

```text
articles/coordination-problems-in-institutional-systems/
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
| trust | Belief that other actors will interpret and follow shared signals predictably |
| information_quality | Accuracy, timeliness, completeness, and shared accessibility of information |
| communication_clarity | Clarity and consistency of institutional signals |
| focal_salience | Degree to which a rule, signal, standard, or reference point is mutually salient |
| authority_signal | Strength and legitimacy of coordinating authority |
| norm_strength | Informal expectation supporting alignment |
| learning_capacity | Capacity to detect misalignment and revise procedures |
| uncertainty | Ambiguity about actions, timing, interpretation, or others' behavior |
| adaptation_burden | Cost of switching to or complying with a coordinated standard |
| competing_standards | Degree of fragmentation across rival standards or equilibria |
| competing_authority | Degree of ambiguity about whose signal should guide action |
| distributional_attention | Attention to who bears switching costs and who benefits from alignment |
| coordination_quality | Composite synthetic coordination score |
| high_alignment | Binary threshold indicator for strong coordination |
| fragile_coordination | High alignment paired with low trust |
| high_burden_coordination | High alignment paired with high adaptation burden and weak distributional attention |

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
- suppressing dissent under the label of miscoordination
- legitimacy laundering for already-decided standardization or governance agendas

Any real-world adaptation must include legal review, ethical review, qualitative evidence, historical analysis, stakeholder participation, and attention to marginalized communities.

## Suggested workflow

1. Read `docs/research-design.md`.
2. Review `ethics/responsible-use-boundaries.md`.
3. Generate synthetic coordination data with `python/generate_coordination_data.py`.
4. Run repeated coordination simulation with `python/simulate_coordination_dynamics.py`.
5. Run fragile coordination diagnostics with `python/fragile_coordination_review.py`.
6. Run high-burden coordination review with `python/high_burden_coordination_review.py`.
7. Run standards sensitivity analysis with `python/competing_standards_sensitivity.py`.
8. Analyze coordination quality in R with `r/coordination_modeling.R`.
9. Create SQLite schema with `sql/schema.sql`.
10. Review `validation/validation-plan.md` and `validation/checklist.md`.
11. Use `docs/github-embed-wordpress.html` for the WordPress GitHub block.

## WordPress embed block

The WordPress GitHub block is available at:

```text
docs/github-embed-wordpress.html
```
