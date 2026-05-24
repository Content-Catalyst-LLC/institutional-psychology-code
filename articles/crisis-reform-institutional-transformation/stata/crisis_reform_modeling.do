* Crisis, Reform, and Institutional Transformation in Stata
* Synthetic demonstration only.

clear all
set more off
set seed 123
set obs 600

gen case_id = _n
gen crisis_severity = runiform(20, 100)
gen feedback_breakdown = runiform(15, 100)
gen legitimacy_failure = runiform(10, 100)
gen adaptive_capacity = runiform(20, 95)
gen reform_window = runiform(10, 95)
gen coalition_strength = runiform(5, 95)
gen coordination_quality = runiform(10, 95)
gen learning_rate = runiform(15, 90)
gen governance_alignment = runiform(10, 95)
gen power_concentration = runiform(5, 95)
gen capture_risk = runiform(5, 90)
gen distributional_attention = runiform(5, 95)

gen transformation_raw = ///
    0.15 * crisis_severity + ///
    0.11 * feedback_breakdown + ///
    0.14 * legitimacy_failure + ///
    0.10 * adaptive_capacity + ///
    0.12 * reform_window + ///
    0.12 * coalition_strength + ///
    0.08 * coordination_quality + ///
    0.06 * learning_rate + ///
    0.06 * governance_alignment + ///
    0.05 * distributional_attention - ///
    0.07 * capture_risk - ///
    0.04 * abs(power_concentration - 50) + rnormal(0, 6)

summ transformation_raw
gen transformation_score = ((transformation_raw - r(min)) / (r(max) - r(min))) * 100

gen major_reform = transformation_score >= 60
gen deep_transformation = transformation_score >= 75
gen high_capture_risk = capture_risk >= 65
gen low_distributional_attention = distributional_attention < 35

reg transformation_score crisis_severity feedback_breakdown legitimacy_failure adaptive_capacity reform_window coalition_strength coordination_quality governance_alignment capture_risk distributional_attention
logit major_reform crisis_severity legitimacy_failure reform_window coalition_strength adaptive_capacity coordination_quality governance_alignment capture_risk distributional_attention

export delimited using "../outputs/tables/crisis_reform_stata_synthetic_data.csv", replace
