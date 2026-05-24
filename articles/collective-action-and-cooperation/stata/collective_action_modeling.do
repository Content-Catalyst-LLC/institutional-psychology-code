* Collective Action and Cooperation in Stata
* Synthetic demonstration only.

clear all
set more off
set seed 606
set obs 600

gen unit_id = _n
gen incentive_alignment = runiform(10, 95)
gen trust = runiform(10, 95)
gen legitimacy = runiform(10, 95)
gen norm_strength = runiform(10, 95)
gen enforcement_credibility = runiform(5, 95)
gen communication_quality = runiform(10, 95)
gen coordination_quality = runiform(10, 95)
gen perceived_fairness = runiform(5, 95)
gen free_riding_pressure = runiform(5, 95)
gen burden_inequality = runiform(5, 95)
gen hypocrisy_visibility = runiform(5, 95)
gen scale_complexity = runiform(5, 95)

gen cooperation_raw = ///
    0.12 * incentive_alignment + ///
    0.13 * trust + ///
    0.12 * legitimacy + ///
    0.11 * norm_strength + ///
    0.10 * enforcement_credibility + ///
    0.11 * communication_quality + ///
    0.11 * coordination_quality + ///
    0.10 * perceived_fairness - ///
    0.12 * free_riding_pressure - ///
    0.07 * burden_inequality - ///
    0.06 * hypocrisy_visibility - ///
    0.05 * scale_complexity + rnormal(0, 6)

summ cooperation_raw
gen cooperation_score = ((cooperation_raw - r(min)) / (r(max) - r(min))) * 100

gen high_cooperation = cooperation_score >= 60
gen fragile_cooperation = cooperation_score >= 60 & trust < 40
gen high_burden_cooperation = cooperation_score >= 60 & burden_inequality > 65 & perceived_fairness < 40

reg cooperation_score incentive_alignment trust legitimacy norm_strength enforcement_credibility communication_quality coordination_quality perceived_fairness free_riding_pressure burden_inequality hypocrisy_visibility scale_complexity
logit high_cooperation trust legitimacy norm_strength enforcement_credibility communication_quality perceived_fairness free_riding_pressure burden_inequality

export delimited using "../outputs/tables/collective_action_stata_synthetic_data.csv", replace
