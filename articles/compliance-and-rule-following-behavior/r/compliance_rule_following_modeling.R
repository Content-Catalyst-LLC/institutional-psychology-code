# Compliance and Rule-Following Behavior in R
#
# Purpose:
# Build a synthetic dataset for modeling compliance quality.
# Estimate compliance scores, high-compliance probability,
# enforcement-legitimacy interaction effects, clarity-burden interaction effects,
# fragile compliance environments, and high-burden compliance risks.
#
# Recommended install:
# pak::pak(c("tidyverse", "broom", "scales", "mgcv"))

suppressPackageStartupMessages({
  library(tidyverse)
  library(broom)
  library(scales)
  library(mgcv)
})

set.seed(1001)

article_dir <- normalizePath(file.path(".."), mustWork = FALSE)
output_dir <- file.path(article_dir, "outputs", "tables")
dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)

n <- 650

comp_data <- tibble(
  unit_id = 1:n,
  legitimacy = runif(n, 10, 95),
  fairness = runif(n, 10, 95),
  incentive_alignment = runif(n, 10, 95),
  norm_support = runif(n, 10, 95),
  enforcement_credibility = runif(n, 5, 95),
  communication_quality = runif(n, 10, 95),
  cognitive_clarity = runif(n, 10, 95),
  trust = runif(n, 10, 95),
  adaptive_learning = runif(n, 10, 95),
  compliance_burden = runif(n, 5, 95),
  selective_rule_application = runif(n, 5, 95),
  defensive_compliance = runif(n, 5, 95),
  hypocrisy_visibility = runif(n, 5, 95),
  norm_failure = runif(n, 5, 95)
) |>
  mutate(
    compliance_raw =
      0.13 * legitimacy +
      0.13 * fairness +
      0.11 * incentive_alignment +
      0.11 * norm_support +
      0.10 * enforcement_credibility +
      0.11 * communication_quality +
      0.12 * cognitive_clarity +
      0.11 * trust +
      0.09 * adaptive_learning -
      0.11 * compliance_burden -
      0.08 * selective_rule_application -
      0.06 * defensive_compliance -
      0.05 * hypocrisy_visibility -
      0.05 * norm_failure +
      rnorm(n, 0, 6),
    compliance_quality = rescale(compliance_raw, to = c(0, 100)),
    high_compliance = if_else(compliance_quality >= 60, 1, 0),
    fragile_compliance = if_else(
      high_compliance == 1 & legitimacy < 40,
      1,
      0
    ),
    high_burden_compliance = if_else(
      high_compliance == 1 &
        compliance_burden > 65 &
        selective_rule_application > 65,
      1,
      0
    )
  )

summary_table <- comp_data |>
  summarise(
    mean_compliance_quality = mean(compliance_quality),
    high_compliance_rate = mean(high_compliance),
    fragile_compliance_rate = mean(fragile_compliance),
    high_burden_compliance_rate = mean(high_burden_compliance),
    mean_legitimacy = mean(legitimacy),
    mean_fairness = mean(fairness),
    mean_cognitive_clarity = mean(cognitive_clarity),
    mean_compliance_burden = mean(compliance_burden),
    mean_selective_rule_application = mean(selective_rule_application)
  )

lm_fit <- lm(
  compliance_quality ~ legitimacy + fairness + incentive_alignment +
    norm_support + enforcement_credibility + communication_quality +
    cognitive_clarity + trust + adaptive_learning + compliance_burden +
    selective_rule_application + defensive_compliance +
    hypocrisy_visibility + norm_failure,
  data = comp_data
)

logit_fit <- glm(
  high_compliance ~ legitimacy + fairness + enforcement_credibility +
    communication_quality + cognitive_clarity + trust +
    adaptive_learning + compliance_burden +
    selective_rule_application,
  family = binomial(link = "logit"),
  data = comp_data
)

enforcement_legitimacy_fit <- lm(
  compliance_quality ~ enforcement_credibility * legitimacy +
    fairness + cognitive_clarity + trust + compliance_burden +
    selective_rule_application,
  data = comp_data
)

clarity_burden_fit <- lm(
  compliance_quality ~ cognitive_clarity * compliance_burden +
    legitimacy + fairness + communication_quality + trust +
    norm_support + selective_rule_application,
  data = comp_data
)

gam_fit <- gam(
  compliance_quality ~
    s(legitimacy) +
    s(fairness) +
    s(enforcement_credibility) +
    s(communication_quality) +
    s(cognitive_clarity) +
    s(trust) +
    s(compliance_burden) +
    s(selective_rule_application),
  data = comp_data
)

fragile_cases <- comp_data |>
  filter(fragile_compliance == 1) |>
  arrange(legitimacy) |>
  select(
    unit_id,
    compliance_quality,
    high_compliance,
    legitimacy,
    fairness,
    trust,
    communication_quality,
    cognitive_clarity,
    compliance_burden,
    selective_rule_application
  )

high_burden_cases <- comp_data |>
  filter(high_burden_compliance == 1) |>
  arrange(desc(compliance_burden)) |>
  select(
    unit_id,
    compliance_quality,
    compliance_burden,
    selective_rule_application,
    legitimacy,
    fairness,
    trust,
    defensive_compliance,
    hypocrisy_visibility
  )

write_csv(comp_data, file.path(output_dir, "compliance_rule_following_r_synthetic_data.csv"))
write_csv(summary_table, file.path(output_dir, "compliance_rule_following_r_summary.csv"))
write_csv(tidy(lm_fit, conf.int = TRUE), file.path(output_dir, "compliance_rule_following_linear_model.csv"))
write_csv(tidy(logit_fit, conf.int = TRUE, exponentiate = TRUE), file.path(output_dir, "compliance_rule_following_logit_model.csv"))
write_csv(tidy(enforcement_legitimacy_fit, conf.int = TRUE), file.path(output_dir, "compliance_rule_following_enforcement_legitimacy_interaction.csv"))
write_csv(tidy(clarity_burden_fit, conf.int = TRUE), file.path(output_dir, "compliance_rule_following_clarity_burden_interaction.csv"))
write_csv(fragile_cases, file.path(output_dir, "compliance_rule_following_fragile_cases.csv"))
write_csv(high_burden_cases, file.path(output_dir, "compliance_rule_following_high_burden_cases.csv"))

print(summary_table)
print(summary(gam_fit))
