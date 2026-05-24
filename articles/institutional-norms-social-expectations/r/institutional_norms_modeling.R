# Institutional Norms and Social Expectations in R
#
# Purpose:
# Build a synthetic dataset for modeling norm strength, expectation convergence,
# internalization, social enforcement, legitimacy alignment, trust reinforcement,
# suppressive pressure, fragmentation pressure, and high-coordination outcomes.
#
# Recommended install:
# pak::pak(c("tidyverse", "broom", "scales", "mgcv"))

suppressPackageStartupMessages({
  library(tidyverse)
  library(broom)
  library(scales)
  library(mgcv)
})

set.seed(1919)

article_dir <- normalizePath(file.path(".."), mustWork = FALSE)
output_dir <- file.path(article_dir, "outputs", "tables")
dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)

n <- 520

norm_data <- tibble(
  unit_id = 1:n,
  norm_repetition = runif(n, 10, 95),
  expectation_convergence = runif(n, 10, 95),
  internalization = runif(n, 10, 95),
  social_enforcement = runif(n, 10, 95),
  legitimacy_alignment = runif(n, 10, 95),
  trust_reinforcement = runif(n, 10, 95),
  role_clarity = runif(n, 10, 95),
  learning_capacity = runif(n, 10, 95),
  alternative_norm_visibility = runif(n, 5, 95),
  sanction_cost = runif(n, 5, 95),
  suppressive_pressure = runif(n, 5, 95),
  fragmentation_pressure = runif(n, 5, 95),
  unequal_normative_burden = runif(n, 5, 95),
  rigidity_pressure = runif(n, 5, 95)
) |>
  mutate(
    normative_stability_raw =
      0.13 * norm_repetition +
      0.14 * expectation_convergence +
      0.13 * internalization +
      0.11 * social_enforcement +
      0.13 * legitimacy_alignment +
      0.11 * trust_reinforcement +
      0.09 * role_clarity +
      0.08 * learning_capacity -
      0.13 * fragmentation_pressure -
      0.10 * unequal_normative_burden -
      0.08 * suppressive_pressure +
      rnorm(n, 0, 6),
    normative_stability = rescale(normative_stability_raw, to = c(0, 100)),
    high_coordination = if_else(normative_stability >= 60, 1, 0),
    fragile_normative_environment = if_else(
      normative_stability >= 60 &
        expectation_convergence < 40 &
        legitimacy_alignment < 40,
      1,
      0
    ),
    suppressive_norm_environment = if_else(
      social_enforcement > 70 &
        suppressive_pressure > 65 &
        learning_capacity < 40,
      1,
      0
    ),
    norm_change_readiness_raw =
      0.16 * alternative_norm_visibility +
      0.14 * learning_capacity +
      0.12 * legitimacy_alignment -
      0.15 * sanction_cost -
      0.12 * rigidity_pressure -
      0.10 * suppressive_pressure +
      rnorm(n, 0, 5),
    norm_change_readiness = rescale(norm_change_readiness_raw, to = c(0, 100))
  )

summary_table <- norm_data |>
  summarise(
    mean_normative_stability = mean(normative_stability),
    high_coordination_rate = mean(high_coordination),
    fragile_normative_environment_rate = mean(fragile_normative_environment),
    suppressive_norm_environment_rate = mean(suppressive_norm_environment),
    mean_expectation_convergence = mean(expectation_convergence),
    mean_legitimacy_alignment = mean(legitimacy_alignment),
    mean_internalization = mean(internalization),
    mean_fragmentation_pressure = mean(fragmentation_pressure),
    mean_norm_change_readiness = mean(norm_change_readiness)
  )

lm_fit <- lm(
  normative_stability ~ norm_repetition + expectation_convergence +
    internalization + social_enforcement + legitimacy_alignment +
    trust_reinforcement + role_clarity + learning_capacity +
    fragmentation_pressure + unequal_normative_burden +
    suppressive_pressure,
  data = norm_data
)

logit_fit <- glm(
  high_coordination ~ expectation_convergence + internalization +
    legitimacy_alignment + social_enforcement + trust_reinforcement +
    role_clarity + fragmentation_pressure + unequal_normative_burden,
  family = binomial(link = "logit"),
  data = norm_data
)

expectation_legitimacy_fit <- lm(
  normative_stability ~ expectation_convergence * legitimacy_alignment +
    internalization + social_enforcement + trust_reinforcement +
    fragmentation_pressure,
  data = norm_data
)

enforcement_suppression_fit <- lm(
  normative_stability ~ social_enforcement * suppressive_pressure +
    legitimacy_alignment + learning_capacity + trust_reinforcement +
    fragmentation_pressure,
  data = norm_data
)

change_fit <- lm(
  norm_change_readiness ~ alternative_norm_visibility +
    learning_capacity + legitimacy_alignment +
    sanction_cost + rigidity_pressure + suppressive_pressure,
  data = norm_data
)

gam_fit <- gam(
  normative_stability ~
    s(norm_repetition) +
    s(expectation_convergence) +
    s(internalization) +
    s(social_enforcement) +
    s(legitimacy_alignment) +
    s(trust_reinforcement) +
    s(fragmentation_pressure) +
    s(suppressive_pressure),
  data = norm_data
)

fragile_cases <- norm_data |>
  filter(fragile_normative_environment == 1) |>
  arrange(expectation_convergence, legitimacy_alignment) |>
  select(
    unit_id,
    normative_stability,
    high_coordination,
    expectation_convergence,
    legitimacy_alignment,
    internalization,
    social_enforcement,
    trust_reinforcement,
    fragmentation_pressure,
    unequal_normative_burden
  )

suppressive_cases <- norm_data |>
  filter(suppressive_norm_environment == 1) |>
  arrange(desc(social_enforcement), desc(suppressive_pressure)) |>
  select(
    unit_id,
    normative_stability,
    social_enforcement,
    suppressive_pressure,
    learning_capacity,
    legitimacy_alignment,
    trust_reinforcement,
    unequal_normative_burden,
    norm_change_readiness
  )

write_csv(norm_data, file.path(output_dir, "institutional_norms_r_synthetic_data.csv"))
write_csv(summary_table, file.path(output_dir, "institutional_norms_r_summary.csv"))
write_csv(tidy(lm_fit, conf.int = TRUE), file.path(output_dir, "institutional_norms_linear_model.csv"))
write_csv(tidy(logit_fit, conf.int = TRUE, exponentiate = TRUE), file.path(output_dir, "institutional_norms_high_coordination_logit_model.csv"))
write_csv(tidy(expectation_legitimacy_fit, conf.int = TRUE), file.path(output_dir, "institutional_norms_expectation_legitimacy_interaction.csv"))
write_csv(tidy(enforcement_suppression_fit, conf.int = TRUE), file.path(output_dir, "institutional_norms_enforcement_suppression_interaction.csv"))
write_csv(tidy(change_fit, conf.int = TRUE), file.path(output_dir, "institutional_norms_change_readiness_model.csv"))
write_csv(fragile_cases, file.path(output_dir, "institutional_norms_fragile_cases.csv"))
write_csv(suppressive_cases, file.path(output_dir, "institutional_norms_suppressive_cases.csv"))

print(summary_table)
print(summary(gam_fit))
