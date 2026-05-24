# Coordination Problems in Institutional Systems in R
#
# Purpose:
# Build a synthetic dataset for modeling institutional coordination quality.
# Estimate high-alignment probability, interaction effects, fragile coordination,
# and adaptation-burden risks.
#
# Recommended install:
# pak::pak(c("tidyverse", "broom", "scales", "mgcv"))

suppressPackageStartupMessages({
  library(tidyverse)
  library(broom)
  library(scales)
  library(mgcv)
})

set.seed(404)

article_dir <- normalizePath(file.path(dirname(sys.frame(1)$ofile %||% "."), ".."), mustWork = FALSE)
output_dir <- file.path(article_dir, "outputs", "tables")
dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)

n <- 600

coord_data <- tibble(
  unit_id = 1:n,
  trust = runif(n, 10, 95),
  information_quality = runif(n, 10, 95),
  communication_clarity = runif(n, 10, 95),
  focal_salience = runif(n, 5, 95),
  authority_signal = runif(n, 5, 95),
  norm_strength = runif(n, 10, 95),
  learning_capacity = runif(n, 10, 95),
  uncertainty = runif(n, 5, 95),
  adaptation_burden = runif(n, 5, 95),
  competing_standards = runif(n, 5, 95),
  competing_authority = runif(n, 5, 95),
  distributional_attention = runif(n, 5, 95)
) |>
  mutate(
    coordination_raw =
      0.14 * trust +
      0.14 * information_quality +
      0.13 * communication_clarity +
      0.12 * focal_salience +
      0.10 * authority_signal +
      0.10 * norm_strength +
      0.09 * learning_capacity -
      0.13 * uncertainty -
      0.07 * adaptation_burden -
      0.06 * competing_standards -
      0.05 * competing_authority +
      0.04 * distributional_attention +
      rnorm(n, 0, 6),
    coordination_quality = rescale(coordination_raw, to = c(0, 100)),
    high_alignment = if_else(coordination_quality >= 60, 1, 0),
    fragile_coordination = if_else(
      high_alignment == 1 & trust < 40,
      1,
      0
    ),
    high_burden_coordination = if_else(
      high_alignment == 1 &
        adaptation_burden > 65 &
        distributional_attention < 40,
      1,
      0
    )
  )

summary_table <- coord_data |>
  summarise(
    mean_coordination_quality = mean(coordination_quality),
    high_alignment_rate = mean(high_alignment),
    fragile_coordination_rate = mean(fragile_coordination),
    high_burden_coordination_rate = mean(high_burden_coordination),
    mean_trust = mean(trust),
    mean_communication_clarity = mean(communication_clarity),
    mean_uncertainty = mean(uncertainty),
    mean_adaptation_burden = mean(adaptation_burden)
  )

coord_lm <- lm(
  coordination_quality ~ trust + information_quality + communication_clarity +
    focal_salience + authority_signal + norm_strength +
    learning_capacity + uncertainty + adaptation_burden +
    competing_standards + competing_authority + distributional_attention,
  data = coord_data
)

align_logit <- glm(
  high_alignment ~ trust + communication_clarity + focal_salience +
    authority_signal + norm_strength + uncertainty + adaptation_burden +
    competing_standards,
  family = binomial(link = "logit"),
  data = coord_data
)

authority_trust_interaction <- lm(
  coordination_quality ~ authority_signal * trust +
    communication_clarity + focal_salience + uncertainty +
    adaptation_burden + competing_standards,
  data = coord_data
)

communication_uncertainty_interaction <- lm(
  coordination_quality ~ communication_clarity * uncertainty +
    trust + focal_salience + authority_signal + learning_capacity +
    adaptation_burden,
  data = coord_data
)

coord_gam <- gam(
  coordination_quality ~
    s(trust) +
    s(communication_clarity) +
    s(focal_salience) +
    s(authority_signal) +
    s(uncertainty) +
    s(adaptation_burden),
  data = coord_data
)

fragile_cases <- coord_data |>
  filter(fragile_coordination == 1) |>
  arrange(trust) |>
  select(
    unit_id,
    coordination_quality,
    high_alignment,
    trust,
    communication_clarity,
    focal_salience,
    authority_signal,
    uncertainty,
    adaptation_burden,
    competing_standards
  )

high_burden_cases <- coord_data |>
  filter(high_burden_coordination == 1) |>
  arrange(desc(adaptation_burden)) |>
  select(
    unit_id,
    coordination_quality,
    adaptation_burden,
    distributional_attention,
    authority_signal,
    focal_salience,
    competing_standards
  )

write_csv(coord_data, file.path(output_dir, "coordination_problems_r_synthetic_data.csv"))
write_csv(summary_table, file.path(output_dir, "coordination_problems_r_summary.csv"))
write_csv(tidy(coord_lm, conf.int = TRUE), file.path(output_dir, "coordination_quality_linear_model.csv"))
write_csv(tidy(align_logit, conf.int = TRUE, exponentiate = TRUE), file.path(output_dir, "coordination_high_alignment_logit_model.csv"))
write_csv(tidy(authority_trust_interaction, conf.int = TRUE), file.path(output_dir, "coordination_authority_trust_interaction.csv"))
write_csv(tidy(communication_uncertainty_interaction, conf.int = TRUE), file.path(output_dir, "coordination_communication_uncertainty_interaction.csv"))
write_csv(fragile_cases, file.path(output_dir, "coordination_fragile_cases.csv"))
write_csv(high_burden_cases, file.path(output_dir, "coordination_high_burden_cases.csv"))

print(summary_table)
print(summary(coord_gam))
