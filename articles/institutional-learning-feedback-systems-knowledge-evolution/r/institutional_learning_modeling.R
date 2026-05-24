# Institutional Learning: Feedback Systems and Knowledge Evolution in R
#
# Purpose:
# Build a synthetic dataset for modeling institutional learning capacity.
# Estimate learning capacity, high-adaptation probability, feedback-openness
# interaction effects, safety-disconfirmation effects, fragile learning
# environments, and high-inertia learning risks.
#
# Recommended install:
# pak::pak(c("tidyverse", "broom", "scales", "mgcv"))

suppressPackageStartupMessages({
  library(tidyverse)
  library(broom)
  library(scales)
  library(mgcv)
})

set.seed(1212)

article_dir <- normalizePath(file.path(".."), mustWork = FALSE)
output_dir <- file.path(article_dir, "outputs", "tables")
dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)

n <- 650

learn_data <- tibble(
  unit_id = 1:n,
  feedback_quality = runif(n, 10, 95),
  memory_retention = runif(n, 10, 95),
  communication_openness = runif(n, 10, 95),
  interpretive_quality = runif(n, 10, 95),
  decision_revisability = runif(n, 10, 95),
  psychological_safety = runif(n, 10, 95),
  accountability_reach = runif(n, 10, 95),
  disconfirming_evidence = runif(n, 5, 95),
  institutional_inertia = runif(n, 5, 95),
  signal_distortion = runif(n, 5, 95),
  memory_decay = runif(n, 5, 95),
  defensive_routines = runif(n, 5, 95),
  power_protection = runif(n, 5, 95),
  feedback_delay = runif(n, 5, 95)
) |>
  mutate(
    learning_raw =
      0.13 * feedback_quality +
      0.12 * memory_retention +
      0.12 * communication_openness +
      0.12 * interpretive_quality +
      0.12 * decision_revisability +
      0.12 * psychological_safety +
      0.10 * accountability_reach +
      0.06 * disconfirming_evidence -
      0.12 * institutional_inertia -
      0.10 * signal_distortion -
      0.08 * memory_decay -
      0.08 * defensive_routines -
      0.08 * power_protection -
      0.07 * feedback_delay +
      rnorm(n, 0, 6),
    learning_capacity = rescale(learning_raw, to = c(0, 100)),
    high_adaptation = if_else(learning_capacity >= 60, 1, 0),
    fragile_learning = if_else(
      high_adaptation == 1 & communication_openness < 40,
      1,
      0
    ),
    high_inertia_learning = if_else(
      high_adaptation == 1 &
        institutional_inertia > 65 &
        signal_distortion > 65,
      1,
      0
    )
  )

summary_table <- learn_data |>
  summarise(
    mean_learning_capacity = mean(learning_capacity),
    high_adaptation_rate = mean(high_adaptation),
    fragile_learning_rate = mean(fragile_learning),
    high_inertia_learning_rate = mean(high_inertia_learning),
    mean_feedback_quality = mean(feedback_quality),
    mean_memory_retention = mean(memory_retention),
    mean_communication_openness = mean(communication_openness),
    mean_decision_revisability = mean(decision_revisability),
    mean_institutional_inertia = mean(institutional_inertia),
    mean_signal_distortion = mean(signal_distortion)
  )

lm_fit <- lm(
  learning_capacity ~ feedback_quality + memory_retention +
    communication_openness + interpretive_quality +
    decision_revisability + psychological_safety +
    accountability_reach + disconfirming_evidence +
    institutional_inertia + signal_distortion + memory_decay +
    defensive_routines + power_protection + feedback_delay,
  data = learn_data
)

logit_fit <- glm(
  high_adaptation ~ feedback_quality + memory_retention +
    communication_openness + decision_revisability +
    psychological_safety + accountability_reach +
    institutional_inertia + signal_distortion + power_protection,
  family = binomial(link = "logit"),
  data = learn_data
)

feedback_openness_fit <- lm(
  learning_capacity ~ feedback_quality * communication_openness +
    memory_retention + interpretive_quality +
    decision_revisability + psychological_safety +
    institutional_inertia + signal_distortion,
  data = learn_data
)

safety_disconfirmation_fit <- lm(
  learning_capacity ~ psychological_safety * disconfirming_evidence +
    feedback_quality + memory_retention + communication_openness +
    decision_revisability + institutional_inertia +
    defensive_routines + power_protection,
  data = learn_data
)

gam_fit <- gam(
  learning_capacity ~
    s(feedback_quality) +
    s(memory_retention) +
    s(communication_openness) +
    s(interpretive_quality) +
    s(decision_revisability) +
    s(psychological_safety) +
    s(institutional_inertia) +
    s(signal_distortion) +
    s(power_protection),
  data = learn_data
)

fragile_cases <- learn_data |>
  filter(fragile_learning == 1) |>
  arrange(communication_openness) |>
  select(
    unit_id,
    learning_capacity,
    high_adaptation,
    feedback_quality,
    communication_openness,
    psychological_safety,
    decision_revisability,
    institutional_inertia,
    signal_distortion,
    power_protection
  )

high_inertia_cases <- learn_data |>
  filter(high_inertia_learning == 1) |>
  arrange(desc(institutional_inertia)) |>
  select(
    unit_id,
    learning_capacity,
    institutional_inertia,
    signal_distortion,
    memory_decay,
    defensive_routines,
    power_protection,
    feedback_quality,
    decision_revisability
  )

write_csv(learn_data, file.path(output_dir, "institutional_learning_r_synthetic_data.csv"))
write_csv(summary_table, file.path(output_dir, "institutional_learning_r_summary.csv"))
write_csv(tidy(lm_fit, conf.int = TRUE), file.path(output_dir, "institutional_learning_linear_model.csv"))
write_csv(tidy(logit_fit, conf.int = TRUE, exponentiate = TRUE), file.path(output_dir, "institutional_learning_logit_model.csv"))
write_csv(tidy(feedback_openness_fit, conf.int = TRUE), file.path(output_dir, "institutional_learning_feedback_openness_interaction.csv"))
write_csv(tidy(safety_disconfirmation_fit, conf.int = TRUE), file.path(output_dir, "institutional_learning_safety_disconfirmation_interaction.csv"))
write_csv(fragile_cases, file.path(output_dir, "institutional_learning_fragile_cases.csv"))
write_csv(high_inertia_cases, file.path(output_dir, "institutional_learning_high_inertia_cases.csv"))

print(summary_table)
print(summary(gam_fit))
