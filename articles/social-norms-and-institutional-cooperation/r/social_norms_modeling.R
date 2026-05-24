# Social Norms and Institutional Cooperation in R
#
# Purpose:
# Build a synthetic dataset for modeling norm-based institutional cooperation.
# Estimate cooperation scores, high-compliance probability, interaction effects,
# fragile norm environments, and unequal norm-burden risks.
#
# Recommended install:
# pak::pak(c("tidyverse", "broom", "scales", "mgcv"))

suppressPackageStartupMessages({
  library(tidyverse)
  library(broom)
  library(scales)
  library(mgcv)
})

set.seed(505)

article_dir <- normalizePath(file.path(dirname(sys.frame(1)$ofile %||% "."), ".."), mustWork = FALSE)
output_dir <- file.path(article_dir, "outputs", "tables")
dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)

n <- 600

norm_data <- tibble(
  unit_id = 1:n,
  descriptive_norm = runif(n, 10, 95),
  injunctive_norm = runif(n, 10, 95),
  trust = runif(n, 10, 95),
  legitimacy = runif(n, 10, 95),
  sanction_intensity = runif(n, 5, 95),
  transmission_strength = runif(n, 10, 95),
  institutional_reinforcement = runif(n, 10, 95),
  norm_conflict = runif(n, 5, 95),
  hypocrisy_visibility = runif(n, 5, 95),
  unequal_enforcement = runif(n, 5, 95),
  performative_compliance = runif(n, 5, 95),
  distributional_attention = runif(n, 5, 95)
) |>
  mutate(
    cooperation_raw =
      0.14 * descriptive_norm +
      0.14 * injunctive_norm +
      0.13 * trust +
      0.12 * legitimacy +
      0.10 * sanction_intensity +
      0.11 * transmission_strength +
      0.12 * institutional_reinforcement -
      0.13 * norm_conflict -
      0.08 * hypocrisy_visibility -
      0.07 * unequal_enforcement -
      0.05 * performative_compliance +
      0.04 * distributional_attention +
      rnorm(n, 0, 6),
    cooperation_score = rescale(cooperation_raw, to = c(0, 100)),
    high_norm_compliance = if_else(cooperation_score >= 60, 1, 0),
    fragile_norm_environment = if_else(
      high_norm_compliance == 1 & trust < 40,
      1,
      0
    ),
    high_burden_norm_environment = if_else(
      high_norm_compliance == 1 &
        unequal_enforcement > 65 &
        distributional_attention < 40,
      1,
      0
    )
  )

summary_table <- norm_data |>
  summarise(
    mean_cooperation_score = mean(cooperation_score),
    high_norm_compliance_rate = mean(high_norm_compliance),
    fragile_norm_environment_rate = mean(fragile_norm_environment),
    high_burden_norm_environment_rate = mean(high_burden_norm_environment),
    mean_trust = mean(trust),
    mean_legitimacy = mean(legitimacy),
    mean_norm_conflict = mean(norm_conflict),
    mean_unequal_enforcement = mean(unequal_enforcement)
  )

lm_fit <- lm(
  cooperation_score ~ descriptive_norm + injunctive_norm + trust +
    legitimacy + sanction_intensity + transmission_strength +
    institutional_reinforcement + norm_conflict +
    hypocrisy_visibility + unequal_enforcement +
    performative_compliance + distributional_attention,
  data = norm_data
)

logit_fit <- glm(
  high_norm_compliance ~ descriptive_norm + injunctive_norm + trust +
    legitimacy + sanction_intensity + institutional_reinforcement +
    norm_conflict + hypocrisy_visibility + unequal_enforcement,
  family = binomial(link = "logit"),
  data = norm_data
)

interaction_fit <- lm(
  cooperation_score ~ injunctive_norm * institutional_reinforcement +
    trust + legitimacy + norm_conflict + unequal_enforcement,
  data = norm_data
)

sanction_legitimacy_fit <- lm(
  cooperation_score ~ sanction_intensity * legitimacy +
    descriptive_norm + injunctive_norm + trust +
    norm_conflict + hypocrisy_visibility,
  data = norm_data
)

gam_fit <- gam(
  cooperation_score ~
    s(descriptive_norm) +
    s(injunctive_norm) +
    s(trust) +
    s(legitimacy) +
    s(norm_conflict) +
    s(unequal_enforcement),
  data = norm_data
)

fragile_cases <- norm_data |>
  filter(fragile_norm_environment == 1) |>
  arrange(trust) |>
  select(
    unit_id,
    cooperation_score,
    high_norm_compliance,
    trust,
    legitimacy,
    descriptive_norm,
    injunctive_norm,
    norm_conflict,
    hypocrisy_visibility,
    unequal_enforcement
  )

high_burden_cases <- norm_data |>
  filter(high_burden_norm_environment == 1) |>
  arrange(desc(unequal_enforcement)) |>
  select(
    unit_id,
    cooperation_score,
    unequal_enforcement,
    distributional_attention,
    sanction_intensity,
    legitimacy,
    performative_compliance,
    norm_conflict
  )

write_csv(norm_data, file.path(output_dir, "social_norms_r_synthetic_data.csv"))
write_csv(summary_table, file.path(output_dir, "social_norms_r_summary.csv"))
write_csv(tidy(lm_fit, conf.int = TRUE), file.path(output_dir, "social_norms_linear_model.csv"))
write_csv(tidy(logit_fit, conf.int = TRUE, exponentiate = TRUE), file.path(output_dir, "social_norms_logit_model.csv"))
write_csv(tidy(interaction_fit, conf.int = TRUE), file.path(output_dir, "social_norms_injunctive_reinforcement_interaction.csv"))
write_csv(tidy(sanction_legitimacy_fit, conf.int = TRUE), file.path(output_dir, "social_norms_sanction_legitimacy_interaction.csv"))
write_csv(fragile_cases, file.path(output_dir, "social_norms_fragile_cases.csv"))
write_csv(high_burden_cases, file.path(output_dir, "social_norms_high_burden_cases.csv"))

print(summary_table)
print(summary(gam_fit))
