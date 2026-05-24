# Decision-Making in Institutional Systems in R
#
# Purpose:
# Build a synthetic dataset for modeling decision quality in institutional
# systems. Estimate the role of bounded-rationality pressure, organizational
# structure, incentive alignment, information flow, legitimacy, uncertainty
# management, corrective capacity, justice-sensitive voice, memory, feedback,
# bias distortion, and power-protective pressure.
#
# Recommended install:
# pak::pak(c("tidyverse", "broom", "scales", "mgcv"))

suppressPackageStartupMessages({
  library(tidyverse)
  library(broom)
  library(scales)
  library(mgcv)
})

set.seed(1616)

article_dir <- normalizePath(file.path(".."), mustWork = FALSE)
output_dir <- file.path(article_dir, "outputs", "tables")
dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)

n <- 700

decision_data <- tibble(
  unit_id = 1:n,
  bounded_rationality_pressure = runif(n, 5, 95),
  organizational_structure_quality = runif(n, 10, 95),
  incentive_alignment = runif(n, 10, 95),
  information_flow_effectiveness = runif(n, 10, 95),
  legitimacy = runif(n, 10, 95),
  uncertainty_management = runif(n, 10, 95),
  corrective_capacity = runif(n, 10, 95),
  justice_voice = runif(n, 10, 95),
  memory_quality = runif(n, 10, 95),
  feedback_openness = runif(n, 10, 95),
  bias_distortion = runif(n, 5, 95),
  power_protection = runif(n, 5, 95),
  metric_fixation = runif(n, 5, 95),
  siloing = runif(n, 5, 95),
  premature_closure = runif(n, 5, 95)
) |>
  mutate(
    decision_quality_raw =
      0.12 * organizational_structure_quality +
      0.12 * incentive_alignment +
      0.13 * information_flow_effectiveness +
      0.11 * legitimacy +
      0.11 * uncertainty_management +
      0.13 * corrective_capacity +
      0.09 * justice_voice +
      0.08 * memory_quality +
      0.08 * feedback_openness -
      0.13 * bounded_rationality_pressure -
      0.11 * bias_distortion -
      0.09 * power_protection -
      0.08 * metric_fixation -
      0.07 * siloing -
      0.07 * premature_closure +
      rnorm(n, 0, 6),
    decision_quality = rescale(decision_quality_raw, to = c(0, 100)),
    high_quality_decision = if_else(decision_quality >= 60, 1, 0),
    fragile_decision_environment = if_else(
      high_quality_decision == 1 &
        corrective_capacity < 40 &
        information_flow_effectiveness < 45,
      1,
      0
    ),
    high_distortion_environment = if_else(
      bias_distortion > 70 &
        power_protection > 65 &
        feedback_openness < 40,
      1,
      0
    )
  )

summary_table <- decision_data |>
  summarise(
    mean_decision_quality = mean(decision_quality),
    high_quality_decision_rate = mean(high_quality_decision),
    fragile_decision_environment_rate = mean(fragile_decision_environment),
    high_distortion_environment_rate = mean(high_distortion_environment),
    mean_information_flow = mean(information_flow_effectiveness),
    mean_corrective_capacity = mean(corrective_capacity),
    mean_legitimacy = mean(legitimacy),
    mean_uncertainty_management = mean(uncertainty_management),
    mean_bounded_rationality_pressure = mean(bounded_rationality_pressure),
    mean_bias_distortion = mean(bias_distortion)
  )

lm_fit <- lm(
  decision_quality ~ bounded_rationality_pressure +
    organizational_structure_quality + incentive_alignment +
    information_flow_effectiveness + legitimacy +
    uncertainty_management + corrective_capacity + justice_voice +
    memory_quality + feedback_openness + bias_distortion +
    power_protection + metric_fixation + siloing + premature_closure,
  data = decision_data
)

logit_fit <- glm(
  high_quality_decision ~ organizational_structure_quality +
    incentive_alignment + information_flow_effectiveness +
    legitimacy + uncertainty_management + corrective_capacity +
    justice_voice + memory_quality + feedback_openness +
    bounded_rationality_pressure + bias_distortion + power_protection,
  family = binomial(link = "logit"),
  data = decision_data
)

info_correction_fit <- lm(
  decision_quality ~ information_flow_effectiveness * corrective_capacity +
    legitimacy + uncertainty_management + bounded_rationality_pressure +
    bias_distortion + power_protection,
  data = decision_data
)

uncertainty_correction_fit <- lm(
  decision_quality ~ uncertainty_management * corrective_capacity +
    information_flow_effectiveness + legitimacy + memory_quality +
    feedback_openness + bounded_rationality_pressure,
  data = decision_data
)

justice_legitimacy_fit <- lm(
  decision_quality ~ justice_voice * legitimacy +
    information_flow_effectiveness + corrective_capacity +
    uncertainty_management + bias_distortion + metric_fixation,
  data = decision_data
)

gam_fit <- gam(
  decision_quality ~
    s(bounded_rationality_pressure) +
    s(organizational_structure_quality) +
    s(incentive_alignment) +
    s(information_flow_effectiveness) +
    s(legitimacy) +
    s(uncertainty_management) +
    s(corrective_capacity) +
    s(justice_voice) +
    s(memory_quality) +
    s(feedback_openness) +
    s(bias_distortion) +
    s(power_protection),
  data = decision_data
)

fragile_cases <- decision_data |>
  filter(fragile_decision_environment == 1) |>
  arrange(corrective_capacity, information_flow_effectiveness) |>
  select(
    unit_id,
    decision_quality,
    high_quality_decision,
    organizational_structure_quality,
    information_flow_effectiveness,
    legitimacy,
    uncertainty_management,
    corrective_capacity,
    feedback_openness,
    bounded_rationality_pressure,
    bias_distortion,
    power_protection
  )

high_distortion_cases <- decision_data |>
  filter(high_distortion_environment == 1) |>
  arrange(desc(bias_distortion), desc(power_protection)) |>
  select(
    unit_id,
    decision_quality,
    bias_distortion,
    power_protection,
    feedback_openness,
    metric_fixation,
    siloing,
    premature_closure,
    justice_voice,
    legitimacy
  )

write_csv(decision_data, file.path(output_dir, "decision_making_r_synthetic_data.csv"))
write_csv(summary_table, file.path(output_dir, "decision_making_r_summary.csv"))
write_csv(tidy(lm_fit, conf.int = TRUE), file.path(output_dir, "decision_making_linear_model.csv"))
write_csv(tidy(logit_fit, conf.int = TRUE, exponentiate = TRUE), file.path(output_dir, "decision_making_logit_model.csv"))
write_csv(tidy(info_correction_fit, conf.int = TRUE), file.path(output_dir, "decision_making_info_correction_interaction.csv"))
write_csv(tidy(uncertainty_correction_fit, conf.int = TRUE), file.path(output_dir, "decision_making_uncertainty_correction_interaction.csv"))
write_csv(tidy(justice_legitimacy_fit, conf.int = TRUE), file.path(output_dir, "decision_making_justice_legitimacy_interaction.csv"))
write_csv(fragile_cases, file.path(output_dir, "decision_making_fragile_cases.csv"))
write_csv(high_distortion_cases, file.path(output_dir, "decision_making_high_distortion_cases.csv"))

print(summary_table)
print(summary(gam_fit))
