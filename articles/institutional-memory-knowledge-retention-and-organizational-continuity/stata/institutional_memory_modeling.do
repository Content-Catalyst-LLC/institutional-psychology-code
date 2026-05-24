* Institutional Memory: Knowledge Retention and Organizational Continuity in Stata
* Synthetic demonstration only.

clear all
set more off
set seed 1313
set obs 650

gen unit_id = _n
gen documented_retention = runiform(10, 95)
gen tacit_transfer = runiform(10, 95)
gen accessibility = runiform(10, 95)
gen interpretive_use = runiform(10, 95)
gen revisability = runiform(10, 95)
gen technical_continuity = runiform(10, 95)
gen metadata_quality = runiform(10, 95)
gen distributed_integration = runiform(10, 95)
gen memory_justice = runiform(10, 95)
gen path_dependence_pressure = runiform(5, 95)
gen loss_fragmentation = runiform(5, 95)
gen selective_narration = runiform(5, 95)
gen turnover_pressure = runiform(5, 95)
gen key_person_dependency = runiform(5, 95)

gen memory_raw = ///
    0.12 * documented_retention + ///
    0.12 * tacit_transfer + ///
    0.12 * accessibility + ///
    0.12 * interpretive_use + ///
    0.11 * revisability + ///
    0.09 * technical_continuity + ///
    0.08 * metadata_quality + ///
    0.08 * distributed_integration + ///
    0.08 * memory_justice - ///
    0.11 * path_dependence_pressure - ///
    0.11 * loss_fragmentation - ///
    0.08 * selective_narration - ///
    0.07 * turnover_pressure - ///
    0.06 * key_person_dependency + rnormal(0, 6)

summ memory_raw
gen memory_effectiveness = ((memory_raw - r(min)) / (r(max) - r(min))) * 100

gen high_resilience_memory = memory_effectiveness >= 60
gen fragile_memory = memory_effectiveness >= 60 & documented_retention < 40 & tacit_transfer < 40
gen high_path_dependence_memory = memory_effectiveness >= 60 & path_dependence_pressure > 65 & revisability < 40

reg memory_effectiveness documented_retention tacit_transfer accessibility interpretive_use revisability technical_continuity metadata_quality distributed_integration memory_justice path_dependence_pressure loss_fragmentation selective_narration turnover_pressure key_person_dependency
logit high_resilience_memory documented_retention tacit_transfer accessibility interpretive_use revisability metadata_quality memory_justice path_dependence_pressure loss_fragmentation turnover_pressure

export delimited using "../outputs/tables/institutional_memory_stata_synthetic_data.csv", replace
