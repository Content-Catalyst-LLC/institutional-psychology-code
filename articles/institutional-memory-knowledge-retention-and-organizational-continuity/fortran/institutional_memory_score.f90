program institutional_memory_score
  implicit none

  real :: documented_retention, tacit_transfer, accessibility, interpretive_use
  real :: revisability, technical_continuity, metadata_quality
  real :: distributed_integration, memory_justice, path_dependence_pressure
  real :: loss_fragmentation, selective_narration, turnover_pressure
  real :: key_person_dependency, score

  documented_retention = 84.0
  tacit_transfer = 78.0
  accessibility = 80.0
  interpretive_use = 76.0
  revisability = 74.0
  technical_continuity = 79.0
  metadata_quality = 82.0
  distributed_integration = 72.0
  memory_justice = 70.0
  path_dependence_pressure = 24.0
  loss_fragmentation = 22.0
  selective_narration = 20.0
  turnover_pressure = 26.0
  key_person_dependency = 28.0

  score = 0.12 * documented_retention + &
          0.12 * tacit_transfer + &
          0.12 * accessibility + &
          0.12 * interpretive_use + &
          0.11 * revisability + &
          0.09 * technical_continuity + &
          0.08 * metadata_quality + &
          0.08 * distributed_integration + &
          0.08 * memory_justice - &
          0.11 * path_dependence_pressure - &
          0.11 * loss_fragmentation - &
          0.08 * selective_narration - &
          0.07 * turnover_pressure - &
          0.06 * key_person_dependency

  print *, "Institutional memory raw score:", score
end program institutional_memory_score
