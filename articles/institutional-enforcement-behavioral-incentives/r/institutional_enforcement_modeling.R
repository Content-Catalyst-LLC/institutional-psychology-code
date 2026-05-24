# Institutional Enforcement and Behavioral Incentives in R
#
# Purpose:
# Build a synthetic dataset for modeling enforcement effectiveness.
# Estimate enforcement quality, high-compliance probability,
# monitoring-information interaction effects, sanction-legitimacy effects,
# fragile enforcement environments, and high-burden enforcement risks.
#
# Recommended install:
# pak::pak(c("tidyverse", "broom", "scales", "mgcv"))

suppressPackageStartupMessages({
  library(tidyverse)
  library(broom)
  library(scales)
  library(mgcv)
})

set.seed(909)

article_dir <- normalizePath(file.path(".."), mustWork = FALSE)
output_dir <- file.path(article_dir, "outputs", "tables")
dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)

n <- 650

enf_data <- tibble(
  unit_id = 1:n,
  monitoring_quality = runif(n, 10, 95),
  legitimacy = runif(n, 10, 95),
  incentive_alignment = runif(n, 10, 95),
  sanction_credibility = runif(n, 5, 95),
  information_quality = runif(n, 10, 95),
  adaptive_learning = runif(n, 10, 95),
  accountability_reach = runif(n, 5, 95),
  compliance_burden = runif(n, 5, 95),
  selective_enforcement = runif(n, 5, 95),
  evasion_pressure = runif(n, 5, 95),
  hypocrisy_visibility = runif(n, 5, 95),
  defensive_compliance = runif(n, 5, 95)
) |>
  mutate(
    enforcement_raw =
      0.13 * monitoring_quality +
      0.13 * legitimacy +
      0.12 * incentive_alignment +
      0.12 * sanction_credibility +
      0.13 * information_quality +
      0.11 * adaptive_learning +
      0.10 * accountability_reach -
      0.08 * compliance_burden -
      0.08 * selective_enforcement -
      0.12 * evasion_pressure -
      0.06 * hypocrisy_visibility -
      0.06 * defensive_compliance +
      rnorm(n, 0, 6),
    enforcement_effectiveness = rescale(enforcement_raw, to = c(0, 100)),
    high_compliance_quality = if_else(enforcement_effectiveness >= 60, 1, 0),
    fragile_enforcement = if_else(
      high_compliance_quality == 1 & legitimacy < 40,
      1,
      0
    ),
    high_burden_enforcement = if_else(
      high_compliance_quality == 1 &
        compliance_burden > 65 &
        selective_enforcement > 65,
      1,
      0
    )
  )

summary_table <- enf_data |>
  summarise(
    mean_enforcement_effectiveness = mean(enforcement_effectiveness),
    high_compliance_quality_rate = mean(high_compliance_quality),
    fragile_enforcement_rate = mean(fragile_enforcement),
    high_burden_enforcement_rate = mean(high_burden_enforcement),
    mean_legitimacy = mean(legitimacy),
    mean_information_quality = mean(information_quality),
    mean_evasion_pressure = mean(evasion_pressure),
    mean_compliance_burden = mean(compliance_burden),
    mean_selective_enforcement = mean(selective_enforcement)
  )

lm_fit <- lm(
  enforcement_effectiveness ~ monitoring_quality + legitimacy +
    incentive_alignment + sanction_credibility + information_quality +
    adaptive_learning + accountability_reach + compliance_burden +
    selective_enforcement + evasion_pressure + hypocrisy_visibility +
    defensive_compliance,
  data = enf_data
)

logit_fit <- glm(
  high_compliance_quality ~ legitimacy + monitoring_quality +
    sanction_credibility + information_quality + adaptive_learning +
    accountability_reach + compliance_burden + selective_enforcement +
    evasion_pressure,
  family = binomial(link = "logit"),
  data = enf_data
)

monitoring_information_fit <- lm(
  enforcement_effectiveness ~ monitoring_quality * information_quality +
    legitimacy + sanction_credibility + adaptive_learning +
    evasion_pressure + compliance_burden,
  data = enf_data
)

sanction_legitimacy_fit <- lm(
  enforcement_effectiveness ~ sanction_credibility * legitimacy +
    monitoring_quality + information_quality + adaptive_learning +
    selective_enforcement + evasion_pressure,
  data = enf_data
)

gam_fit <- gam(
  enforcement_effectiveness ~
    s(monitoring_quality) +
    s(legitimacy) +
    s(sanction_credibility) +
    s(information_quality) +
    s(adaptive_learning) +
    s(compliance_burden) +
    s(selective_enforcement) +
    s(evasion_pressure),
  data = enf_data
)

fragile_cases <- enf_data |>
  filter(fragile_enforcement == 1) |>
  arrange(legitimacy) |>
  select(
    unit_id,
    enforcement_effectiveness,
    high_compliance_quality,
    legitimacy,
    monitoring_quality,
    information_quality,
    sanction_credibility,
    evasion_pressure,
    compliance_burden,
    selective_enforcement
  )

high_burden_cases <- enf_data |>
  filter(high_burden_enforcement == 1) |>
  arrange(desc(compliance_burden)) |>
  select(
    unit_id,
    enforcement_effectiveness,
    compliance_burden,
    selective_enforcement,
    legitimacy,
    accountability_reach,
    evasion_pressure,
    hypocrisy_visibility
  )

write_csv(enf_data, file.path(output_dir, "institutional_enforcement_r_synthetic_data.csv"))
write_csv(summary_table, file.path(output_dir, "institutional_enforcement_r_summary.csv"))
write_csv(tidy(lm_fit, conf.int = TRUE), file.path(output_dir, "institutional_enforcement_linear_model.csv"))
write_csv(tidy(logit_fit, conf.int = TRUE, exponentiate = TRUE), file.path(output_dir, "institutional_enforcement_logit_model.csv"))
write_csv(tidy(monitoring_information_fit, conf.int = TRUE), file.path(output_dir, "institutional_enforcement_monitoring_information_interaction.csv"))
write_csv(tidy(sanction_legitimacy_fit, conf.int = TRUE), file.path(output_dir, "institutional_enforcement_sanction_legitimacy_interaction.csv"))
write_csv(fragile_cases, file.path(output_dir, "institutional_enforcement_fragile_cases.csv"))
write_csv(high_burden_cases, file.path(output_dir, "institutional_enforcement_high_burden_cases.csv"))

print(summary_table)
print(summary(gam_fit))
