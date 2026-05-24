* Institutional Enforcement and Behavioral Incentives in Stata
* Synthetic demonstration only.

clear all
set more off
set seed 909
set obs 650

gen unit_id = _n
gen monitoring_quality = runiform(10, 95)
gen legitimacy = runiform(10, 95)
gen incentive_alignment = runiform(10, 95)
gen sanction_credibility = runiform(5, 95)
gen information_quality = runiform(10, 95)
gen adaptive_learning = runiform(10, 95)
gen accountability_reach = runiform(5, 95)
gen compliance_burden = runiform(5, 95)
gen selective_enforcement = runiform(5, 95)
gen evasion_pressure = runiform(5, 95)
gen hypocrisy_visibility = runiform(5, 95)
gen defensive_compliance = runiform(5, 95)

gen enforcement_raw = ///
    0.13 * monitoring_quality + ///
    0.13 * legitimacy + ///
    0.12 * incentive_alignment + ///
    0.12 * sanction_credibility + ///
    0.13 * information_quality + ///
    0.11 * adaptive_learning + ///
    0.10 * accountability_reach - ///
    0.08 * compliance_burden - ///
    0.08 * selective_enforcement - ///
    0.12 * evasion_pressure - ///
    0.06 * hypocrisy_visibility - ///
    0.06 * defensive_compliance + rnormal(0, 6)

summ enforcement_raw
gen enforcement_effectiveness = ((enforcement_raw - r(min)) / (r(max) - r(min))) * 100

gen high_compliance_quality = enforcement_effectiveness >= 60
gen fragile_enforcement = enforcement_effectiveness >= 60 & legitimacy < 40
gen high_burden_enforcement = enforcement_effectiveness >= 60 & compliance_burden > 65 & selective_enforcement > 65

reg enforcement_effectiveness monitoring_quality legitimacy incentive_alignment sanction_credibility information_quality adaptive_learning accountability_reach compliance_burden selective_enforcement evasion_pressure hypocrisy_visibility defensive_compliance
logit high_compliance_quality legitimacy monitoring_quality sanction_credibility information_quality adaptive_learning accountability_reach compliance_burden selective_enforcement evasion_pressure

export delimited using "../outputs/tables/institutional_enforcement_stata_synthetic_data.csv", replace
