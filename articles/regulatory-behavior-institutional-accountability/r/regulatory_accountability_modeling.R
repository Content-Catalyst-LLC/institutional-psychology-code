# Regulatory Behavior and Institutional Accountability in R
#
# Purpose:
# Build a synthetic dataset for modeling regulatory accountability.
# Estimate accountability effectiveness, high-accountability probability,
# interaction effects, fragile regulatory environments, and high-burden
# regulatory accountability risks.
#
# Recommended install:
# pak::pak(c("tidyverse", "broom", "scales", "mgcv"))

suppressPackageStartupMessages({
  library(tidyverse)
  library(broom)
  library(scales)
  library(mgcv)
})

set.seed(808)

article_dir <- normalizePath(file.path(".."), mustWork = FALSE)
output_dir <- file.path(article_dir, "outputs", "tables")
dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)

n <- 650

reg_data <- tibble(
  unit_id = 1:n,
  oversight_strength = runif(n, 10, 95),
  legitimacy = runif(n, 10, 95),
  incentive_alignment = runif(n, 10, 95),
  enforcement_credibility = runif(n, 5, 95),
  information_quality = runif(n, 10, 95),
  adaptive_learning = runif(n, 10, 95),
  accountability_reach = runif(n, 5, 95),
  capture_pressure = runif(n, 5, 95),
  regulatory_burden = runif(n, 5, 95),
  evasion_pressure = runif(n, 5, 95),
  hypocrisy_visibility = runif(n, 5, 95),
  unequal_accountability = runif(n, 5, 95)
) |>
  mutate(
    accountability_raw =
      0.13 * oversight_strength +
      0.13 * legitimacy +
      0.11 * incentive_alignment +
      0.12 * enforcement_credibility +
      0.13 * information_quality +
      0.11 * adaptive_learning +
      0.11 * accountability_reach -
      0.12 * capture_pressure -
      0.08 * regulatory_burden -
      0.07 * evasion_pressure -
      0.06 * hypocrisy_visibility -
      0.06 * unequal_accountability +
      rnorm(n, 0, 6),
    accountability_effectiveness = rescale(accountability_raw, to = c(0, 100)),
    high_accountability = if_else(accountability_effectiveness >= 60, 1, 0),
    fragile_regulation = if_else(
      high_accountability == 1 & legitimacy < 40,
      1,
      0
    ),
    high_burden_regulation = if_else(
      high_accountability == 1 &
        regulatory_burden > 65 &
        unequal_accountability > 65,
      1,
      0
    )
  )

summary_table <- reg_data |>
  summarise(
    mean_accountability_effectiveness = mean(accountability_effectiveness),
    high_accountability_rate = mean(high_accountability),
    fragile_regulation_rate = mean(fragile_regulation),
    high_burden_regulation_rate = mean(high_burden_regulation),
    mean_legitimacy = mean(legitimacy),
    mean_information_quality = mean(information_quality),
    mean_capture_pressure = mean(capture_pressure),
    mean_regulatory_burden = mean(regulatory_burden),
    mean_unequal_accountability = mean(unequal_accountability)
  )

lm_fit <- lm(
  accountability_effectiveness ~ oversight_strength + legitimacy +
    incentive_alignment + enforcement_credibility + information_quality +
    adaptive_learning + accountability_reach + capture_pressure +
    regulatory_burden + evasion_pressure + hypocrisy_visibility +
    unequal_accountability,
  data = reg_data
)

logit_fit <- glm(
  high_accountability ~ legitimacy + oversight_strength +
    information_quality + enforcement_credibility + adaptive_learning +
    accountability_reach + capture_pressure + regulatory_burden +
    unequal_accountability,
  family = binomial(link = "logit"),
  data = reg_data
)

enforcement_legitimacy_fit <- lm(
  accountability_effectiveness ~ enforcement_credibility * legitimacy +
    oversight_strength + information_quality + adaptive_learning +
    capture_pressure + regulatory_burden,
  data = reg_data
)

oversight_information_fit <- lm(
  accountability_effectiveness ~ oversight_strength * information_quality +
    legitimacy + enforcement_credibility + adaptive_learning +
    capture_pressure + unequal_accountability,
  data = reg_data
)

gam_fit <- gam(
  accountability_effectiveness ~
    s(oversight_strength) +
    s(legitimacy) +
    s(information_quality) +
    s(enforcement_credibility) +
    s(adaptive_learning) +
    s(capture_pressure) +
    s(regulatory_burden) +
    s(unequal_accountability),
  data = reg_data
)

fragile_cases <- reg_data |>
  filter(fragile_regulation == 1) |>
  arrange(legitimacy) |>
  select(
    unit_id,
    accountability_effectiveness,
    high_accountability,
    legitimacy,
    oversight_strength,
    information_quality,
    enforcement_credibility,
    capture_pressure,
    regulatory_burden,
    unequal_accountability
  )

high_burden_cases <- reg_data |>
  filter(high_burden_regulation == 1) |>
  arrange(desc(regulatory_burden)) |>
  select(
    unit_id,
    accountability_effectiveness,
    regulatory_burden,
    unequal_accountability,
    legitimacy,
    accountability_reach,
    capture_pressure,
    hypocrisy_visibility
  )

write_csv(reg_data, file.path(output_dir, "regulatory_accountability_r_synthetic_data.csv"))
write_csv(summary_table, file.path(output_dir, "regulatory_accountability_r_summary.csv"))
write_csv(tidy(lm_fit, conf.int = TRUE), file.path(output_dir, "regulatory_accountability_linear_model.csv"))
write_csv(tidy(logit_fit, conf.int = TRUE, exponentiate = TRUE), file.path(output_dir, "regulatory_accountability_logit_model.csv"))
write_csv(tidy(enforcement_legitimacy_fit, conf.int = TRUE), file.path(output_dir, "regulatory_accountability_enforcement_legitimacy_interaction.csv"))
write_csv(tidy(oversight_information_fit, conf.int = TRUE), file.path(output_dir, "regulatory_accountability_oversight_information_interaction.csv"))
write_csv(fragile_cases, file.path(output_dir, "regulatory_accountability_fragile_cases.csv"))
write_csv(high_burden_cases, file.path(output_dir, "regulatory_accountability_high_burden_cases.csv"))

print(summary_table)
print(summary(gam_fit))
