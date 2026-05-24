# Institutional Trust and Social Stability in R
#
# Purpose:
# Build a synthetic dataset for modeling institutional trust, legitimacy,
# voluntary compliance, and social stability.
#
# Recommended install:
# pak::pak(c("tidyverse", "broom", "scales", "mgcv"))

suppressPackageStartupMessages({
  library(tidyverse)
  library(broom)
  library(scales)
  library(mgcv)
})

set.seed(1717)

article_dir <- normalizePath(file.path(".."), mustWork = FALSE)
output_dir <- file.path(article_dir, "outputs", "tables")
dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)

n <- 520

trust_data <- tibble(
  unit_id = 1:n,
  consistency = runif(n, 10, 95),
  competence = runif(n, 10, 95),
  fairness = runif(n, 10, 95),
  transparency = runif(n, 10, 95),
  accountability = runif(n, 10, 95),
  integrity = runif(n, 10, 95),
  recognition_voice = runif(n, 10, 95),
  repair_capacity = runif(n, 10, 95),
  legitimacy = runif(n, 10, 95),
  voluntary_compliance = runif(n, 10, 95),
  cooperation_capacity = runif(n, 10, 95),
  learning_repair = runif(n, 10, 95),
  arbitrariness_pressure = runif(n, 5, 95),
  visible_violation_pressure = runif(n, 5, 95),
  fragmentation_pressure = runif(n, 5, 95),
  administrative_burden = runif(n, 5, 95)
) |>
  mutate(
    trust_raw =
      0.11 * consistency +
      0.12 * competence +
      0.14 * fairness +
      0.10 * transparency +
      0.13 * accountability +
      0.12 * integrity +
      0.09 * recognition_voice +
      0.09 * repair_capacity -
      0.13 * arbitrariness_pressure -
      0.11 * visible_violation_pressure -
      0.08 * administrative_burden +
      rnorm(n, 0, 6),
    trust_score = rescale(trust_raw, to = c(0, 100)),
    stability_raw =
      0.18 * trust_score +
      0.14 * legitimacy +
      0.13 * voluntary_compliance +
      0.12 * cooperation_capacity +
      0.10 * learning_repair +
      0.08 * repair_capacity -
      0.12 * arbitrariness_pressure -
      0.10 * fragmentation_pressure -
      0.08 * visible_violation_pressure +
      rnorm(n, 0, 6),
    social_stability = rescale(stability_raw, to = c(0, 100)),
    high_trust = if_else(trust_score >= 60, 1, 0),
    high_stability = if_else(social_stability >= 60, 1, 0),
    fragile_trust_environment = if_else(
      trust_score >= 60 &
        fairness < 40 &
        accountability < 40,
      1,
      0
    ),
    high_distrust_pressure = if_else(
      arbitrariness_pressure > 70 &
        visible_violation_pressure > 65 &
        repair_capacity < 40,
      1,
      0
    )
  )

summary_table <- trust_data |>
  summarise(
    mean_trust_score = mean(trust_score),
    mean_social_stability = mean(social_stability),
    high_trust_rate = mean(high_trust),
    high_stability_rate = mean(high_stability),
    fragile_trust_environment_rate = mean(fragile_trust_environment),
    high_distrust_pressure_rate = mean(high_distrust_pressure),
    mean_fairness = mean(fairness),
    mean_accountability = mean(accountability),
    mean_repair_capacity = mean(repair_capacity),
    mean_arbitrariness_pressure = mean(arbitrariness_pressure)
  )

lm_fit <- lm(
  trust_score ~ consistency + competence + fairness +
    transparency + accountability + integrity +
    recognition_voice + repair_capacity +
    arbitrariness_pressure + visible_violation_pressure +
    administrative_burden,
  data = trust_data
)

logit_fit <- glm(
  high_stability ~ trust_score + legitimacy +
    voluntary_compliance + cooperation_capacity +
    learning_repair + repair_capacity +
    arbitrariness_pressure + fragmentation_pressure,
  family = binomial(link = "logit"),
  data = trust_data
)

fairness_accountability_fit <- lm(
  trust_score ~ fairness * accountability +
    competence + consistency + transparency +
    integrity + arbitrariness_pressure,
  data = trust_data
)

recognition_repair_fit <- lm(
  trust_score ~ recognition_voice * repair_capacity +
    fairness + accountability + integrity +
    visible_violation_pressure + administrative_burden,
  data = trust_data
)

gam_fit <- gam(
  trust_score ~
    s(consistency) +
    s(competence) +
    s(fairness) +
    s(transparency) +
    s(accountability) +
    s(integrity) +
    s(recognition_voice) +
    s(repair_capacity) +
    s(arbitrariness_pressure) +
    s(visible_violation_pressure),
  data = trust_data
)

fragile_cases <- trust_data |>
  filter(fragile_trust_environment == 1) |>
  arrange(fairness, accountability) |>
  select(
    unit_id,
    trust_score,
    social_stability,
    fairness,
    accountability,
    transparency,
    integrity,
    recognition_voice,
    repair_capacity,
    arbitrariness_pressure,
    visible_violation_pressure
  )

high_distrust_cases <- trust_data |>
  filter(high_distrust_pressure == 1) |>
  arrange(desc(arbitrariness_pressure), desc(visible_violation_pressure)) |>
  select(
    unit_id,
    trust_score,
    social_stability,
    arbitrariness_pressure,
    visible_violation_pressure,
    administrative_burden,
    repair_capacity,
    fairness,
    accountability,
    recognition_voice
  )

write_csv(trust_data, file.path(output_dir, "institutional_trust_r_synthetic_data.csv"))
write_csv(summary_table, file.path(output_dir, "institutional_trust_r_summary.csv"))
write_csv(tidy(lm_fit, conf.int = TRUE), file.path(output_dir, "institutional_trust_linear_model.csv"))
write_csv(tidy(logit_fit, conf.int = TRUE, exponentiate = TRUE), file.path(output_dir, "institutional_trust_stability_logit_model.csv"))
write_csv(tidy(fairness_accountability_fit, conf.int = TRUE), file.path(output_dir, "institutional_trust_fairness_accountability_interaction.csv"))
write_csv(tidy(recognition_repair_fit, conf.int = TRUE), file.path(output_dir, "institutional_trust_recognition_repair_interaction.csv"))
write_csv(fragile_cases, file.path(output_dir, "institutional_trust_fragile_cases.csv"))
write_csv(high_distrust_cases, file.path(output_dir, "institutional_trust_high_distrust_cases.csv"))

print(summary_table)
print(summary(gam_fit))
