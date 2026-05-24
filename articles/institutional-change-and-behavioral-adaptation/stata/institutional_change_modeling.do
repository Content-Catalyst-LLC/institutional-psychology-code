* Institutional Change and Behavioral Adaptation in Stata
* Synthetic demonstration only.

clear all
set more off
set seed 202
set obs 600

gen institution_id = _n
gen feedback_quality = runiform(15, 95)
gen adaptive_capacity = runiform(20, 95)
gen legitimacy = runiform(15, 95)
gen incentive_alignment = runiform(10, 95)
gen normative_support = runiform(10, 95)
gen governance_capacity = runiform(15, 95)
gen path_dependence = runiform(15, 95)
gen behavioral_flexibility = runiform(10, 95)
gen coordination_quality = runiform(10, 95)
gen environmental_change = runiform(5, 95)
gen distributional_attention = runiform(5, 95)
gen transition_burden = runiform(5, 95)

gen change_raw = ///
    0.13 * feedback_quality + ///
    0.14 * adaptive_capacity + ///
    0.10 * legitimacy + ///
    0.10 * incentive_alignment + ///
    0.09 * normative_support + ///
    0.12 * governance_capacity + ///
    0.10 * behavioral_flexibility + ///
    0.08 * coordination_quality + ///
    0.06 * environmental_change + ///
    0.05 * distributional_attention - ///
    0.12 * path_dependence - ///
    0.05 * transition_burden + rnormal(0, 6)

summ change_raw
gen change_score = ((change_raw - r(min)) / (r(max) - r(min))) * 100

gen successful_adaptation = change_score >= 58
gen high_transition_burden = transition_burden >= 65
gen fragile_adaptation = successful_adaptation == 1 & legitimacy < 45

reg change_score feedback_quality adaptive_capacity legitimacy incentive_alignment governance_capacity path_dependence behavioral_flexibility environmental_change distributional_attention transition_burden
logit successful_adaptation feedback_quality adaptive_capacity legitimacy governance_capacity path_dependence coordination_quality distributional_attention transition_burden

export delimited using "../outputs/tables/institutional_change_stata_synthetic_data.csv", replace
