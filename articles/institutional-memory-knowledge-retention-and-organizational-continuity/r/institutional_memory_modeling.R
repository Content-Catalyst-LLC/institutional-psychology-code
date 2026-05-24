# Institutional Memory: Knowledge Retention and Organizational Continuity in R
#
# Purpose:
# Build a synthetic dataset for modeling institutional memory effectiveness.
# Estimate memory quality, high-resilience memory probability,
# accessibility-interpretive-use interaction effects,
# revisability-path-dependence effects, fragile memory environments,
# and high-path-dependence memory risks.
#
# Recommended install:
# pak::pak(c("tidyverse", "broom", "scales", "mgcv"))

suppressPackageStartupMessages({
  library(tidyverse)
  library(broom)
  library(scales)
  library(mgcv)
})

set.seed(1313)

article_dir <- normalizePath(file.path(".."), mustWork = FALSE)
output_dir <- file.path(article_dir, "outputs", "tables")
dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)

n <- 650

mem_data <- tibble(
  unit_id = 1:n,
  documented_retention = runif(n, 10, 95),
  tacit_transfer = runif(n, 10, 95),
  accessibility = runif(n, 10, 95),
  interpretive_use = runif(n, 10, 95),
  revisability = runif(n, 10, 95),
  technical_continuity = runif(n, 10, 95),
  metadata_quality = runif(n, 10, 95),
  distributed_integration = runif(n, 10, 95),
  memory_justice = runif(n, 10, 95),
  path_dependence_pressure = runif(n, 5, 95),
  loss_fragmentation = runif(n, 5, 95),
  selective_narration = runif(n, 5, 95),
  turnover_pressure = runif(n, 5, 95),
  key_person_dependency = runif(n, 5, 95)
) |>
  mutate(
    memory_raw =
      0.12 * documented_retention +
      0.12 * tacit_transfer +
      0.12 * accessibility +
      0.12 * interpretive_use +
      0.11 * revisability +
      0.09 * technical_continuity +
      0.08 * metadata_quality +
      0.08 * distributed_integration +
      0.08 * memory_justice -
      0.11 * path_dependence_pressure -
      0.11 * loss_fragmentation -
      0.08 * selective_narration -
      0.07 * turnover_pressure -
      0.06 * key_person_dependency +
      rnorm(n, 0, 6),
    memory_effectiveness = rescale(memory_raw, to = c(0, 100)),
    high_resilience_memory = if_else(memory_effectiveness >= 60, 1, 0),
    fragile_memory = if_else(
      high_resilience_memory == 1 &
        documented_retention < 40 &
        tacit_transfer < 40,
      1,
      0
    ),
    high_path_dependence_memory = if_else(
      high_resilience_memory == 1 &
        path_dependence_pressure > 65 &
        revisability < 40,
      1,
      0
    )
  )

summary_table <- mem_data |>
  summarise(
    mean_memory_effectiveness = mean(memory_effectiveness),
    high_resilience_memory_rate = mean(high_resilience_memory),
    fragile_memory_rate = mean(fragile_memory),
    high_path_dependence_memory_rate = mean(high_path_dependence_memory),
    mean_documented_retention = mean(documented_retention),
    mean_tacit_transfer = mean(tacit_transfer),
    mean_accessibility = mean(accessibility),
    mean_revisability = mean(revisability),
    mean_path_dependence_pressure = mean(path_dependence_pressure),
    mean_loss_fragmentation = mean(loss_fragmentation)
  )

lm_fit <- lm(
  memory_effectiveness ~ documented_retention + tacit_transfer +
    accessibility + interpretive_use + revisability +
    technical_continuity + metadata_quality + distributed_integration +
    memory_justice + path_dependence_pressure + loss_fragmentation +
    selective_narration + turnover_pressure + key_person_dependency,
  data = mem_data
)

logit_fit <- glm(
  high_resilience_memory ~ documented_retention + tacit_transfer +
    accessibility + interpretive_use + revisability +
    metadata_quality + memory_justice + path_dependence_pressure +
    loss_fragmentation + turnover_pressure,
  family = binomial(link = "logit"),
  data = mem_data
)

access_interpretive_fit <- lm(
  memory_effectiveness ~ accessibility * interpretive_use +
    documented_retention + tacit_transfer + revisability +
    loss_fragmentation + path_dependence_pressure,
  data = mem_data
)

revisability_path_fit <- lm(
  memory_effectiveness ~ revisability * path_dependence_pressure +
    documented_retention + tacit_transfer + accessibility +
    metadata_quality + loss_fragmentation + selective_narration,
  data = mem_data
)

gam_fit <- gam(
  memory_effectiveness ~
    s(documented_retention) +
    s(tacit_transfer) +
    s(accessibility) +
    s(interpretive_use) +
    s(revisability) +
    s(metadata_quality) +
    s(path_dependence_pressure) +
    s(loss_fragmentation) +
    s(selective_narration),
  data = mem_data
)

fragile_cases <- mem_data |>
  filter(fragile_memory == 1) |>
  arrange(documented_retention, tacit_transfer) |>
  select(
    unit_id,
    memory_effectiveness,
    high_resilience_memory,
    documented_retention,
    tacit_transfer,
    accessibility,
    interpretive_use,
    loss_fragmentation,
    turnover_pressure,
    key_person_dependency
  )

high_path_cases <- mem_data |>
  filter(high_path_dependence_memory == 1) |>
  arrange(desc(path_dependence_pressure)) |>
  select(
    unit_id,
    memory_effectiveness,
    path_dependence_pressure,
    revisability,
    documented_retention,
    tacit_transfer,
    selective_narration,
    memory_justice,
    distributed_integration
  )

write_csv(mem_data, file.path(output_dir, "institutional_memory_r_synthetic_data.csv"))
write_csv(summary_table, file.path(output_dir, "institutional_memory_r_summary.csv"))
write_csv(tidy(lm_fit, conf.int = TRUE), file.path(output_dir, "institutional_memory_linear_model.csv"))
write_csv(tidy(logit_fit, conf.int = TRUE, exponentiate = TRUE), file.path(output_dir, "institutional_memory_logit_model.csv"))
write_csv(tidy(access_interpretive_fit, conf.int = TRUE), file.path(output_dir, "institutional_memory_access_interpretive_interaction.csv"))
write_csv(tidy(revisability_path_fit, conf.int = TRUE), file.path(output_dir, "institutional_memory_revisability_path_interaction.csv"))
write_csv(fragile_cases, file.path(output_dir, "institutional_memory_fragile_cases.csv"))
write_csv(high_path_cases, file.path(output_dir, "institutional_memory_high_path_dependence_cases.csv"))

print(summary_table)
print(summary(gam_fit))
