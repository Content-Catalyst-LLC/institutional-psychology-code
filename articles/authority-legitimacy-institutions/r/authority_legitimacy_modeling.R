# Authority and Legitimacy in Institutions in R
#
# Purpose:
# Build a synthetic dataset for modeling authority-legitimacy strength,
# trust, procedural legitimacy, outcome legitimacy, rule clarity,
# accountability, repair capacity, social recognition, arbitrariness pressure,
# and voluntary compliance.
#
# Recommended install:
# pak::pak(c("tidyverse", "broom", "scales", "mgcv"))

suppressPackageStartupMessages({
  library(tidyverse)
  library(broom)
  library(scales)
  library(mgcv)
})

set.seed(1818)

article_dir <- normalizePath(file.path(".."), mustWork = FALSE)
output_dir <- file.path(article_dir, "outputs", "tables")
dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)

n <- 520

legit_data <- tibble(
  unit_id = 1:n,
  formal_authority_clarity = runif(n, 10, 95),
  procedural_legitimacy = runif(n, 10, 95),
  outcome_legitimacy = runif(n, 10, 95),
  trust = runif(n, 10, 95),
  rule_clarity = runif(n, 10, 95),
  social_recognition = runif(n, 10, 95),
  accountability = runif(n, 10, 95),
  repair_capacity = runif(n, 10, 95),
  fairness = runif(n, 10, 95),
  shared_norm_support = runif(n, 10, 95),
  arbitrariness_pressure = runif(n, 5, 95),
  visible_inconsistency = runif(n, 5, 95),
  unequal_burden = runif(n, 5, 95),
  opacity_pressure = runif(n, 5, 95),
  enforcement_coercion_pressure = runif(n, 5, 95)
) |>
  mutate(
    authority_legitimacy_raw =
      0.11 * formal_authority_clarity +
      0.14 * procedural_legitimacy +
      0.12 * outcome_legitimacy +
      0.13 * trust +
      0.11 * rule_clarity +
      0.11 * social_recognition +
      0.12 * accountability +
      0.10 * repair_capacity +
      0.10 * fairness -
      0.14 * arbitrariness_pressure -
      0.10 * visible_inconsistency -
      0.09 * unequal_burden -
      0.08 * opacity_pressure +
      rnorm(n, 0, 6),
    authority_legitimacy_strength = rescale(authority_legitimacy_raw, to = c(0, 100)),
    voluntary_compliance_raw =
      0.20 * authority_legitimacy_strength +
      0.13 * trust +
      0.12 * fairness +
      0.11 * shared_norm_support +
      0.10 * rule_clarity +
      0.08 * repair_capacity -
      0.12 * enforcement_coercion_pressure -
      0.10 * arbitrariness_pressure -
      0.08 * unequal_burden +
      rnorm(n, 0, 6),
    voluntary_compliance = rescale(voluntary_compliance_raw, to = c(0, 100)),
    high_legitimacy = if_else(authority_legitimacy_strength >= 60, 1, 0),
    high_voluntary_compliance = if_else(voluntary_compliance >= 60, 1, 0),
    fragile_legitimacy_environment = if_else(
      authority_legitimacy_strength >= 60 &
        procedural_legitimacy < 40 &
        trust < 40,
      1,
      0
    ),
    high_arbitrariness_environment = if_else(
      arbitrariness_pressure > 70 &
        visible_inconsistency > 65 &
        repair_capacity < 40,
      1,
      0
    )
  )

summary_table <- legit_data |>
  summarise(
    mean_authority_legitimacy_strength = mean(authority_legitimacy_strength),
    mean_voluntary_compliance = mean(voluntary_compliance),
    high_legitimacy_rate = mean(high_legitimacy),
    high_voluntary_compliance_rate = mean(high_voluntary_compliance),
    fragile_legitimacy_environment_rate = mean(fragile_legitimacy_environment),
    high_arbitrariness_environment_rate = mean(high_arbitrariness_environment),
    mean_procedural_legitimacy = mean(procedural_legitimacy),
    mean_trust = mean(trust),
    mean_accountability = mean(accountability),
    mean_repair_capacity = mean(repair_capacity),
    mean_arbitrariness_pressure = mean(arbitrariness_pressure)
  )

