* Institutional Norms and Social Expectations in Stata
* Synthetic demonstration only.

clear all
set more off
set seed 1919
set obs 520

gen unit_id = _n
gen norm_repetition = runiform(10, 95)
gen expectation_convergence = runiform(10, 95)
gen internalization = runiform(10, 95)
gen social_enforcement = runiform(10, 95)
gen legitimacy_alignment = runiform(10, 95)
gen trust_reinforcement = runiform(10, 95)
gen role_clarity = runiform(10, 95)
gen learning_capacity = runiform(10, 95)
gen alternative_norm_visibility = runiform(5, 95)
gen sanction_cost = runiform(5, 95)
gen suppressive_pressure = runiform(5, 95)
gen fragmentation_pressure = runiform(5, 95)
gen unequal_normative_burden = runiform(5, 95)
gen rigidity_pressure = runiform(5, 95)

gen normative_stability_raw = ///
    0.13 * norm_repetition + ///
    0.14 * expectation_convergence + ///
    0.13 * internalization + ///
    0.11 * social_enforcement + ///
    0.13 * legitimacy_alignment + ///
    0.11 * trust_reinforcement + ///
    0.09 * role_clarity + ///
    0.08 * learning_capacity - ///
    0.13 * fragmentation_pressure - ///
    0.10 * unequal_normative_burden - ///
    0.08 * suppressive_pressure + rnormal(0, 6)

summ normative_stability_raw
gen normative_stability = ((normative_stability_raw - r(min)) / (r(max) - r(min))) * 100

gen high_coordination = normative_stability >= 60
gen fragile_normative_environment = normative_stability >= 60 & expectation_convergence < 40 & legitimacy_alignment < 40
gen suppressive_norm_environment = social_enforcement > 70 & suppressive_pressure > 65 & learning_capacity < 40

gen norm_change_readiness_raw = ///
    0.16 * alternative_norm_visibility + ///
    0.14 * learning_capacity + ///
    0.12 * legitimacy_alignment - ///
    0.15 * sanction_cost - ///
    0.12 * rigidity_pressure - ///
    0.10 * suppressive_pressure + rnormal(0, 5)

summ norm_change_readiness_raw
gen norm_change_readiness = ((norm_change_readiness_raw - r(min)) / (r(max) - r(min))) * 100

reg normative_stability norm_repetition expectation_convergence internalization social_enforcement legitimacy_alignment trust_reinforcement role_clarity learning_capacity fragmentation_pressure unequal_normative_burden suppressive_pressure
logit high_coordination expectation_convergence internalization legitimacy_alignment social_enforcement trust_reinforcement role_clarity fragmentation_pressure unequal_normative_burden
reg norm_change_readiness alternative_norm_visibility learning_capacity legitimacy_alignment sanction_cost rigidity_pressure suppressive_pressure

export delimited using "../outputs/tables/institutional_norms_stata_synthetic_data.csv", replace
