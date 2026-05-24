* Institutions and Human Behavior in Stata
* Synthetic demonstration only.

clear all
set more off
set seed 2020
set obs 520

gen unit_id = _n
gen normative_stability = runiform(10, 95)
gen legitimacy_strength = runiform(10, 95)
gen incentive_alignment = runiform(10, 95)
gen information_quality = runiform(10, 95)
gen memory_retention = runiform(10, 95)
gen learning_capacity = runiform(10, 95)
gen trust_reinforcement = runiform(10, 95)
gen role_clarity = runiform(10, 95)
gen repair_capacity = runiform(10, 95)
gen administrative_burden = runiform(5, 95)
gen opacity_pressure = runiform(5, 95)
gen historical_harm_pressure = runiform(5, 95)
gen fragmentation_pressure = runiform(5, 95)

gen institutional_strength_raw = ///
    0.13 * normative_stability + ///
    0.14 * legitimacy_strength + ///
    0.11 * incentive_alignment + ///
    0.12 * information_quality + ///
    0.11 * memory_retention + ///
    0.13 * learning_capacity + ///
    0.12 * trust_reinforcement + ///
    0.08 * role_clarity + ///
    0.08 * repair_capacity - ///
    0.12 * fragmentation_pressure - ///
    0.08 * opacity_pressure - ///
    0.08 * administrative_burden - ///
    0.07 * historical_harm_pressure + rnormal(0, 6)

summ institutional_strength_raw
gen institutional_strength = ((institutional_strength_raw - r(min)) / (r(max) - r(min))) * 100

gen behavioral_alignment_raw = ///
    0.18 * institutional_strength + ///
    0.13 * legitimacy_strength + ///
    0.12 * normative_stability + ///
    0.12 * incentive_alignment + ///
    0.12 * trust_reinforcement + ///
    0.10 * role_clarity - ///
    0.11 * fragmentation_pressure - ///
    0.08 * opacity_pressure - ///
    0.08 * administrative_burden + rnormal(0, 6)

summ behavioral_alignment_raw
gen behavioral_alignment = ((behavioral_alignment_raw - r(min)) / (r(max) - r(min))) * 100

gen high_institutional_alignment = institutional_strength >= 60
gen high_behavioral_alignment = behavioral_alignment >= 60
gen fragile_institutional_environment = institutional_strength >= 60 & legitimacy_strength < 40 & normative_stability < 40
gen high_fragmentation_environment = fragmentation_pressure > 70 & opacity_pressure > 65 & repair_capacity < 40

reg institutional_strength normative_stability legitimacy_strength incentive_alignment information_quality memory_retention learning_capacity trust_reinforcement role_clarity repair_capacity administrative_burden opacity_pressure historical_harm_pressure fragmentation_pressure
logit high_behavioral_alignment institutional_strength normative_stability legitimacy_strength information_quality learning_capacity trust_reinforcement role_clarity fragmentation_pressure opacity_pressure administrative_burden

export delimited using "../outputs/tables/institutions_behavior_stata_synthetic_data.csv", replace
