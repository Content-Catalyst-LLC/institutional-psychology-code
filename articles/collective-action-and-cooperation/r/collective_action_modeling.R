# Collective Action and Cooperation in R
#
# Purpose:
# Build a synthetic dataset for modeling collective action capacity.
# Estimate cooperation scores, high-cooperation probability, interaction effects,
# fragile cooperation environments, and high-burden cooperation risks.
#
# Recommended install:
# pak::pak(c("tidyverse", "broom", "scales", "mgcv"))

suppressPackageStartupMessages({
  library(tidyverse)
  library(broom)
  library(scales)
  library(mgcv)
})

set.seed(606)

article_dir <- normalizePath(file.path(dirname(sys.frame(1)$ofile %||% "."), ".."), mustWork = FALSE)
output_dir <- file.path(article_dir, "outputs", "tables")
dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)

n <- 600

ca_data <- tibble(
  unit_id = 1:n,
  incentive_alignment = runif(n, 10, 95),
  trust = runif(n, 10, 95),
  legitimacy = runif(n, 10, 95),
  norm_strength = runif(n, 10, 95),
  enforcement_credibility = runif(n, 5, 95),
  communication_quality = runif(n, 10, 95),
  coordination_quality = runif(n, 10, 95),
  perceived_fairness = runif(n, 5, 95),
  free_riding_pressure = runif(n, 5, 95),
  burden_inequality = runif(n, 5, 95),
  hypocrisy_visibility = runif(n, 5, 95),
  scale_complexity = runif(n, 5, 95)
) |>
  mutate(
    cooperation_raw =
      0.12 * incentive_alignment +
      0.13 * trust +
      0.12 * legitimacy +
      0.11 * norm_strength +
      0.10 * enforcement_credibility +
      0.11 * communication_quality +
      0.11 * coordination_quality +
      0.10 * perceived_fairness -
      0.12 * free_riding_pressure -
      0.07 * burden_inequality -
      0.06 * hypocrisy_visibility -
      0.05 * scale_complexity +
      rnorm(n, 0, 6),
    cooperation_score = rescale(cooperation_raw, to = c(0, 100)),
    high_cooperation = if_else(cooperation_score >= 60, 1, 0),
    fragile_cooperation = if_else(
      high_cooperation == 1 & trust < 40,
      1,
      0
    ),
    high_burden_cooperation = if_else(
      high_cooperation == 1 &
        burden_inequality > 65 &
        perceived_fairness < 40,
      1,
      0
    )
  )

summary_table <- ca_data |>
  summarise(
    mean_cooperation_score = mean(cooperation_score),
    high_cooperation_rate = mean(high_cooperation),
    fragile_cooperation_rate = mean(fragile_cooperation),
    high_burden_cooperation_rate = mean(high_burden_cooperation),
    mean_trust = mean(trust),
    mean_legitimacy = mean(legitimacy),
    mean_free_riding_pressure = mean(free_riding_pressure),
    mean_burden_inequality = mean(burden_inequality)
  )

lm_fit <- lm(
  cooperation_score ~ incentive_alignment + trust + legitimacy +
    norm_strength + enforcement_credibility + communication_quality +
    coordination_quality + perceived_fairness + free_riding_pressure +
    burden_inequality + hypocrisy_visibility + scale_complexity,
  data = ca_data
)

logit_fit <- glm(
  high_cooperation ~ trust + legitimacy + norm_strength +
    enforcement_credibility + communication_quality +
    perceived_fairness + free_riding_pressure + burden_inequality,
  family = binomial(link = "logit"),
  data = ca_data
)

enforcement_legitimacy_fit <- lm(
  cooperation_score ~ enforcement_credibility * legitimacy +
    trust + norm_strength + free_riding_pressure + perceived_fairness,
  data = ca_data
)

trust_norm_fit <- lm(
  cooperation_score ~ trust * norm_strength +
    legitimacy + enforcement_credibility + communication_quality +
    free_riding_pressure + burden_inequality,
  data = ca_data
)

gam_fit <- gam(
  cooperation_score ~
    s(trust) +
    s(legitimacy) +
    s(norm_strength) +
    s(enforcement_credibility) +
    s(free_riding_pressure) +
    s(burden_inequality),
  data = ca_data
)

fragile_cases <- ca_data |>
  filter(fragile_cooperation == 1) |>
  arrange(trust) |>
  select(
    unit_id,
    cooperation_score,
    high_cooperation,
    trust,
    legitimacy,
    norm_strength,
    enforcement_credibility,
    free_riding_pressure,
    burden_inequality
  )

high_burden_cases <- ca_data |>
  filter(high_burden_cooperation == 1) |>
  arrange(desc(burden_inequality)) |>
  select(
    unit_id,
    cooperation_score,
    burden_inequality,
    perceived_fairness,
    trust,
    legitimacy,
    free_riding_pressure,
    hypocrisy_visibility
  )

write_csv(ca_data, file.path(output_dir, "collective_action_r_synthetic_data.csv"))
write_csv(summary_table, file.path(output_dir, "collective_action_r_summary.csv"))
write_csv(tidy(lm_fit, conf.int = TRUE), file.path(output_dir, "collective_action_linear_model.csv"))
write_csv(tidy(logit_fit, conf.int = TRUE, exponentiate = TRUE), file.path(output_dir, "collective_action_logit_model.csv"))
write_csv(tidy(enforcement_legitimacy_fit, conf.int = TRUE), file.path(output_dir, "collective_action_enforcement_legitimacy_interaction.csv"))
write_csv(tidy(trust_norm_fit, conf.int = TRUE), file.path(output_dir, "collective_action_trust_norm_interaction.csv"))
write_csv(fragile_cases, file.path(output_dir, "collective_action_fragile_cases.csv"))
write_csv(high_burden_cases, file.path(output_dir, "collective_action_high_burden_cases.csv"))

print(summary_table)
print(summary(gam_fit))
