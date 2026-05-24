* Institutional Learning: Feedback Systems and Knowledge Evolution in Stata
* Synthetic demonstration only.

clear all
set more off
set seed 1212
set obs 650

gen unit_id = _n
gen feedback_quality = runiform(10, 95)
gen memory_retention = runiform(10, 95)
gen communication_openness = runiform(10, 95)
gen interpretive_quality = runiform(10, 95)
gen decision_revisability = runiform(10, 95)
gen psychological_safety = runiform(10, 95)
gen accountability_reach = runiform(10, 95)
gen disconfirming_evidence = runiform(5, 95)
gen institutional_inertia = runiform(5, 95)
gen signal_distortion = runiform(5, 95)
gen memory_decay = runiform(5, 95)
gen defensive_routines = runiform(5, 95)
gen power_protection = runiform(5, 95)
gen feedback_delay = runiform(5, 95)

gen learning_raw = ///
    0.13 * feedback_quality + ///
    0.12 * memory_retention + ///
    0.12 * communication_openness + ///
    0.12 * interpretive_quality + ///
    0.12 * decision_revisability + ///
    0.12 * psychological_safety + ///
    0.10 * accountability_reach + ///
    0.06 * disconfirming_evidence - ///
    0.12 * institutional_inertia - ///
    0.10 * signal_distortion - ///
    0.08 * memory_decay - ///
    0.08 * defensive_routines - ///
    0.08 * power_protection - ///
    0.07 * feedback_delay + rnormal(0, 6)

summ learning_raw
gen learning_capacity = ((learning_raw - r(min)) / (r(max) - r(min))) * 100

gen high_adaptation = learning_capacity >= 60
gen fragile_learning = learning_capacity >= 60 & communication_openness < 40
gen high_inertia_learning = learning_capacity >= 60 & institutional_inertia > 65 & signal_distortion > 65

reg learning_capacity feedback_quality memory_retention communication_openness interpretive_quality decision_revisability psychological_safety accountability_reach disconfirming_evidence institutional_inertia signal_distortion memory_decay defensive_routines power_protection feedback_delay
logit high_adaptation feedback_quality memory_retention communication_openness decision_revisability psychological_safety accountability_reach institutional_inertia signal_distortion power_protection

export delimited using "../outputs/tables/institutional_learning_stata_synthetic_data.csv", replace
