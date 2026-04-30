# Synthetic institutional psychology analysis.
# Run after the Python script creates data/processed/synthetic_institutional_observations.csv.

# install.packages(c("tidyverse", "broom", "scales"))
library(tidyverse)
library(broom)
library(scales)

data_path <- file.path("data", "processed", "synthetic_institutional_observations.csv")

if (!file.exists(data_path)) {
  stop("Run: python3 python/institutional_simulation.py")
}

pillar_data <- read.csv(data_path)

summary_table <- aggregate(
  cbind(
    legitimacy_strength,
    normative_stability,
    trust_density,
    cognitive_processing_quality,
    information_flow_effectiveness,
    memory_retention,
    learning_capacity,
    fragmentation_pressure,
    institutional_effectiveness,
    high_alignment
  ) ~ period,
  data = pillar_data,
  FUN = mean
)

dir.create("outputs", showWarnings = FALSE, recursive = TRUE)
write.csv(summary_table, file.path("outputs", "institutional_period_summary.csv"), row.names = FALSE)

lm_fit <- lm(
  institutional_effectiveness ~ legitimacy_strength + normative_stability +
    trust_density + cognitive_processing_quality +
    information_flow_effectiveness + memory_retention +
    learning_capacity + fragmentation_pressure,
  data = pillar_data
)

print(summary(lm_fit))
print(tidy(lm_fit, conf.int = TRUE))

logit_fit <- glm(
  high_alignment ~ legitimacy_strength + normative_stability +
    trust_density + information_flow_effectiveness +
    learning_capacity + fragmentation_pressure,
  family = binomial(link = "logit"),
  data = pillar_data
)

print(summary(logit_fit))
print(tidy(logit_fit, conf.int = TRUE, exponentiate = TRUE))

print(summary_table)
