# Institutions and Human Behavior in R
#
# Purpose:
# Build a synthetic dataset for modeling institutional strength,
# legitimacy, normative stability, behavioral alignment, trust,
# information quality, memory retention, learning capacity, and
# fragmentation pressure.
#
# Recommended install:
# pak::pak(c("tidyverse", "broom", "scales", "mgcv"))

suppressPackageStartupMessages({
  library(tidyverse)
  library(broom)
  library(scales)
  library(mgcv)
})

set.seed(2020)

article_dir <- normalizePath(file.path(".."), mustWork = FALSE)
output_dir <- file.path(article_dir, "outputs", "tables")
dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)

n <- 520

inst_data <- tibble(
  unit_id = 1:n,
  normative_stability = runif(n, 10, 95),
  legitimacy_strength = runif(n, 10, 95),
  incentive_alignment = runif(n, 10, 95),
  information_quality = runif(n, 10, 95),
  memory_retention = runif(n, 10, 95),
  learning_capacity = runif(n, 10, 95),
  trust_reinforcement = runif(n, 10, 95),
  role_clarity = runif(n, 10, 95),
  repair_capacity = runif(n, 10, 95),
  administrative_burden = runif(n, 5, 95),
  opacity_pressure = runif(n, 5, 95),
  historical_harm_pressure = runif(n, 5, 95),
  fragmentation_pressure = runif(n, 5, 95)
) |>
  mutate(
    institutional_strength_raw =
      0.13 * normative_stability +
      0.14 * legitimacy_strength +
      0.11 * incentive_alignment +
      0.12 * information_quality +
      0.11 * memory_retention +
      0.13 * learning_capacity +
      0.12 * trust_reinforcement +
      0.08 * role_clarity +
      0.08 * repair_capacity -
      0.12 * fragmentation_pressure -
      0.08 * opacity_pressure -
      0.08 * administrative_burden -
      0.07 * historical_harm_pressure +
      rnorm(n, 0, 6),
    institutional_strength = rescale(institutional_strength_raw, to = c(0, 100)),
    behavioral_alignment_raw =
      0.18 * institutional_strength +
      0.13 * legitimacy_strength +
      0.12 * normative_stability +
      0.12 * incentive_alignment +
      0.12 * trust_reinforcement +
      0.10 * role_clarity -
      0.11 * fragmentation_pressure -
      0.08 * opacity_pressure -
      0.08 * administrative_burden +
      rnorm(n, 0, 6),
    behavioral_alignment = rescale(behavioral_alignment_raw, to = c(0, 100)),
    high_institutional_alignment = if_else(institutional_strength >= 60, 1, 0),
    high_behavioral_alignment = if_else(behavioral_alignment >= 60, 1, 0),
    fragile_institutional_environment = if_else(
      institutional_strength >= 60 &
        legitimacy_strength < 40 &
        normative_stability < 40,
      1,
      0
    ),
    high_fragmentation_environment = if_else(
      fragmentation_pressure > 70 &
        opacity_pressure > 65 &
        repair_capacity < 40,
      1,
      0
    )
  )

summary_table <- inst_data |>
  summarise(
    mean_institutional_strength = mean(institutional_strength),
    mean_behavioral_alignment = mean(behavioral_alignment),
    high_institutional_alignment_rate = mean(high_institutional_alignment),
    high_behavioral_alignment_rate = mean(high_behavioral_alignment),
    fragile_institutional_environment_rate = mean(fragile_institutional_environment),
    high_fragmentation_environment_rate = mean(high_fragmentation_environment),
    mean_legitimacy_strength = mean(legitimacy_strength),
    mean_normative_stability = mean(normative_stability),
    mean_information_quality = mean(information_quality),
    mean_learning_capacity = mean(learning_capacity),
    mean_fragmentation_pressure = mean(fragmentation_pressure)
  )

lm_fit <- lm(
  institutional_strength ~ normative_stability + legitimacy_strength +
    incentive_alignment + information_quality + memory_retention +
    learning_capacity + trust_reinforcement + role_clarity +
    repair_capacity + administrative_burden + opacity_pressure +
    historical_harm_pressure + fragmentation_pressure,
  data = inst_data
)

logit_fit <- glm(
  high_behavioral_alignment ~ institutional_strength +
    normative_stability + legitimacy_strength + information_quality +
    learning_capacity + trust_reinforcement + role_clarity +
    fragmentation_pressure + opacity_pressure + administrative_burden,
  family = binomial(link = "logit"),
  data = inst_data
)

legitimacy_trust_fit <- lm(
  institutional_strength ~ legitimacy_strength * trust_reinforcement +
    normative_stability + information_quality + learning_capacity +
    fragmentation_pressure,
  data = inst_data
)

information_memory_fit <- lm(
  institutional_strength ~ information_quality * memory_retention +
    legitimacy_strength + normative_stability + learning_capacity +
    fragmentation_pressure,
  data = inst_data
)

learning_fragmentation_fit <- lm(
  institutional_strength ~ learning_capacity * fragmentation_pressure +
    legitimacy_strength + information_quality + trust_reinforcement +
    repair_capacity,
  data = inst_data
)

gam_fit <- gam(
  institutional_strength ~
    s(normative_stability) +
    s(legitimacy_strength) +
    s(incentive_alignment) +
    s(information_quality) +
    s(memory_retention) +
    s(learning_capacity) +
    s(trust_reinforcement) +
    s(fragmentation_pressure) +
    s(opacity_pressure),
  data = inst_data
)

fragile_cases <- inst_data |>
  filter(fragile_institutional_environment == 1) |>
  arrange(legitimacy_strength, normative_stability) |>
  select(
    unit_id,
    institutional_strength,
    behavioral_alignment,
    legitimacy_strength,
    normative_stability,
    information_quality,
    learning_capacity,
    trust_reinforcement,
    fragmentation_pressure,
    opacity_pressure,
    administrative_burden
  )

fragmentation_cases <- inst_data |>
  filter(high_fragmentation_environment == 1) |>
  arrange(desc(fragmentation_pressure), desc(opacity_pressure)) |>
  select(
    unit_id,
    institutional_strength,
    behavioral_alignment,
    fragmentation_pressure,
    opacity_pressure,
    administrative_burden,
    repair_capacity,
    legitimacy_strength,
    trust_reinforcement,
    learning_capacity
  )

write_csv(inst_data, file.path(output_dir, "institutions_human_behavior_r_synthetic_data.csv"))
write_csv(summary_table, file.path(output_dir, "institutions_human_behavior_r_summary.csv"))
write_csv(tidy(lm_fit, conf.int = TRUE), file.path(output_dir, "institutions_human_behavior_linear_model.csv"))
write_csv(tidy(logit_fit, conf.int = TRUE, exponentiate = TRUE), file.path(output_dir, "institutions_human_behavior_alignment_logit_model.csv"))
write_csv(tidy(legitimacy_trust_fit, conf.int = TRUE), file.path(output_dir, "institutions_human_behavior_legitimacy_trust_interaction.csv"))
write_csv(tidy(information_memory_fit, conf.int = TRUE), file.path(output_dir, "institutions_human_behavior_information_memory_interaction.csv"))
write_csv(tidy(learning_fragmentation_fit, conf.int = TRUE), file.path(output_dir, "institutions_human_behavior_learning_fragmentation_interaction.csv"))
write_csv(fragile_cases, file.path(output_dir, "institutions_human_behavior_fragile_cases.csv"))
write_csv(fragmentation_cases, file.path(output_dir, "institutions_human_behavior_fragmentation_cases.csv"))

print(summary_table)
print(summary(gam_fit))
