# Crisis, Reform, and Institutional Transformation in R
#
# Purpose:
# Build a synthetic dataset for modeling crisis-driven institutional reform.
# Estimate transformation depth, reform probability, capture risk, and
# distributional attention effects.
#
# Recommended install:
# pak::pak(c("tidyverse", "broom", "scales", "mgcv"))

suppressPackageStartupMessages({
  library(tidyverse)
  library(broom)
  library(scales)
  library(mgcv)
})

set.seed(123)

article_dir <- normalizePath(file.path(dirname(sys.frame(1)$ofile %||% "."), ".."), mustWork = FALSE)
output_dir <- file.path(article_dir, "outputs", "tables")
dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)

n <- 600

institutional_crisis <- tibble(
  case_id = 1:n,
  crisis_severity = runif(n, 20, 100),
  feedback_breakdown = runif(n, 15, 100),
  legitimacy_failure = runif(n, 10, 100),
  adaptive_capacity = runif(n, 20, 95),
  reform_window = runif(n, 10, 95),
  coalition_strength = runif(n, 5, 95),
  coordination_quality = runif(n, 10, 95),
  learning_rate = runif(n, 15, 90),
  governance_alignment = runif(n, 10, 95),
  power_concentration = runif(n, 5, 95),
  capture_risk = runif(n, 5, 90),
  distributional_attention = runif(n, 5, 95)
) |>
  mutate(
    transformation_raw =
      0.15 * crisis_severity +
      0.11 * feedback_breakdown +
      0.14 * legitimacy_failure +
      0.10 * adaptive_capacity +
      0.12 * reform_window +
      0.12 * coalition_strength +
      0.08 * coordination_quality +
      0.06 * learning_rate +
      0.06 * governance_alignment +
      0.05 * distributional_attention -
      0.07 * capture_risk -
      0.04 * abs(power_concentration - 50) +
      rnorm(n, 0, 6),
    transformation_score = rescale(transformation_raw, to = c(0, 100)),
    major_reform = if_else(transformation_score >= 60, 1, 0),
    deep_transformation = if_else(transformation_score >= 75, 1, 0),
    high_capture_risk = if_else(capture_risk >= 65, 1, 0),
    low_distributional_attention = if_else(distributional_attention < 35, 1, 0)
  )

summary_table <- institutional_crisis |>
  summarise(
    mean_crisis_severity = mean(crisis_severity),
    mean_legitimacy_failure = mean(legitimacy_failure),
    mean_transformation_score = mean(transformation_score),
    major_reform_rate = mean(major_reform),
    deep_transformation_rate = mean(deep_transformation),
    high_capture_risk_rate = mean(high_capture_risk),
    low_distributional_attention_rate = mean(low_distributional_attention)
  )

transformation_lm <- lm(
  transformation_score ~ crisis_severity + feedback_breakdown +
    legitimacy_failure + adaptive_capacity + reform_window +
    coalition_strength + coordination_quality + governance_alignment +
    capture_risk + distributional_attention,
  data = institutional_crisis
)

major_reform_logit <- glm(
  major_reform ~ crisis_severity + legitimacy_failure + reform_window +
    coalition_strength + adaptive_capacity + coordination_quality +
    governance_alignment + capture_risk + distributional_attention,
  family = binomial(link = "logit"),
  data = institutional_crisis
)

legitimacy_coalition_interaction <- lm(
  transformation_score ~ legitimacy_failure * coalition_strength +
    crisis_severity + reform_window + adaptive_capacity + capture_risk,
  data = institutional_crisis
)

transformation_gam <- gam(
  transformation_score ~
    s(crisis_severity) +
    s(legitimacy_failure) +
    s(reform_window) +
    s(coalition_strength) +
    s(capture_risk),
  data = institutional_crisis
)

vulnerable_cases <- institutional_crisis |>
  filter(
    crisis_severity > 75,
    legitimacy_failure > 70,
    adaptive_capacity < 45
  ) |>
  arrange(desc(crisis_severity)) |>
  select(
    case_id,
    crisis_severity,
    legitimacy_failure,
    adaptive_capacity,
    reform_window,
    coalition_strength,
    capture_risk,
    distributional_attention,
    transformation_score
  )

promising_reform_cases <- institutional_crisis |>
  filter(
    transformation_score >= 75,
    capture_risk < 40,
    distributional_attention >= 60
  ) |>
  arrange(desc(transformation_score)) |>
  select(
    case_id,
    transformation_score,
    crisis_severity,
    legitimacy_failure,
    reform_window,
    coalition_strength,
    governance_alignment,
    distributional_attention,
    capture_risk
  )

write_csv(institutional_crisis, file.path(output_dir, "crisis_reform_r_synthetic_data.csv"))
write_csv(summary_table, file.path(output_dir, "crisis_reform_r_summary.csv"))
write_csv(tidy(transformation_lm, conf.int = TRUE), file.path(output_dir, "crisis_reform_linear_model.csv"))
write_csv(tidy(major_reform_logit, conf.int = TRUE, exponentiate = TRUE), file.path(output_dir, "crisis_reform_logit_model.csv"))
write_csv(tidy(legitimacy_coalition_interaction, conf.int = TRUE), file.path(output_dir, "crisis_reform_interaction_model.csv"))
write_csv(vulnerable_cases, file.path(output_dir, "crisis_reform_vulnerable_cases.csv"))
write_csv(promising_reform_cases, file.path(output_dir, "crisis_reform_promising_cases.csv"))

print(summary_table)
print(summary(transformation_gam))
