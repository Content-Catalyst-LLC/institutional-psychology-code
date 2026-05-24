# Cognitive Bias in Institutional Decision-Making in R
#
# Purpose:
# Build a synthetic dataset for modeling institutional bias pressure,
# filtering distortion, structured dissent, corrective review, and
# decision quality.
#
# Recommended install:
# pak::pak(c("tidyverse", "broom", "scales", "mgcv"))

suppressPackageStartupMessages({
  library(tidyverse)
  library(broom)
  library(scales)
  library(mgcv)
})

set.seed(1515)

article_dir <- normalizePath(file.path(".."), mustWork = FALSE)
output_dir <- file.path(article_dir, "outputs", "tables")
dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)

n <- 650

bias_data <- tibble(
  unit_id = 1:n,
  overconfidence = runif(n, 5, 95),
  anchoring_pressure = runif(n, 5, 95),
  confirmation_pressure = runif(n, 5, 95),
  conformity_pressure = runif(n, 5, 95),
  filtering_distortion = runif(n, 5, 95),
  path_lock_in = runif(n, 5, 95),
  metric_tunnel_vision = runif(n, 5, 95),
  power_protection = runif(n, 5, 95),
  dissent_capacity = runif(n, 10, 95),
  corrective_review = runif(n, 10, 95),
  information_quality = runif(n, 10, 95),
  feedback_openness = runif(n, 10, 95),
  psychological_safety = runif(n, 10, 95),
  justice_voice = runif(n, 10, 95)
) |>
  mutate(
    bias_pressure_raw =
      0.12 * overconfidence +
      0.11 * anchoring_pressure +
      0.11 * confirmation_pressure +
      0.11 * conformity_pressure +
      0.12 * filtering_distortion +
      0.10 * path_lock_in +
      0.09 * metric_tunnel_vision +
      0.08 * power_protection -
      0.12 * dissent_capacity -
      0.11 * corrective_review -
      0.11 * information_quality -
      0.10 * feedback_openness -
      0.08 * psychological_safety -
      0.07 * justice_voice +
      rnorm(n, 0, 6),
    institutional_bias_pressure = rescale(bias_pressure_raw, to = c(0, 100)),
    decision_quality_raw =
      0.14 * dissent_capacity +
      0.14 * corrective_review +
      0.14 * information_quality +
      0.13 * feedback_openness +
      0.11 * psychological_safety +
      0.10 * justice_voice -
      0.13 * overconfidence -
      0.13 * conformity_pressure -
      0.14 * filtering_distortion -
      0.12 * path_lock_in -
      0.10 * metric_tunnel_vision -
      0.09 * power_protection +
      rnorm(n, 0, 6),
    decision_quality = rescale(decision_quality_raw, to = c(0, 100)),
    high_resilience_decision = if_else(decision_quality >= 60, 1, 0),
    fragile_judgment = if_else(
      high_resilience_decision == 1 &
        dissent_capacity < 40 &
        filtering_distortion > 65,
      1,
      0
    ),
    high_bias_environment = if_else(
      institutional_bias_pressure >= 65 &
        corrective_review < 40 &
        feedback_openness < 40,
      1,
      0
    )
  )

summary_table <- bias_data |>
  summarise(
    mean_decision_quality = mean(decision_quality),
    mean_bias_pressure = mean(institutional_bias_pressure),
    high_resilience_decision_rate = mean(high_resilience_decision),
    fragile_judgment_rate = mean(fragile_judgment),
    high_bias_environment_rate = mean(high_bias_environment),
    mean_dissent_capacity = mean(dissent_capacity),
    mean_corrective_review = mean(corrective_review),
    mean_information_quality = mean(information_quality),
    mean_filtering_distortion = mean(filtering_distortion),
    mean_path_lock_in = mean(path_lock_in)
  )

lm_fit <- lm(
  decision_quality ~ overconfidence + anchoring_pressure +
    confirmation_pressure + conformity_pressure + filtering_distortion +
    path_lock_in + metric_tunnel_vision + power_protection +
    dissent_capacity + corrective_review + information_quality +
    feedback_openness + psychological_safety + justice_voice,
  data = bias_data
)

logit_fit <- glm(
  high_resilience_decision ~ dissent_capacity + corrective_review +
    information_quality + feedback_openness + psychological_safety +
    justice_voice + conformity_pressure + filtering_distortion +
    path_lock_in + metric_tunnel_vision,
  family = binomial(link = "logit"),
  data = bias_data
)

dissent_conformity_fit <- lm(
  decision_quality ~ dissent_capacity * conformity_pressure +
    corrective_review + information_quality + feedback_openness +
    filtering_distortion + path_lock_in,
  data = bias_data
)

feedback_distortion_fit <- lm(
  decision_quality ~ feedback_openness * filtering_distortion +
    dissent_capacity + corrective_review + information_quality +
    psychological_safety + power_protection,
  data = bias_data
)

justice_metric_fit <- lm(
  decision_quality ~ justice_voice * metric_tunnel_vision +
    information_quality + dissent_capacity + corrective_review +
    feedback_openness + path_lock_in,
  data = bias_data
)

gam_fit <- gam(
  decision_quality ~
    s(overconfidence) +
    s(conformity_pressure) +
    s(filtering_distortion) +
    s(path_lock_in) +
    s(metric_tunnel_vision) +
    s(dissent_capacity) +
    s(corrective_review) +
    s(information_quality) +
    s(feedback_openness),
  data = bias_data
)

fragile_cases <- bias_data |>
  filter(fragile_judgment == 1) |>
  arrange(dissent_capacity, desc(filtering_distortion)) |>
  select(
    unit_id,
    decision_quality,
    institutional_bias_pressure,
    dissent_capacity,
    corrective_review,
    information_quality,
    feedback_openness,
    filtering_distortion,
    conformity_pressure,
    path_lock_in,
    metric_tunnel_vision
  )

high_bias_cases <- bias_data |>
  filter(high_bias_environment == 1) |>
  arrange(desc(institutional_bias_pressure)) |>
  select(
    unit_id,
    institutional_bias_pressure,
    decision_quality,
    overconfidence,
    conformity_pressure,
    filtering_distortion,
    path_lock_in,
    corrective_review,
    feedback_openness,
    psychological_safety,
    justice_voice
  )

write_csv(bias_data, file.path(output_dir, "cognitive_bias_r_synthetic_data.csv"))
write_csv(summary_table, file.path(output_dir, "cognitive_bias_r_summary.csv"))
write_csv(tidy(lm_fit, conf.int = TRUE), file.path(output_dir, "cognitive_bias_linear_model.csv"))
write_csv(tidy(logit_fit, conf.int = TRUE, exponentiate = TRUE), file.path(output_dir, "cognitive_bias_logit_model.csv"))
write_csv(tidy(dissent_conformity_fit, conf.int = TRUE), file.path(output_dir, "cognitive_bias_dissent_conformity_interaction.csv"))
write_csv(tidy(feedback_distortion_fit, conf.int = TRUE), file.path(output_dir, "cognitive_bias_feedback_distortion_interaction.csv"))
write_csv(tidy(justice_metric_fit, conf.int = TRUE), file.path(output_dir, "cognitive_bias_justice_metric_interaction.csv"))
write_csv(fragile_cases, file.path(output_dir, "cognitive_bias_fragile_judgment_cases.csv"))
write_csv(high_bias_cases, file.path(output_dir, "cognitive_bias_high_bias_cases.csv"))

print(summary_table)
print(summary(gam_fit))
