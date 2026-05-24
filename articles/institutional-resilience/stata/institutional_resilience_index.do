* Institutional Resilience Index in Stata
* Synthetic demonstration only.

clear all
set more off
set seed 42
set obs 500

gen institution_id = _n
gen robustness = runiform(40, 95)
gen adaptive_capacity = runiform(30, 95)
gen recovery_capacity = runiform(35, 95)
gen transformational_capacity = runiform(20, 90)
gen legitimacy = runiform(25, 95)
gen trust = runiform(20, 95)
gen feedback_quality = runiform(15, 95)
gen learning_rate = runiform(20, 90)
gen redundancy = runiform(10, 85)
gen modularity = runiform(15, 90)
gen coordination = runiform(20, 95)
gen shock_intensity = runiform(10, 100)

gen resilience_raw = ///
    0.10 * robustness + ///
    0.12 * adaptive_capacity + ///
    0.10 * recovery_capacity + ///
    0.08 * transformational_capacity + ///
    0.12 * legitimacy + ///
    0.10 * trust + ///
    0.10 * feedback_quality + ///
    0.08 * learning_rate + ///
    0.07 * redundancy + ///
    0.05 * modularity + ///
    0.08 * coordination - ///
    0.10 * shock_intensity

summ resilience_raw
gen resilience_index = ((resilience_raw - r(min)) / (r(max) - r(min))) * 100

gen continuity_score = ///
    0.35 * resilience_index + ///
    0.25 * legitimacy + ///
    0.20 * trust + ///
    0.20 * coordination - ///
    0.30 * shock_intensity + rnormal(0, 7)

replace continuity_score = 0 if continuity_score < 0
replace continuity_score = 100 if continuity_score > 100

gen maintained_core_function = continuity_score >= 55
gen failure_flag = continuity_score < 40

reg continuity_score resilience_index legitimacy trust feedback_quality adaptive_capacity coordination shock_intensity
logit maintained_core_function legitimacy trust feedback_quality redundancy adaptive_capacity coordination shock_intensity

export delimited using "../outputs/tables/institutional_resilience_stata_synthetic_data.csv", replace
