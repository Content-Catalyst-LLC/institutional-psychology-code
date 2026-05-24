* Institutional Incentives and Behavioral Responses in Stata
* Synthetic demonstration only.

clear all
set more off
set seed 1111
set obs 650

gen unit_id = _n
gen value_alignment = runiform(10, 95)
gen fairness = runiform(10, 95)
gen information_quality = runiform(10, 95)
gen legitimacy = runiform(10, 95)
gen learning_support = runiform(10, 95)
gen accountability = runiform(10, 95)
gen bias_pressure = runiform(5, 95)
gen metric_substitution = runiform(5, 95)
gen reporting_distortion = runiform(5, 95)
gen behavioral_burden = runiform(5, 95)
gen short_termism = runiform(5, 95)
gen status_inequality = runiform(5, 95)
gen motivation_crowding = runiform(5, 95)

gen incentive_raw = ///
    0.14 * value_alignment + ///
    0.12 * fairness + ///
    0.13 * information_quality + ///
    0.12 * legitimacy + ///
    0.12 * learning_support + ///
    0.10 * accountability - ///
    0.10 * bias_pressure - ///
    0.12 * metric_substitution - ///
    0.09 * reporting_distortion - ///
    0.08 * behavioral_burden - ///
    0.07 * short_termism - ///
    0.06 * status_inequality - ///
    0.05 * motivation_crowding + rnormal(0, 6)

summ incentive_raw
gen incentive_effectiveness = ((incentive_raw - r(min)) / (r(max) - r(min))) * 100

gen high_alignment = incentive_effectiveness >= 60
gen fragile_incentive_system = incentive_effectiveness >= 60 & legitimacy < 40
gen high_burden_incentive_system = incentive_effectiveness >= 60 & behavioral_burden > 65 & metric_substitution > 65

reg incentive_effectiveness value_alignment fairness information_quality legitimacy learning_support accountability bias_pressure metric_substitution reporting_distortion behavioral_burden short_termism status_inequality motivation_crowding
logit high_alignment value_alignment fairness legitimacy information_quality learning_support accountability metric_substitution reporting_distortion behavioral_burden

export delimited using "../outputs/tables/institutional_incentives_stata_synthetic_data.csv", replace
