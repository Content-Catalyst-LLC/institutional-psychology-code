* Compliance and Rule-Following Behavior in Stata
* Synthetic demonstration only.

clear all
set more off
set seed 1001
set obs 650

gen unit_id = _n
gen legitimacy = runiform(10, 95)
gen fairness = runiform(10, 95)
gen incentive_alignment = runiform(10, 95)
gen norm_support = runiform(10, 95)
gen enforcement_credibility = runiform(5, 95)
gen communication_quality = runiform(10, 95)
gen cognitive_clarity = runiform(10, 95)
gen trust = runiform(10, 95)
gen adaptive_learning = runiform(10, 95)
gen compliance_burden = runiform(5, 95)
gen selective_rule_application = runiform(5, 95)
gen defensive_compliance = runiform(5, 95)
gen hypocrisy_visibility = runiform(5, 95)
gen norm_failure = runiform(5, 95)

gen compliance_raw = ///
    0.13 * legitimacy + ///
    0.13 * fairness + ///
    0.11 * incentive_alignment + ///
    0.11 * norm_support + ///
    0.10 * enforcement_credibility + ///
    0.11 * communication_quality + ///
    0.12 * cognitive_clarity + ///
    0.11 * trust + ///
    0.09 * adaptive_learning - ///
    0.11 * compliance_burden - ///
    0.08 * selective_rule_application - ///
    0.06 * defensive_compliance - ///
    0.05 * hypocrisy_visibility - ///
    0.05 * norm_failure + rnormal(0, 6)

summ compliance_raw
gen compliance_quality = ((compliance_raw - r(min)) / (r(max) - r(min))) * 100

gen high_compliance = compliance_quality >= 60
gen fragile_compliance = compliance_quality >= 60 & legitimacy < 40
gen high_burden_compliance = compliance_quality >= 60 & compliance_burden > 65 & selective_rule_application > 65

reg compliance_quality legitimacy fairness incentive_alignment norm_support enforcement_credibility communication_quality cognitive_clarity trust adaptive_learning compliance_burden selective_rule_application defensive_compliance hypocrisy_visibility norm_failure
logit high_compliance legitimacy fairness enforcement_credibility communication_quality cognitive_clarity trust adaptive_learning compliance_burden selective_rule_application

export delimited using "../outputs/tables/compliance_rule_following_stata_synthetic_data.csv", replace
