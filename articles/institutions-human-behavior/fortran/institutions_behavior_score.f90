program institutions_behavior_score
  implicit none

  real :: normative_stability, legitimacy_strength, incentive_alignment
  real :: information_quality, memory_retention, learning_capacity
  real :: trust_reinforcement, role_clarity, repair_capacity
  real :: fragmentation_pressure, opacity_pressure, administrative_burden
  real :: historical_harm_pressure, score

  normative_stability = 82.0
  legitimacy_strength = 84.0
  incentive_alignment = 78.0
  information_quality = 80.0
  memory_retention = 76.0
  learning_capacity = 79.0
  trust_reinforcement = 81.0
  role_clarity = 77.0
  repair_capacity = 74.0
  fragmentation_pressure = 22.0
  opacity_pressure = 20.0
  administrative_burden = 18.0
  historical_harm_pressure = 16.0

  score = 0.13 * normative_stability + &
          0.14 * legitimacy_strength + &
          0.11 * incentive_alignment + &
          0.12 * information_quality + &
          0.11 * memory_retention + &
          0.13 * learning_capacity + &
          0.12 * trust_reinforcement + &
          0.08 * role_clarity + &
          0.08 * repair_capacity - &
          0.12 * fragmentation_pressure - &
          0.08 * opacity_pressure - &
          0.08 * administrative_burden - &
          0.07 * historical_harm_pressure

  print *, "Institutional strength raw score:", score
end program institutions_behavior_score