lm_fit <- lm(
  authority_legitimacy_strength ~ formal_authority_clarity +
    procedural_legitimacy + outcome_legitimacy + trust +
    rule_clarity + social_recognition + accountability +
    repair_capacity + fairness + arbitrariness_pressure +
    visible_inconsistency + unequal_burden + opacity_pressure,
  data = legit_data
)

logit_fit <- glm(
  high_voluntary_compliance ~ authority_legitimacy_strength +
    procedural_legitimacy + trust + rule_clarity +
    social_recognition + accountability + repair_capacity +
    arbitrariness_pressure + enforcement_coercion_pressure +
    unequal_burden,
  family = binomial(link = "logit"),
  data = legit_data
)

legitimacy_trust_fit <- lm(
  authority_legitimacy_strength ~ procedural_legitimacy * trust +
    rule_clarity + accountability + repair_capacity +
    arbitrariness_pressure + outcome_legitimacy,
  data = legit_data
)

accountability_repair_fit <- lm(
  authority_legitimacy_strength ~ accountability * repair_capacity +
    procedural_legitimacy + trust + fairness +
    visible_inconsistency + unequal_burden,
  data = legit_data
)

clarity_authority_fit <- lm(
  authority_legitimacy_strength ~ formal_authority_clarity * rule_clarity +
    procedural_legitimacy + social_recognition +
    arbitrariness_pressure + opacity_pressure,
  data = legit_data
)

gam_fit <- gam(
  authority_legitimacy_strength ~
    s(formal_authority_clarity) +
    s(procedural_legitimacy) +
    s(outcome_legitimacy) +
    s(trust) +
    s(rule_clarity) +
    s(social_recognition) +
    s(accountability) +
    s(repair_capacity) +
    s(arbitrariness_pressure) +
    s(visible_inconsistency),
  data = legit_data
)

fragile_cases <- legit_data |>
  filter(fragile_legitimacy_environment == 1) |>
  arrange(procedural_legitimacy, trust) |>
  select(
    unit_id,
    authority_legitimacy_strength,
    voluntary_compliance,
    procedural_legitimacy,
    trust,
    accountability,
    repair_capacity,
    fairness,
    social_recognition,
    arbitrariness_pressure,
    visible_inconsistency
  )

high_arbitrariness_cases <- legit_data |>
  filter(high_arbitrariness_environment == 1) |>
  arrange(desc(arbitrariness_pressure), desc(visible_inconsistency)) |>
  select(
    unit_id,
    authority_legitimacy_strength,
    voluntary_compliance,
    arbitrariness_pressure,
    visible_inconsistency,
    unequal_burden,
    opacity_pressure,
    repair_capacity,
    procedural_legitimacy,
    trust
  )

write_csv(legit_data, file.path(output_dir, "authority_legitimacy_r_synthetic_data.csv"))
write_csv(summary_table, file.path(output_dir, "authority_legitimacy_r_summary.csv"))
write_csv(tidy(lm_fit, conf.int = TRUE), file.path(output_dir, "authority_legitimacy_linear_model.csv"))
write_csv(tidy(logit_fit, conf.int = TRUE, exponentiate = TRUE), file.path(output_dir, "authority_legitimacy_compliance_logit_model.csv"))
write_csv(tidy(legitimacy_trust_fit, conf.int = TRUE), file.path(output_dir, "authority_legitimacy_trust_interaction.csv"))
write_csv(tidy(accountability_repair_fit, conf.int = TRUE), file.path(output_dir, "authority_legitimacy_accountability_repair_interaction.csv"))
write_csv(tidy(clarity_authority_fit, conf.int = TRUE), file.path(output_dir, "authority_legitimacy_clarity_authority_interaction.csv"))
write_csv(fragile_cases, file.path(output_dir, "authority_legitimacy_fragile_cases.csv"))
write_csv(high_arbitrariness_cases, file.path(output_dir, "authority_legitimacy_high_arbitrariness_cases.csv"))

print(summary_table)
print(summary(gam_fit))
