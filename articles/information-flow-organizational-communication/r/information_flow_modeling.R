# Information Flow and Organizational Communication in R
#
# Purpose:
# Build a synthetic dataset for modeling institutional information-flow
# effectiveness. Estimate signal quality, communication quality,
# interpretive integration, feedback usability, memory retention,
# openness, distortion, overload, escalation, trust, and community voice.
#
# Recommended install:
# pak::pak(c("tidyverse", "broom", "scales", "mgcv"))

suppressPackageStartupMessages({
  library(tidyverse)
  library(broom)
  library(scales)
  library(mgcv)
})

set.seed(1414)

article_dir <- normalizePath(file.path(".."), mustWork = FALSE)
output_dir <- file.path(article_dir, "outputs", "tables")
dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)

n <- 650

info_data <- tibble(
  unit_id = 1:n,
  signal_quality = runif(n, 10, 95),
  communication_quality = runif(n, 10, 95),
  interpretive_integration = runif(n, 10, 95),
  feedback_usability = runif(n, 10, 95),
  memory_retention = runif(n, 10, 95),
  openness = runif(n, 10, 95),
  escalation_access = runif(n, 10, 95),
  trust = runif(n, 10, 95),
  community_voice = runif(n, 10, 95),
  digital_transparency = runif(n, 10, 95),
  distortion_loss = runif(n, 5, 95),
  overload = runif(n, 5, 95),
  siloing = runif(n, 5, 95),
  suppression_pressure = runif(n, 5, 95),
  metric_tunnel_vision = runif(n, 5, 95)
) |>
  mutate(
    information_raw =
      0.12 * signal_quality +
      0.12 * communication_quality +
      0.12 * interpretive_integration +
      0.11 * feedback_usability +
      0.10 * memory_retention +
      0.11 * openness +
      0.09 * escalation_access +
      0.08 * trust +
      0.07 * community_voice +
      0.07 * digital_transparency -
      0.12 * distortion_loss -
      0.09 * overload -
      0.08 * siloing -
      0.08 * suppression_pressure -
      0.07 * metric_tunnel_vision +
      rnorm(n, 0, 6),
    information_effectiveness = rescale(information_raw, to = c(0, 100)),
    high_integration = if_else(information_effectiveness >= 60, 1, 0),
    fragile_communication = if_else(
      high_integration == 1 &
        openness < 40 &
        distortion_loss > 65,
      1,
      0
    ),
    high_overload_system = if_else(
      high_integration == 1 &
        overload > 70 &
        metric_tunnel_vision > 65,
      1,
      0
    )
  )

summary_table <- info_data |>
  summarise(
    mean_information_effectiveness = mean(information_effectiveness),
    high_integration_rate = mean(high_integration),
    fragile_communication_rate = mean(fragile_communication),
    high_overload_system_rate = mean(high_overload_system),
    mean_signal_quality = mean(signal_quality),
    mean_communication_quality = mean(communication_quality),
    mean_interpretive_integration = mean(interpretive_integration),
    mean_openness = mean(openness),
    mean_distortion_loss = mean(distortion_loss),
    mean_overload = mean(overload)
  )

lm_fit <- lm(
  information_effectiveness ~ signal_quality + communication_quality +
    interpretive_integration + feedback_usability + memory_retention +
    openness + escalation_access + trust + community_voice +
    digital_transparency + distortion_loss + overload + siloing +
    suppression_pressure + metric_tunnel_vision,
  data = info_data
)

logit_fit <- glm(
  high_integration ~ signal_quality + communication_quality +
    interpretive_integration + openness + escalation_access +
    trust + community_voice + distortion_loss + overload +
    suppression_pressure,
  family = binomial(link = "logit"),
  data = info_data
)

signal_openness_fit <- lm(
  information_effectiveness ~ signal_quality * openness +
    feedback_usability + memory_retention + distortion_loss +
    overload + suppression_pressure,
  data = info_data
)

feedback_memory_fit <- lm(
  information_effectiveness ~ feedback_usability * memory_retention +
    signal_quality + communication_quality + interpretive_integration +
    openness + distortion_loss + siloing,
  data = info_data
)

gam_fit <- gam(
  information_effectiveness ~
    s(signal_quality) +
    s(communication_quality) +
    s(interpretive_integration) +
    s(feedback_usability) +
    s(memory_retention) +
    s(openness) +
    s(escalation_access) +
    s(distortion_loss) +
    s(overload) +
    s(suppression_pressure),
  data = info_data
)

fragile_cases <- info_data |>
  filter(fragile_communication == 1) |>
  arrange(openness, desc(distortion_loss)) |>
  select(
    unit_id,
    information_effectiveness,
    high_integration,
    signal_quality,
    communication_quality,
    openness,
    escalation_access,
    trust,
    distortion_loss,
    suppression_pressure
  )

high_overload_cases <- info_data |>
  filter(high_overload_system == 1) |>
  arrange(desc(overload)) |>
  select(
    unit_id,
    information_effectiveness,
    overload,
    metric_tunnel_vision,
    signal_quality,
    interpretive_integration,
    memory_retention,
    community_voice,
    digital_transparency
  )

write_csv(info_data, file.path(output_dir, "information_flow_r_synthetic_data.csv"))
write_csv(summary_table, file.path(output_dir, "information_flow_r_summary.csv"))
write_csv(tidy(lm_fit, conf.int = TRUE), file.path(output_dir, "information_flow_linear_model.csv"))
write_csv(tidy(logit_fit, conf.int = TRUE, exponentiate = TRUE), file.path(output_dir, "information_flow_logit_model.csv"))
write_csv(tidy(signal_openness_fit, conf.int = TRUE), file.path(output_dir, "information_flow_signal_openness_interaction.csv"))
write_csv(tidy(feedback_memory_fit, conf.int = TRUE), file.path(output_dir, "information_flow_feedback_memory_interaction.csv"))
write_csv(fragile_cases, file.path(output_dir, "information_flow_fragile_cases.csv"))
write_csv(high_overload_cases, file.path(output_dir, "information_flow_high_overload_cases.csv"))

print(summary_table)
print(summary(gam_fit))
