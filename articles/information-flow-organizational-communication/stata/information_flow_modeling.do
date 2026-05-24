* Information Flow and Organizational Communication in Stata
* Synthetic demonstration only.

clear all
set more off
set seed 1414
set obs 650

gen unit_id = _n
gen signal_quality = runiform(10, 95)
gen communication_quality = runiform(10, 95)
gen interpretive_integration = runiform(10, 95)
gen feedback_usability = runiform(10, 95)
gen memory_retention = runiform(10, 95)
gen openness = runiform(10, 95)
gen escalation_access = runiform(10, 95)
gen trust = runiform(10, 95)
gen community_voice = runiform(10, 95)
gen digital_transparency = runiform(10, 95)
gen distortion_loss = runiform(5, 95)
gen overload = runiform(5, 95)
gen siloing = runiform(5, 95)
gen suppression_pressure = runiform(5, 95)
gen metric_tunnel_vision = runiform(5, 95)

gen information_raw = ///
    0.12 * signal_quality + ///
    0.12 * communication_quality + ///
    0.12 * interpretive_integration + ///
    0.11 * feedback_usability + ///
    0.10 * memory_retention + ///
    0.11 * openness + ///
    0.09 * escalation_access + ///
    0.08 * trust + ///
    0.07 * community_voice + ///
    0.07 * digital_transparency - ///
    0.12 * distortion_loss - ///
    0.09 * overload - ///
    0.08 * siloing - ///
    0.08 * suppression_pressure - ///
    0.07 * metric_tunnel_vision + rnormal(0, 6)

summ information_raw
gen information_effectiveness = ((information_raw - r(min)) / (r(max) - r(min))) * 100

gen high_integration = information_effectiveness >= 60
gen fragile_communication = information_effectiveness >= 60 & openness < 40 & distortion_loss > 65
gen high_overload_system = information_effectiveness >= 60 & overload > 70 & metric_tunnel_vision > 65

reg information_effectiveness signal_quality communication_quality interpretive_integration feedback_usability memory_retention openness escalation_access trust community_voice digital_transparency distortion_loss overload siloing suppression_pressure metric_tunnel_vision
logit high_integration signal_quality communication_quality interpretive_integration openness escalation_access trust community_voice distortion_loss overload suppression_pressure

export delimited using "../outputs/tables/information_flow_stata_synthetic_data.csv", replace
