* Institutional Trust and Social Stability in Stata
* Synthetic demonstration only.

clear all
set more off
set seed 1717
set obs 520

gen unit_id = _n
gen consistency = runiform(10, 95)
gen competence = runiform(10, 95)
gen fairness = runiform(10, 95)
gen transparency = runiform(10, 95)
gen accountability = runiform(10, 95)
gen integrity = runiform(10, 95)
gen recognition_voice = runiform(10, 95)
gen repair_capacity = runiform(10, 95)
gen legitimacy = runiform(10, 95)
gen voluntary_compliance = runiform(10, 95)
gen cooperation_capacity = runiform(10, 95)
gen learning_repair = runiform(10, 95)
gen arbitrariness_pressure = runiform(5, 95)
gen visible_violation_pressure = runiform(5, 95)
gen fragmentation_pressure = runiform(5, 95)
gen administrative_burden = runiform(5, 95)

gen trust_raw = ///
    0.11 * consistency + ///
    0.12 * competence + ///
    0.14 * fairness + ///
    0.10 * transparency + ///
    0.13 * accountability + ///
    0.12 * integrity + ///
    0.09 * recognition_voice + ///
    0.09 * repair_capacity - ///
    0.13 * arbitrariness_pressure - ///
    0.11 * visible_violation_pressure - ///
    0.08 * administrative_burden + rnormal(0, 6)

summ trust_raw
gen trust_score = ((trust_raw - r(min)) / (r(max) - r(min))) * 100

gen stability_raw = ///
    0.18 * trust_score + ///
    0.14 * legitimacy + ///
    0.13 * voluntary_compliance + ///
    0.12 * cooperation_capacity + ///
    0.10 * learning_repair + ///
    0.08 * repair_capacity - ///
    0.12 * arbitrariness_pressure - ///
    0.10 * fragmentation_pressure - ///
    0.08 * visible_violation_pressure + rnormal(0, 6)

summ stability_raw
gen social_stability = ((stability_raw - r(min)) / (r(max) - r(min))) * 100

gen high_trust = trust_score >= 60
gen high_stability = social_stability >= 60
gen fragile_trust_environment = trust_score >= 60 & fairness < 40 & accountability < 40
gen high_distrust_pressure = arbitrariness_pressure > 70 & visible_violation_pressure > 65 & repair_capacity < 40

reg trust_score consistency competence fairness transparency accountability integrity recognition_voice repair_capacity arbitrariness_pressure visible_violation_pressure administrative_burden
logit high_stability trust_score legitimacy voluntary_compliance cooperation_capacity learning_repair repair_capacity arbitrariness_pressure fragmentation_pressure

export delimited using "../outputs/tables/institutional_trust_stata_synthetic_data.csv", replace
