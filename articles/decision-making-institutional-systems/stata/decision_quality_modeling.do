* Decision-Making in Institutional Systems in Stata
* Synthetic demonstration only.

clear all
set more off
set seed 1616
set obs 700

gen unit_id = _n
gen bounded_rationality_pressure = runiform(5, 95)
gen organizational_structure_quality = runiform(10, 95)
gen incentive_alignment = runiform(10, 95)
gen information_flow_effectiveness = runiform(10, 95)
gen legitimacy = runiform(10, 95)
gen uncertainty_management = runiform(10, 95)
gen corrective_capacity = runiform(10, 95)
gen justice_voice = runiform(10, 95)
gen memory_quality = runiform(10, 95)
gen feedback_openness = runiform(10, 95)
gen bias_distortion = runiform(5, 95)
gen power_protection = runiform(5, 95)
gen metric_fixation = runiform(5, 95)
gen siloing = runiform(5, 95)
gen premature_closure = runiform(5, 95)

gen decision_quality_raw = ///
    0.12 * organizational_structure_quality + ///
    0.12 * incentive_alignment + ///
    0.13 * information_flow_effectiveness + ///
    0.11 * legitimacy + ///
    0.11 * uncertainty_management + ///
    0.13 * corrective_capacity + ///
    0.09 * justice_voice + ///
    0.08 * memory_quality + ///
    0.08 * feedback_openness - ///
    0.13 * bounded_rationality_pressure - ///
    0.11 * bias_distortion - ///
    0.09 * power_protection - ///
    0.08 * metric_fixation - ///
    0.07 * siloing - ///
    0.07 * premature_closure + rnormal(0, 6)

summ decision_quality_raw
gen decision_quality = ((decision_quality_raw - r(min)) / (r(max) - r(min))) * 100

gen high_quality_decision = decision_quality >= 60
gen fragile_decision_environment = decision_quality >= 60 & corrective_capacity < 40 & information_flow_effectiveness < 45
gen high_distortion_environment = bias_distortion > 70 & power_protection > 65 & feedback_openness < 40

reg decision_quality bounded_rationality_pressure organizational_structure_quality incentive_alignment information_flow_effectiveness legitimacy uncertainty_management corrective_capacity justice_voice memory_quality feedback_openness bias_distortion power_protection metric_fixation siloing premature_closure
logit high_quality_decision organizational_structure_quality incentive_alignment information_flow_effectiveness legitimacy uncertainty_management corrective_capacity justice_voice memory_quality feedback_openness bounded_rationality_pressure bias_distortion power_protection

export delimited using "../outputs/tables/decision_quality_stata_synthetic_data.csv", replace
