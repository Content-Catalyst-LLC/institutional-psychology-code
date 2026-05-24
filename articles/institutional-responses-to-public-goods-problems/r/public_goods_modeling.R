# Public Goods Provision, Trust, and Institutional Design in R
#
# Purpose:
# Build a synthetic dataset for modeling public goods contribution and
# provision quality. Estimate the role of trust, legitimacy, enforcement,
# norms, monitoring, selective incentives, perceived fairness, capture risk,
# and scale complexity.
#
# Recommended install:
# pak::pak(c("tidyverse", "broom", "scales", "mgcv"))

suppressPackageStartupMessages({
  library(tidyverse)
  library(broom)
  library(scales)
  library(mgcv)
})

set.seed(303)

article_dir <- normalizePath(file.path(dirname(sys.frame(1)$ofile %||% "."), ".."), mustWork = FALSE)
output_dir <- file.path(article_dir, "outputs", "tables")
dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)

n <- 600

pg_data <- tibble(
  unit_id = 1:n,
  trust = runif(n, 10, 95),
  legitimacy = runif(n, 10, 95),
  enforcement = runif(n, 5, 95),
  norm_strength = runif(n, 10, 95),
  coordination = runif(n, 10, 95),
  monitoring = runif(n, 10, 95),
  selective_incentives = runif(n, 5, 95),
  scale_complexity = runif(n, 5, 95),
  perceived_fairness = runif(n, 5, 95),
  capture_risk = runif(n, 5, 90),
  distributional_attention = runif(n, 5, 95)
) |>
  mutate(
    contribution_rate =
      0.15 * trust +
      0.14 * legitimacy +
      0.12 * enforcement +
      0.11 * norm_strength +
      0.10 * coordination +
      0.10 * monitoring +
      0.09 * selective_incentives +
      0.08 * perceived_fairness -
      0.12 * scale_complexity -
      0.07 * capture_risk +
      rnorm(n, 0, 7),
    contribution_rate = pmax(pmin(contribution_rate, 100), 0),
    provision_quality =
      0.22 * contribution_rate +
      0.13 * legitimacy +
      0.12 * trust +
      0.11 * coordination +
      0.10 * monitoring +
      0.08 * distributional_attention -
      0.12 * scale_complexity -
      0.08 * capture_risk +
      rnorm(n, 0, 5),
    provision_quality = rescale(provision_quality, to = c(0, 100)),
    high_provision = if_else(provision_quality >= 60, 1, 0),
    fragile_public_good = if_else(
      provision_quality >= 60 & legitimacy < 40,
      1,
      0
    ),
    high_burden_risk = if_else(
      provision_quality >= 60 & distributional_attention < 35,
      1,
      0
    )
  )

summary_table <- pg_data |>
  summarise(
    mean_contribution_rate = mean(contribution_rate),
    mean_provision_quality = mean(provision_quality),
    high_provision_rate = mean(high_provision),
    fragile_public_good_rate = mean(fragile_public_good),
    high_burden_risk_rate = mean(high_burden_risk),
    mean_trust = mean(trust),
    mean_legitimacy = mean(legitimacy)
  )

lm_fit <- lm(
  provision_quality ~ contribution_rate + legitimacy + trust +
    enforcement + coordination + monitoring + perceived_fairness +
    scale_complexity + capture_risk,
  data = pg_data
)

logit_fit <- glm(
  high_provision ~ trust + legitimacy + enforcement + norm_strength +
    monitoring + perceived_fairness + scale_complexity + capture_risk,
  family = binomial(link = "logit"),
  data = pg_data
)

interaction_fit <- lm(
  provision_quality ~ enforcement * legitimacy +
    trust + coordination + monitoring + scale_complexity + capture_risk,
  data = pg_data
)

gam_fit <- gam(
  provision_quality ~
    s(trust) +
    s(legitimacy) +
    s(enforcement) +
    s(monitoring) +
    s(scale_complexity),
  data = pg_data
)

fragile_cases <- pg_data |>
  filter(fragile_public_good == 1) |>
  arrange(legitimacy) |>
  select(
    unit_id,
    provision_quality,
    contribution_rate,
    trust,
    legitimacy,
    enforcement,
    monitoring,
    capture_risk,
    distributional_attention
  )

high_burden_cases <- pg_data |>
  filter(high_burden_risk == 1) |>
  arrange(distributional_attention) |>
  select(
    unit_id,
    provision_quality,
    contribution_rate,
    distributional_attention,
    perceived_fairness,
    capture_risk,
    scale_complexity
  )

write_csv(pg_data, file.path(output_dir, "public_goods_r_synthetic_data.csv"))
write_csv(summary_table, file.path(output_dir, "public_goods_r_summary.csv"))
write_csv(tidy(lm_fit, conf.int = TRUE), file.path(output_dir, "public_goods_linear_model.csv"))
write_csv(tidy(logit_fit, conf.int = TRUE, exponentiate = TRUE), file.path(output_dir, "public_goods_logit_model.csv"))
write_csv(tidy(interaction_fit, conf.int = TRUE), file.path(output_dir, "public_goods_enforcement_legitimacy_interaction.csv"))
write_csv(fragile_cases, file.path(output_dir, "public_goods_fragile_cases.csv"))
write_csv(high_burden_cases, file.path(output_dir, "public_goods_high_burden_cases.csv"))

print(summary_table)
print(summary(gam_fit))
