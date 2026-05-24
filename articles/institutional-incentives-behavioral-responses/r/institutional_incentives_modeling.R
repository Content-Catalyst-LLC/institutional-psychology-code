# Institutional Incentives and Behavioral Responses in R
#
# Purpose:
# Build a synthetic dataset for modeling incentive effectiveness.
# Estimate incentive alignment, high-alignment probability,
# fairness-legitimacy interaction effects, information-learning effects,
# fragile incentive environments, and high-burden incentive risks.
#
# Recommended install:
# pak::pak(c("tidyverse", "broom", "scales", "mgcv"))

suppressPackageStartupMessages({
  library(tidyverse)
  library(broom)
  library(scales)
  library(mgcv)
})

set.seed(1111)

article_dir <- normalizePath(file.path(".."), mustWork = FALSE)
output_dir <- file.path(article_dir, "outputs", "tables")
dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)

n <- 650

inc_data <- tibble(
  unit_id = 1:n,
  value_alignment = runif(n, 10, 95),
  fairness = runif(n, 10, 95),
  information_quality = runif(n, 10, 95),
  legitimacy = runif(n, 10, 95),
  learning_support = runif(n, 10, 95),
  accountability = runif(n, 10, 95),
  bias_pressure = runif(n, 5, 95),
  metric_substitution = runif(n, 5, 95),
  reporting_distortion = runif(n, 5, 95),
  behavioral_burden = runif(n, 5, 95),
  short_termism = runif(n, 5, 95),
  status_inequality = runif(n, 5, 95),
  motivation_crowding = runif(n, 5, 95)
) |>
  mutate(
    incentive_raw =
      0.14 * value_alignment +
      0.12 * fairness +
      0.13 * information_quality +
      0.12 * legitimacy +
      0.12 * learning_support +
      0.10 * accountability -
      0.10 * bias_pressure -
      0.12 * metric_substitution -
      0.09 * reporting_distortion -
      0.08 * behavioral_burden -
      0.07 * short_termism -
      0.06 * status_inequality -
      0.05 * motivation_crowding +
      rnorm(n, 0, 6),
    incentive_effectiveness = rescale(incentive_raw, to = c(0, 100)),
    high_alignment = if_else(incentive_effectiveness >= 60, 1, 0),
    fragile_incentive_system = if_else(
      high_alignment == 1 & legitimacy < 40,
      1,
      0
    ),
    high_burden_incentive_system = if_else(
      high_alignment == 1 &
        behavioral_burden > 65 &
        metric_substitution > 65,
      1,
      0
    )
  )

summary_table <- inc_data |>
  summarise(
    mean_incentive_effectiveness = mean(incentive_effectiveness),
    high_alignment_rate = mean(high_alignment),
    fragile_incentive_system_rate = mean(fragile_incentive_system),
    high_burden_incentive_system_rate = mean(high_burden_incentive_system),
    mean_value_alignment = mean(value_alignment),
    mean_fairness = mean(fairness),
    mean_information_quality = mean(information_quality),
    mean_legitimacy = mean(legitimacy),
    mean_metric_substitution = mean(metric_substitution),
    mean_behavioral_burden = mean(behavioral_burden)
  )

lm_fit <- lm(
  incentive_effectiveness ~ value_alignment + fairness + information_quality +
    legitimacy + learning_support + accountability + bias_pressure +
    metric_substitution + reporting_distortion + behavioral_burden +
    short_termism + status_inequality + motivation_crowding,
  data = inc_data
)

logit_fit <- glm(
  high_alignment ~ value_alignment + fairness + legitimacy +
    information_quality + learning_support + accountability +
    metric_substitution + reporting_distortion + behavioral_burden,
  family = binomial(link = "logit"),
  data = inc_data
)

fairness_legitimacy_fit <- lm(
  incentive_effectiveness ~ fairness * legitimacy +
    value_alignment + information_quality + learning_support +
    metric_substitution + reporting_distortion,
  data = inc_data
)

information_learning_fit <- lm(
  incentive_effectiveness ~ information_quality * learning_support +
    value_alignment + fairness + legitimacy +
    metric_substitution + behavioral_burden,
  data = inc_data
)

gam_fit <- gam(
  incentive_effectiveness ~
    s(value_alignment) +
    s(fairness) +
    s(information_quality) +
    s(legitimacy) +
    s(learning_support) +
    s(metric_substitution) +
    s(reporting_distortion) +
    s(behavioral_burden),
  data = inc_data
)

fragile_cases <- inc_data |>
  filter(fragile_incentive_system == 1) |>
  arrange(legitimacy) |>
  select(
    unit_id,
    incentive_effectiveness,
    high_alignment,
    legitimacy,
    fairness,
    value_alignment,
    information_quality,
    metric_substitution,
    reporting_distortion,
    behavioral_burden
  )

high_burden_cases <- inc_data |>
  filter(high_burden_incentive_system == 1) |>
  arrange(desc(behavioral_burden)) |>
  select(
    unit_id,
    incentive_effectiveness,
    behavioral_burden,
    metric_substitution,
    legitimacy,
    fairness,
    accountability,
    reporting_distortion,
    motivation_crowding
  )

write_csv(inc_data, file.path(output_dir, "institutional_incentives_r_synthetic_data.csv"))
write_csv(summary_table, file.path(output_dir, "institutional_incentives_r_summary.csv"))
write_csv(tidy(lm_fit, conf.int = TRUE), file.path(output_dir, "institutional_incentives_linear_model.csv"))
write_csv(tidy(logit_fit, conf.int = TRUE, exponentiate = TRUE), file.path(output_dir, "institutional_incentives_logit_model.csv"))
write_csv(tidy(fairness_legitimacy_fit, conf.int = TRUE), file.path(output_dir, "institutional_incentives_fairness_legitimacy_interaction.csv"))
write_csv(tidy(information_learning_fit, conf.int = TRUE), file.path(output_dir, "institutional_incentives_information_learning_interaction.csv"))
write_csv(fragile_cases, file.path(output_dir, "institutional_incentives_fragile_cases.csv"))
write_csv(high_burden_cases, file.path(output_dir, "institutional_incentives_high_burden_cases.csv"))

print(summary_table)
print(summary(gam_fit))
