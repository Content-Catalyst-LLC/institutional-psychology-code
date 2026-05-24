# Institutional Change and Behavioral Adaptation in R
#
# Purpose:
# Build a synthetic dataset for modeling institutional change and adaptation.
# Estimate change intensity, successful adaptation probability, interaction
# effects, transition burden, and fragile adaptation cases.
#
# Recommended install:
# pak::pak(c("tidyverse", "broom", "scales", "mgcv"))

suppressPackageStartupMessages({
  library(tidyverse)
  library(broom)
  library(scales)
  library(mgcv)
})

set.seed(202)

article_dir <- normalizePath(file.path(dirname(sys.frame(1)$ofile %||% "."), ".."), mustWork = FALSE)
output_dir <- file.path(article_dir, "outputs", "tables")
dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)

n <- 600

adapt_data <- tibble(
  institution_id = 1:n,
  feedback_quality = runif(n, 15, 95),
  adaptive_capacity = runif(n, 20, 95),
  legitimacy = runif(n, 15, 95),
  incentive_alignment = runif(n, 10, 95),
  normative_support = runif(n, 10, 95),
  governance_capacity = runif(n, 15, 95),
  path_dependence = runif(n, 15, 95),
  behavioral_flexibility = runif(n, 10, 95),
  coordination_quality = runif(n, 10, 95),
  environmental_change = runif(n, 5, 95),
  distributional_attention = runif(n, 5, 95),
  transition_burden = runif(n, 5, 95)
) |>
  mutate(
    change_raw =
      0.13 * feedback_quality +
      0.14 * adaptive_capacity +
      0.10 * legitimacy +
      0.10 * incentive_alignment +
      0.09 * normative_support +
      0.12 * governance_capacity +
      0.10 * behavioral_flexibility +
      0.08 * coordination_quality +
      0.06 * environmental_change +
      0.05 * distributional_attention -
      0.12 * path_dependence -
      0.05 * transition_burden +
      rnorm(n, 0, 6),
    change_score = rescale(change_raw, to = c(0, 100)),
    successful_adaptation = if_else(change_score >= 58, 1, 0),
    high_transition_burden = if_else(transition_burden >= 65, 1, 0),
    fragile_adaptation = if_else(
      successful_adaptation == 1 & legitimacy < 45,
      1,
      0
    )
  )

summary_table <- adapt_data |>
  summarise(
    mean_change_score = mean(change_score),
    successful_adaptation_rate = mean(successful_adaptation),
    fragile_adaptation_rate = mean(fragile_adaptation),
    mean_feedback_quality = mean(feedback_quality),
    mean_governance_capacity = mean(governance_capacity),
    mean_path_dependence = mean(path_dependence),
    mean_transition_burden = mean(transition_burden)
  )

change_lm <- lm(
  change_score ~ feedback_quality + adaptive_capacity + legitimacy +
    incentive_alignment + governance_capacity + path_dependence +
    behavioral_flexibility + environmental_change +
    distributional_attention + transition_burden,
  data = adapt_data
)

adaptation_logit <- glm(
  successful_adaptation ~ feedback_quality + adaptive_capacity + legitimacy +
    governance_capacity + path_dependence + coordination_quality +
    distributional_attention + transition_burden,
  family = binomial(link = "logit"),
  data = adapt_data
)

feedback_governance_interaction <- lm(
  change_score ~ feedback_quality * governance_capacity +
    adaptive_capacity + legitimacy + path_dependence +
    transition_burden,
  data = adapt_data
)

change_gam <- gam(
  change_score ~
    s(feedback_quality) +
    s(adaptive_capacity) +
    s(legitimacy) +
    s(path_dependence) +
    s(environmental_change),
  data = adapt_data
)

stress_cases <- adapt_data |>
  filter(
    environmental_change > 75,
    adaptive_capacity < 40,
    legitimacy < 45
  ) |>
  arrange(desc(environmental_change)) |>
  select(
    institution_id,
    environmental_change,
    adaptive_capacity,
    legitimacy,
    path_dependence,
    governance_capacity,
    change_score,
    successful_adaptation
  )

fragile_cases <- adapt_data |>
  filter(fragile_adaptation == 1) |>
  arrange(legitimacy) |>
  select(
    institution_id,
    change_score,
    legitimacy,
    governance_capacity,
    coordination_quality,
    transition_burden,
    distributional_attention
  )

write_csv(adapt_data, file.path(output_dir, "institutional_change_adaptation_r_synthetic_data.csv"))
write_csv(summary_table, file.path(output_dir, "institutional_change_adaptation_r_summary.csv"))
write_csv(tidy(change_lm, conf.int = TRUE), file.path(output_dir, "institutional_change_linear_model.csv"))
write_csv(tidy(adaptation_logit, conf.int = TRUE, exponentiate = TRUE), file.path(output_dir, "institutional_change_logit_model.csv"))
write_csv(tidy(feedback_governance_interaction, conf.int = TRUE), file.path(output_dir, "institutional_change_feedback_governance_interaction.csv"))
write_csv(stress_cases, file.path(output_dir, "institutional_change_stress_cases.csv"))
write_csv(fragile_cases, file.path(output_dir, "institutional_change_fragile_adaptation_cases.csv"))

print(summary_table)
print(summary(change_gam))
