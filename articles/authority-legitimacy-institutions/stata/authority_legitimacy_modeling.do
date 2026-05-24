* Authority and Legitimacy in Institutions in Stata
* Synthetic demonstration only.

clear all
set more off
set seed 1818
set obs 520

gen unit_id = _n
gen formal_authority_clarity = runiform(10, 95)
gen procedural_legitimacy = runiform(10, 95)
gen outcome_legitimacy = runiform(10, 95)
gen trust = runiform(10, 95)
gen rule_clarity = runiform(10, 95)
gen social_recognition = runiform(10, 95)
gen accountability = runiform(10, 95)
gen repair_capacity = runiform(10, 95)
gen fairness = runiform(10, 95)
gen shared_norm_support = runiform(10, 95)
gen arbitrariness_pressure = runiform(5, 95)
gen visible_inconsistency = runiform(5, 95)
gen unequal_burden = runiform(5, 95)
gen opacity_pressure = runiform(5, 95)
gen enforcement_coercion_pressure = runiform(5, 95)

gen authority_legitimacy_raw = ///
    0.11 * formal_authority_clarity + ///
    0.14 * procedural_legitimacy + ///
    0.12 * outcome_legitimacy + ///
    0.13 * trust + ///
    0.11 * rule_clarity + ///
    0.11 * social_recognition + ///
    0.12 * accountability + ///
    0.10 * repair_capacity + ///
    0.10 * fairness - ///
    0.14 * arbitrariness_pressure - ///
    0.10 * visible_inconsistency - ///
    0.09 * unequal_burden - ///
    0.08 * opacity_pressure + rnormal(0, 6)

summ authority_legitimacy_raw
gen authority_legitimacy_strength = ((authority_legitimacy_raw - r(min)) / (r(max) - r(min))) * 100

gen voluntary_compliance_raw = ///
    0.20 * authority_legitimacy_strength + ///
    0.13 * trust + ///
    0.12 * fairness + ///
    0.11 * shared_norm_support + ///
    0.10 * rule_clarity + ///
    0.08 * repair_capacity - ///
    0.12 * enforcement_coercion_pressure - ///
    0.10 * arbitrariness_pressure - ///
    0.08 * unequal_burden + rnormal(0, 6)

summ voluntary_compliance_raw
gen voluntary_compliance = ((voluntary_compliance_raw - r(min)) / (r(max) - r(min))) * 100

gen high_legitimacy = authority_legitimacy_strength >= 60
gen high_voluntary_compliance = voluntary_compliance >= 60
gen fragile_legitimacy_environment = authority_legitimacy_strength >= 60 & procedural_legitimacy < 40 & trust < 40
gen high_arbitrariness_environment = arbitrariness_pressure > 70 & visible_inconsistency > 65 & repair_capacity < 40

reg authority_legitimacy_strength formal_authority_clarity procedural_legitimacy outcome_legitimacy trust rule_clarity social_recognition accountability repair_capacity fairness arbitrariness_pressure visible_inconsistency unequal_burden opacity_pressure
logit high_voluntary_compliance authority_legitimacy_strength procedural_legitimacy trust rule_clarity social_recognition accountability repair_capacity arbitrariness_pressure enforcement_coercion_pressure unequal_burden

export delimited using "../outputs/tables/authority_legitimacy_stata_synthetic_data.csv", replace
