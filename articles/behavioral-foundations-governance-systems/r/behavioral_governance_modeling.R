# Behavioral Foundations of Governance Systems in R
#
# Purpose:
# Build a synthetic dataset for modeling behavioral governance performance.
# Estimate governance effectiveness, high-governance probability,
# interaction effects, fragile governance environments, and high-burden
# governance risks.
#
# Recommended install:
# pak::pak(c("tidyverse", "broom", "scales", "mgcv"))

suppressPackageStartupMessages({
  library(tidyverse)
  library(broom)
  library(scales)
  library(mgcv)
})

set.seed(707)

article_dir <- normalizePath(file.path(".."), mustWork = FALSE)
output_dir <- file.path(article_dir, "outputs", "tables")
dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)

n <- 650

gov_data <- tibble(
  unit_id = 1:n,
  incentive_alignment = runif(n, 10, 95),
  legitimacy = runif(n, 10, 95),
  norm_support = runif(n, 10, 95),
  cognitive_interpretability = runif(n, 10, 95),
  trust = runif(n, 10, 95),
  coordination_quality = runif(n, 10, 95),
  enforcement_credibility = runif(n, 5, 95),
  adaptive_learning = runif(n, 10, 95),
  perceived_fairness = runif(n, 5, 95),
  behavioral_burden = runif(n, 5, 95),
  hypocrisy_visibility = runif(n, 5, 95),
  power_asymmetry = runif(n, 5, 95)
) |>
  mutate(
    governance_raw =
      0.11 * incentive_alignment +
      0.13 * legitimacy +
      0.10 * norm_support +
      0.11 * cognitive_interpretability +
      0.12 * trust +
      0.11 * coordination_quality +
      0.10 * enforcement_credibility +
      0.11 * adaptive_learning +
      0.10 * perceived_fairness -
      0.10 * behavioral_burden -
      0.07 * hypocrisy_visibility -
      0.06 * power_asymmetry +
      rnorm(n, 0, 6),
    governance_effectiveness = rescale(governance_raw, to = c(0, 100)),
    high_governance = if_else(governance_effectiveness >= 60, 1, 0),
    fragile_governance = if_else(
      high_governance == 1 & trust < 40,
      1,
      0
    ),
    high_burden_governance = if_else(
      high_governance == 1 &
        behavioral_burden > 65 &
        perceived_fairness < 40,
      1,
      0
    )
  )

summary_table <- gov_data |>
  summarise(
    mean_governance_effectiveness = mean(governance_effectiveness),
    high_governance_rate = mean(high_governance),
    fragile_governance_rate = mean(fragile_governance),
    high_burden_governance_rate = mean(high_burden_governance),
    mean_legitimacy = mean(legitimacy),
    mean_trust = mean(trust),
    mean_behavioral_burden = mean(behavioral_burden),
    mean_power_asymmetry = mean(power_asymmetry)
  )

lm_fit <- lm(
  governance_effectiveness ~ incentive_alignment + legitimacy + norm_support +
    cognitive_interpretability + trust + coordination_quality +
    enforcement_credibility + adaptive_learning + perceived_fairness +
    behavioral_burden + hypocrisy_visibility + power_asymmetry,
  data = gov_data
)

logit_fit <- glm(
  high_governance ~ legitimacy + trust + coordination_quality +
    enforcement_credibility + adaptive_learning +
    cognitive_interpretability + perceived_fairness +
    behavioral_burden + power_asymmetry,
  family = binomial(link = "logit"),
  data = gov_data
)

enforcement_legitimacy_fit <- lm(
  governance_effectiveness ~ legitimacy * enforcement_credibility +
    trust + adaptive_learning + coordination_quality +
    perceived_fairness + behavioral_burden,
  data = gov_data
)

learning_interpretability_fit <- lm(
  governance_effectiveness ~ adaptive_learning * cognitive_interpretability +
    legitimacy + trust + coordination_quality +
    behavioral_burden + hypocrisy_visibility,
  data = gov_data
)

gam_fit <- gam(
  governance_effectiveness ~
    s(legitimacy) +
    s(trust) +
    s(cognitive_interpretability) +
    s(enforcement_credibility) +
    s(adaptive_learning) +
    s(behavioral_burden) +
    s(power_asymmetry),
  data = gov_data
)

fragile_cases <- gov_data |>
  filter(fragile_governance == 1) |>
  arrange(trust) |>
  select(
    unit_id,
    governance_effectiveness,
    high_governance,
    trust,
    legitimacy,
    cognitive_interpretability,
    coordination_quality,
    enforcement_credibility,
    behavioral_burden,
    hypocrisy_visibility
  )

high_burden_cases <- gov_data |>
  filter(high_burden_governance == 1) |>
  arrange(desc(behavioral_burden)) |>
  select(
    unit_id,
    governance_effectiveness,
    behavioral_burden,
    perceived_fairness,
    legitimacy,
    trust,
    power_asymmetry,
    hypocrisy_visibility
  )

write_csv(gov_data, file.path(output_dir, "behavioral_governance_r_synthetic_data.csv"))
write_csv(summary_table, file.path(output_dir, "behavioral_governance_r_summary.csv"))
write_csv(tidy(lm_fit, conf.int = TRUE), file.path(output_dir, "behavioral_governance_linear_model.csv"))
write_csv(tidy(logit_fit, conf.int = TRUE, exponentiate = TRUE), file.path(output_dir, "behavioral_governance_logit_model.csv"))
write_csv(tidy(enforcement_legitimacy_fit, conf.int = TRUE), file.path(output_dir, "behavioral_governance_enforcement_legitimacy_interaction.csv"))
write_csv(tidy(learning_interpretability_fit, conf.int = TRUE), file.path(output_dir, "behavioral_governance_learning_interpretability_interaction.csv"))
write_csv(fragile_cases, file.path(output_dir, "behavioral_governance_fragile_cases.csv"))
write_csv(high_burden_cases, file.path(output_dir, "behavioral_governance_high_burden_cases.csv"))

print(summary_table)
print(summary(gam_fit))
