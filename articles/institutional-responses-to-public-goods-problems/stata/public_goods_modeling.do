* Public Goods Provision and Institutional Design in Stata
* Synthetic demonstration only.

clear all
set more off
set seed 303
set obs 600

gen unit_id = _n
gen trust = runiform(10, 95)
gen legitimacy = runiform(10, 95)
gen enforcement = runiform(5, 95)
gen norm_strength = runiform(10, 95)
gen coordination = runiform(10, 95)
gen monitoring = runiform(10, 95)
gen selective_incentives = runiform(5, 95)
gen scale_complexity = runiform(5, 95)
gen perceived_fairness = runiform(5, 95)
gen capture_risk = runiform(5, 90)
gen distributional_attention = runiform(5, 95)

gen contribution_rate = ///
    0.15 * trust + ///
    0.14 * legitimacy + ///
    0.12 * enforcement + ///
    0.11 * norm_strength + ///
    0.10 * coordination + ///
    0.10 * monitoring + ///
    0.09 * selective_incentives + ///
    0.08 * perceived_fairness - ///
    0.12 * scale_complexity - ///
    0.07 * capture_risk + rnormal(0, 7)

replace contribution_rate = 0 if contribution_rate < 0
replace contribution_rate = 100 if contribution_rate > 100

gen provision_quality_raw = ///
    0.22 * contribution_rate + ///
    0.13 * legitimacy + ///
    0.12 * trust + ///
    0.11 * coordination + ///
    0.10 * monitoring + ///
    0.08 * distributional_attention - ///
    0.12 * scale_complexity - ///
    0.08 * capture_risk + rnormal(0, 5)

summ provision_quality_raw
gen provision_quality = ((provision_quality_raw - r(min)) / (r(max) - r(min))) * 100

gen high_provision = provision_quality >= 60
gen fragile_public_good = provision_quality >= 60 & legitimacy < 40
gen high_burden_risk = provision_quality >= 60 & distributional_attention < 35

reg provision_quality contribution_rate legitimacy trust enforcement coordination monitoring perceived_fairness scale_complexity capture_risk
logit high_provision trust legitimacy enforcement norm_strength monitoring perceived_fairness scale_complexity capture_risk

export delimited using "../outputs/tables/public_goods_stata_synthetic_data.csv", replace
