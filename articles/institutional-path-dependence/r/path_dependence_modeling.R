# Institutional Path Dependence and Lock-In in R
#
# Purpose:
# Build a synthetic dataset for modeling institutional path dependence.
# Estimate lock-in probability, interaction effects, high-burden lock-in,
# and nonlinear threshold behavior.
#
# Recommended install:
# pak::pak(c("tidyverse", "broom", "scales", "mgcv"))

suppressPackageStartupMessages({
  library(tidyverse)
  library(broom)
  library(scales)
  library(mgcv)
})

set.seed(101)

article_dir <- normalizePath(file.path(dirname(sys.frame(1)$ofile %||% "."), ".."), mustWork = FALSE)
output_dir <- file.path(article_dir, "outputs", "tables")
dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)

n <- 600

path_data <- tibble(
  institution_id = 1:n,
  initial_conditions = runif(n, 20, 95),
  behavioral_reinforcement = runif(n, 15, 95),
  feedback_strength = runif(n, 20, 95),
  increasing_returns = runif(n, 10, 95),
  coordination_effects = runif(n, 15, 95),
  learning_effects = runif(n, 20, 95),
  legitimacy = runif(n, 20, 95),
  switching_costs = runif(n, 10, 100),
  complementarity = runif(n, 15, 95),
  disruption_pressure = runif(n, 5, 90),
  reform_capacity = runif(n, 5, 95),
  distributional_burden = runif(n, 5, 95)
) |>
  mutate(
    path_dependence_raw =
      0.08 * initial_conditions +
      0.12 * behavioral_reinforcement +
      0.12 * feedback_strength +
      0.13 * increasing_returns +
      0.11 * coordination_effects +
      0.10 * learning_effects +
      0.12 * legitimacy +
      0.12 * switching_costs +
      0.10 * complementarity -
      0.12 * disruption_pressure -
      0.05 * reform_capacity +
      rnorm(n, 0, 5),
    path_dependence_score = rescale(path_dependence_raw, to = c(0, 100)),
    lock_in = if_else(path_dependence_score >= 60, 1, 0),
    strong_lock_in = if_else(path_dependence_score >= 75, 1, 0),
    high_burden_lock_in = if_else(
      path_dependence_score >= 60 & distributional_burden >= 65,
      1,
      0
    )
  )

summary_table <- path_data |>
  summarise(
    mean_path_dependence = mean(path_dependence_score),
    lock_in_rate = mean(lock_in),
    strong_lock_in_rate = mean(strong_lock_in),
    high_burden_lock_in_rate = mean(high_burden_lock_in),
    mean_disruption_pressure = mean(disruption_pressure),
    mean_reform_capacity = mean(reform_capacity)
  )

path_lm <- lm(
  path_dependence_score ~ behavioral_reinforcement + feedback_strength +
    increasing_returns + coordination_effects + legitimacy +
    switching_costs + complementarity + disruption_pressure +
    reform_capacity + distributional_burden,
  data = path_data
)

lock_in_logit <- glm(
  lock_in ~ increasing_returns + legitimacy + switching_costs +
    coordination_effects + learning_effects + complementarity +
    disruption_pressure + reform_capacity,
  family = binomial(link = "logit"),
  data = path_data
)

legitimacy_switching_interaction <- lm(
  path_dependence_score ~ legitimacy * switching_costs +
    increasing_returns + coordination_effects + disruption_pressure +
    reform_capacity,
  data = path_data
)

path_gam <- gam(
  path_dependence_score ~
    s(increasing_returns) +
    s(coordination_effects) +
    s(legitimacy) +
    s(switching_costs) +
    s(disruption_pressure),
  data = path_data
)

top_lock_in_cases <- path_data |>
  arrange(desc(path_dependence_score)) |>
  select(
    institution_id,
    path_dependence_score,
    legitimacy,
    switching_costs,
    increasing_returns,
    coordination_effects,
    complementarity,
    disruption_pressure,
    reform_capacity,
    distributional_burden
  ) |>
  slice_head(n = 10)

high_burden_cases <- path_data |>
  filter(high_burden_lock_in == 1) |>
  arrange(desc(distributional_burden)) |>
  select(
    institution_id,
    path_dependence_score,
    distributional_burden,
    legitimacy,
    switching_costs,
    disruption_pressure,
    reform_capacity
  )

write_csv(path_data, file.path(output_dir, "institutional_path_dependence_r_synthetic_data.csv"))
write_csv(summary_table, file.path(output_dir, "institutional_path_dependence_r_summary.csv"))
write_csv(tidy(path_lm, conf.int = TRUE), file.path(output_dir, "path_dependence_linear_model.csv"))
write_csv(tidy(lock_in_logit, conf.int = TRUE, exponentiate = TRUE), file.path(output_dir, "path_dependence_logit_model.csv"))
write_csv(tidy(legitimacy_switching_interaction, conf.int = TRUE), file.path(output_dir, "path_dependence_interaction_model.csv"))
write_csv(top_lock_in_cases, file.path(output_dir, "path_dependence_top_lock_in_cases.csv"))
write_csv(high_burden_cases, file.path(output_dir, "path_dependence_high_burden_cases.csv"))

print(summary_table)
print(summary(path_gam))
