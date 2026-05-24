* Behavioral Foundations of Governance Systems in Stata
* Synthetic demonstration only.

clear all
set more off
set seed 707
set obs 650

gen unit_id = _n
gen incentive_alignment = runiform(10, 95)
gen legitimacy = runiform(10, 95)
gen norm_support = runiform(10, 95)
gen cognitive_interpretability = runiform(10, 95)
gen trust = runiform(10, 95)
gen coordination_quality = runiform(10, 95)
gen enforcement_credibility = runiform(5, 95)
gen adaptive_learning = runiform(10, 95)
gen perceived_fairness = runiform(5, 95)
gen behavioral_burden = runiform(5, 95)
gen hypocrisy_visibility = runiform(5, 95)
gen power_asymmetry = runiform(5, 95)

gen governance_raw = ///
    0.11 * incentive_alignment + ///
    0.13 * legitimacy + ///
    0.10 * norm_support + ///
    0.11 * cognitive_interpretability + ///
    0.12 * trust + ///
    0.11 * coordination_quality + ///
    0.10 * enforcement_credibility + ///
    0.11 * adaptive_learning + ///
    0.10 * perceived_fairness - ///
    0.10 * behavioral_burden - ///
    0.07 * hypocrisy_visibility - ///
    0.06 * power_asymmetry + rnormal(0, 6)

summ governance_raw
gen governance_effectiveness = ((governance_raw - r(min)) / (r(max) - r(min))) * 100

gen high_governance = governance_effectiveness >= 60
gen fragile_governance = governance_effectiveness >= 60 & trust < 40
gen high_burden_governance = governance_effectiveness >= 60 & behavioral_burden > 65 & perceived_fairness < 40

reg governance_effectiveness incentive_alignment legitimacy norm_support cognitive_interpretability trust coordination_quality enforcement_credibility adaptive_learning perceived_fairness behavioral_burden hypocrisy_visibility power_asymmetry
logit high_governance legitimacy trust coordination_quality enforcement_credibility adaptive_learning cognitive_interpretability perceived_fairness behavioral_burden power_asymmetry

export delimited using "../outputs/tables/behavioral_governance_stata_synthetic_data.csv", replace
