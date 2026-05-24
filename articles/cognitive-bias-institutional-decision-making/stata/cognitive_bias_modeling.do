* Cognitive Bias in Institutional Decision-Making in Stata
* Synthetic demonstration only.

clear all
set more off
set seed 1515
set obs 650

gen unit_id = _n
gen overconfidence = runiform(5, 95)
gen anchoring_pressure = runiform(5, 95)
gen confirmation_pressure = runiform(5, 95)
gen conformity_pressure = runiform(5, 95)
gen filtering_distortion = runiform(5, 95)
gen path_lock_in = runiform(5, 95)
gen metric_tunnel_vision = runiform(5, 95)
gen power_protection = runiform(5, 95)
gen dissent_capacity = runiform(10, 95)
gen corrective_review = runiform(10, 95)
gen information_quality = runiform(10, 95)
gen feedback_openness = runiform(10, 95)
gen psychological_safety = runiform(10, 95)
gen justice_voice = runiform(10, 95)

gen bias_pressure_raw = ///
    0.12 * overconfidence + ///
    0.11 * anchoring_pressure + ///
    0.11 * confirmation_pressure + ///
    0.11 * conformity_pressure + ///
    0.12 * filtering_distortion + ///
    0.10 * path_lock_in + ///
    0.09 * metric_tunnel_vision + ///
    0.08 * power_protection - ///
    0.12 * dissent_capacity - ///
    0.11 * corrective_review - ///
    0.11 * information_quality - ///
    0.10 * feedback_openness - ///
    0.08 * psychological_safety - ///
    0.07 * justice_voice + rnormal(0, 6)

summ bias_pressure_raw
gen institutional_bias_pressure = ((bias_pressure_raw - r(min)) / (r(max) - r(min))) * 100

gen decision_quality_raw = ///
    0.14 * dissent_capacity + ///
    0.14 * corrective_review + ///
    0.14 * information_quality + ///
    0.13 * feedback_openness + ///
    0.11 * psychological_safety + ///
    0.10 * justice_voice - ///
    0.13 * overconfidence - ///
    0.13 * conformity_pressure - ///
    0.14 * filtering_distortion - ///
    0.12 * path_lock_in - ///
    0.10 * metric_tunnel_vision - ///
    0.09 * power_protection + rnormal(0, 6)

summ decision_quality_raw
gen decision_quality = ((decision_quality_raw - r(min)) / (r(max) - r(min))) * 100

gen high_resilience_decision = decision_quality >= 60
gen fragile_judgment = decision_quality >= 60 & dissent_capacity < 40 & filtering_distortion > 65
gen high_bias_environment = institutional_bias_pressure >= 65 & corrective_review < 40 & feedback_openness < 40

reg decision_quality overconfidence anchoring_pressure confirmation_pressure conformity_pressure filtering_distortion path_lock_in metric_tunnel_vision power_protection dissent_capacity corrective_review information_quality feedback_openness psychological_safety justice_voice
logit high_resilience_decision dissent_capacity corrective_review information_quality feedback_openness psychological_safety justice_voice conformity_pressure filtering_distortion path_lock_in metric_tunnel_vision

export delimited using "../outputs/tables/cognitive_bias_stata_synthetic_data.csv", replace
