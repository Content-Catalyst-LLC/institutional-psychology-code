* Coordination Problems in Institutional Systems in Stata
* Synthetic demonstration only.

clear all
set more off
set seed 404
set obs 600

gen unit_id = _n
gen trust = runiform(10, 95)
gen information_quality = runiform(10, 95)
gen communication_clarity = runiform(10, 95)
gen focal_salience = runiform(5, 95)
gen authority_signal = runiform(5, 95)
gen norm_strength = runiform(10, 95)
gen learning_capacity = runiform(10, 95)
gen uncertainty = runiform(5, 95)
gen adaptation_burden = runiform(5, 95)
gen competing_standards = runiform(5, 95)
gen competing_authority = runiform(5, 95)
gen distributional_attention = runiform(5, 95)

gen coordination_raw = ///
    0.14 * trust + ///
    0.14 * information_quality + ///
    0.13 * communication_clarity + ///
    0.12 * focal_salience + ///
    0.10 * authority_signal + ///
    0.10 * norm_strength + ///
    0.09 * learning_capacity - ///
    0.13 * uncertainty - ///
    0.07 * adaptation_burden - ///
    0.06 * competing_standards - ///
    0.05 * competing_authority + ///
    0.04 * distributional_attention + rnormal(0, 6)

summ coordination_raw
gen coordination_quality = ((coordination_raw - r(min)) / (r(max) - r(min))) * 100

gen high_alignment = coordination_quality >= 60
gen fragile_coordination = coordination_quality >= 60 & trust < 40
gen high_burden_coordination = coordination_quality >= 60 & adaptation_burden > 65 & distributional_attention < 40

reg coordination_quality trust information_quality communication_clarity focal_salience authority_signal norm_strength learning_capacity uncertainty adaptation_burden competing_standards competing_authority distributional_attention
logit high_alignment trust communication_clarity focal_salience authority_signal norm_strength uncertainty adaptation_burden competing_standards

export delimited using "../outputs/tables/coordination_stata_synthetic_data.csv", replace
