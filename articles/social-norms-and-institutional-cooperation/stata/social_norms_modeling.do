* Social Norms and Institutional Cooperation in Stata
* Synthetic demonstration only.

clear all
set more off
set seed 505
set obs 600

gen unit_id = _n
gen descriptive_norm = runiform(10, 95)
gen injunctive_norm = runiform(10, 95)
gen trust = runiform(10, 95)
gen legitimacy = runiform(10, 95)
gen sanction_intensity = runiform(5, 95)
gen transmission_strength = runiform(10, 95)
gen institutional_reinforcement = runiform(10, 95)
gen norm_conflict = runiform(5, 95)
gen hypocrisy_visibility = runiform(5, 95)
gen unequal_enforcement = runiform(5, 95)
gen performative_compliance = runiform(5, 95)
gen distributional_attention = runiform(5, 95)

gen cooperation_raw = ///
    0.14 * descriptive_norm + ///
    0.14 * injunctive_norm + ///
    0.13 * trust + ///
    0.12 * legitimacy + ///
    0.10 * sanction_intensity + ///
    0.11 * transmission_strength + ///
    0.12 * institutional_reinforcement - ///
    0.13 * norm_conflict - ///
    0.08 * hypocrisy_visibility - ///
    0.07 * unequal_enforcement - ///
    0.05 * performative_compliance + ///
    0.04 * distributional_attention + rnormal(0, 6)

summ cooperation_raw
gen cooperation_score = ((cooperation_raw - r(min)) / (r(max) - r(min))) * 100

gen high_norm_compliance = cooperation_score >= 60
gen fragile_norm_environment = cooperation_score >= 60 & trust < 40
gen high_burden_norm_environment = cooperation_score >= 60 & unequal_enforcement > 65 & distributional_attention < 40

reg cooperation_score descriptive_norm injunctive_norm trust legitimacy sanction_intensity transmission_strength institutional_reinforcement norm_conflict hypocrisy_visibility unequal_enforcement performative_compliance distributional_attention
logit high_norm_compliance descriptive_norm injunctive_norm trust legitimacy sanction_intensity institutional_reinforcement norm_conflict hypocrisy_visibility unequal_enforcement

export delimited using "../outputs/tables/social_norms_stata_synthetic_data.csv", replace
