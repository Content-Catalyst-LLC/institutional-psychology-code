# Institutional Resilience Index in R
#
# This script builds a synthetic institutional resilience index and models
# institutional continuity under stress.
#
# Recommended install:
# pak::pak(c("tidyverse", "broom", "mgcv", "scales"))

suppressPackageStartupMessages({
  library(tidyverse)
  library(broom)
  library(mgcv)
  library(scales)
})

set.seed(42)

article_dir <- normalizePath(file.path(getwd()), mustWork = FALSE)
if (basename(article_dir) != "institutional-resilience") {
  article_dir <- normalizePath(file.path(dirname(sys.frame(1)$ofile %||% "."), ".."), mustWork = FALSE)
}

output_dir <- file.path(article_dir, "outputs", "tables")
dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)

n <- 500

institution_data <- tibble(
  institution_id = seq_len(n),
  robustness = runif(n, 40, 95),
  adaptive_capacity = runif(n, 30, 95),
  recovery_capacity = runif(n, 35, 95),
  transformational_capacity = runif(n, 20, 90),
  legitimacy = runif(n, 25, 95),
  trust = runif(n, 20, 95),
  feedback_quality = runif(n, 15, 95),
  learning_rate = runif(n, 20, 90),
  redundancy = runif(n, 10, 85),
  modularity = runif(n, 15, 90),
  coordination = runif(n, 20, 95),
  shock_intensity = runif(n, 10, 100)
) |>
  mutate(
    resilience_raw =
      0.10 * robustness +
      0.12 * adaptive_capacity +
      0.10 * recovery_capacity +
      0.08 * transformational_capacity +
      0.12 * legitimacy +
      0.10 * trust +
      0.10 * feedback_quality +
      0.08 * learning_rate +
      0.07 * redundancy +
      0.05 * modularity +
      0.08 * coordination -
      0.10 * shock_intensity,
    resilience_index = rescale(resilience_raw, to = c(0, 100)),
    continuity_score =
      0.35 * resilience_index +
      0.25 * legitimacy +
      0.20 * trust +
      0.20 * coordination -
      0.30 * shock_intensity +
      rnorm(n, 0, 7),
    continuity_score = pmax(pmin(continuity_score, 100), 0),
    maintained_core_function = if_else(continuity_score >= 55, 1, 0),
    failure_flag = if_else(continuity_score < 40, 1, 0)
  )

continuity_lm <- lm(
  continuity_score ~ resilience_index + legitimacy + trust +
    feedback_quality + adaptive_capacity + coordination + shock_intensity,
  data = institution_data
)

continuity_logit <- glm(
  maintained_core_function ~ legitimacy + trust + feedback_quality +
    redundancy + adaptive_capacity + coordination + shock_intensity,
  family = binomial(link = "logit"),
  data = institution_data
)

feedback_learning_model <- lm(
  continuity_score ~ feedback_quality * learning_rate + legitimacy +
    trust + coordination + shock_intensity,
  data = institution_data
)

summary_table <- institution_data |>
  summarise(
    mean_resilience = mean(resilience_index),
    mean_continuity = mean(continuity_score),
    mean_legitimacy = mean(legitimacy),
    mean_trust = mean(trust),
    failure_rate = mean(failure_flag),
    maintained_core_function_rate = mean(maintained_core_function)
  )

top_resilient_institutions <- institution_data |>
  arrange(desc(resilience_index)) |>
  select(
    institution_id,
    resilience_index,
    continuity_score,
    legitimacy,
    trust,
    shock_intensity
  ) |>
  slice_head(n = 10)

stress_test_data <- institution_data |>
  mutate(
    shock_intensity = pmin(shock_intensity + 20, 100),
    stressed_continuity = predict(continuity_lm, newdata = cur_data_all()),
    stressed_continuity = pmax(pmin(stressed_continuity, 100), 0)
  )

stress_summary <- stress_test_data |>
  summarise(
    mean_original_continuity = mean(institution_data$continuity_score),
    mean_stressed_continuity = mean(stressed_continuity),
    average_continuity_loss = mean_original_continuity - mean_stressed_continuity
  )

write_csv(institution_data, file.path(output_dir, "institutional_resilience_r_synthetic_data.csv"))
write_csv(summary_table, file.path(output_dir, "institutional_resilience_r_summary.csv"))
write_csv(top_resilient_institutions, file.path(output_dir, "institutional_resilience_r_top_10.csv"))
write_csv(stress_summary, file.path(output_dir, "institutional_resilience_r_stress_summary.csv"))
write_csv(tidy(continuity_lm, conf.int = TRUE), file.path(output_dir, "institutional_resilience_lm_coefficients.csv"))
write_csv(tidy(continuity_logit, conf.int = TRUE, exponentiate = TRUE), file.path(output_dir, "institutional_resilience_logit_odds_ratios.csv"))
write_csv(tidy(feedback_learning_model, conf.int = TRUE), file.path(output_dir, "institutional_resilience_feedback_learning_interaction.csv"))

print(summary_table)
print(stress_summary)
