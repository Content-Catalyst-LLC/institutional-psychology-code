* Regulatory Behavior and Institutional Accountability in Stata
* Synthetic demonstration only.

clear all
set more off
set seed 808
set obs 650

gen unit_id = _n
gen oversight_strength = runiform(10, 95)
gen legitimacy = runiform(10, 95)
gen incentive_alignment = runiform(10, 95)
gen enforcement_credibility = runiform(5, 95)
gen information_quality = runiform(10, 95)
gen adaptive_learning = runiform(10, 95)
gen accountability_reach = runiform(5, 95)
gen capture_pressure = runiform(5, 95)
gen regulatory_burden = runiform(5, 95)
gen evasion_pressure = runiform(5, 95)
gen hypocrisy_visibility = runiform(5, 95)
gen unequal_accountability = runiform(5, 95)

gen accountability_raw = ///
    0.13 * oversight_strength + ///
    0.13 * legitimacy + ///
    0.11 * incentive_alignment + ///
    0.12 * enforcement_credibility + ///
    0.13 * information_quality + ///
    0.11 * adaptive_learning + ///
    0.11 * accountability_reach - ///
    0.12 * capture_pressure - ///
    0.08 * regulatory_burden - ///
    0.07 * evasion_pressure - ///
    0.06 * hypocrisy_visibility - ///
    0.06 * unequal_accountability + rnormal(0, 6)

summ accountability_raw
gen accountability_effectiveness = ((accountability_raw - r(min)) / (r(max) - r(min))) * 100

gen high_accountability = accountability_effectiveness >= 60
gen fragile_regulation = accountability_effectiveness >= 60 & legitimacy < 40
gen high_burden_regulation = accountability_effectiveness >= 60 & regulatory_burden > 65 & unequal_accountability > 65

reg accountability_effectiveness oversight_strength legitimacy incentive_alignment enforcement_credibility information_quality adaptive_learning accountability_reach capture_pressure regulatory_burden evasion_pressure hypocrisy_visibility unequal_accountability
logit high_accountability legitimacy oversight_strength information_quality enforcement_credibility adaptive_learning accountability_reach capture_pressure regulatory_burden unequal_accountability

export delimited using "../outputs/tables/regulatory_accountability_stata_synthetic_data.csv", replace
