* Institutional Path Dependence in Stata
* Synthetic demonstration only.

clear all
set more off
set seed 101
set obs 600

gen institution_id = _n
gen initial_conditions = runiform(20, 95)
gen behavioral_reinforcement = runiform(15, 95)
gen feedback_strength = runiform(20, 95)
gen increasing_returns = runiform(10, 95)
gen coordination_effects = runiform(15, 95)
gen learning_effects = runiform(20, 95)
gen legitimacy = runiform(20, 95)
gen switching_costs = runiform(10, 100)
gen complementarity = runiform(15, 95)
gen disruption_pressure = runiform(5, 90)
gen reform_capacity = runiform(5, 95)
gen distributional_burden = runiform(5, 95)

gen path_dependence_raw = ///
    0.08 * initial_conditions + ///
    0.12 * behavioral_reinforcement + ///
    0.12 * feedback_strength + ///
    0.13 * increasing_returns + ///
    0.11 * coordination_effects + ///
    0.10 * learning_effects + ///
    0.12 * legitimacy + ///
    0.12 * switching_costs + ///
    0.10 * complementarity - ///
    0.12 * disruption_pressure - ///
    0.05 * reform_capacity + rnormal(0, 5)

summ path_dependence_raw
gen path_dependence_score = ((path_dependence_raw - r(min)) / (r(max) - r(min))) * 100

gen lock_in = path_dependence_score >= 60
gen strong_lock_in = path_dependence_score >= 75
gen high_burden_lock_in = path_dependence_score >= 60 & distributional_burden >= 65

reg path_dependence_score behavioral_reinforcement feedback_strength increasing_returns coordination_effects legitimacy switching_costs complementarity disruption_pressure reform_capacity distributional_burden
logit lock_in increasing_returns legitimacy switching_costs coordination_effects learning_effects complementarity disruption_pressure reform_capacity

export delimited using "../outputs/tables/institutional_path_dependence_stata_synthetic_data.csv", replace
