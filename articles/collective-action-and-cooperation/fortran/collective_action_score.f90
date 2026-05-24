program collective_action_score
  implicit none

  real :: incentive_alignment, trust, legitimacy, norm_strength
  real :: enforcement_credibility, communication_quality, coordination_quality
  real :: perceived_fairness, free_riding_pressure, burden_inequality
  real :: hypocrisy_visibility, scale_complexity, score

  incentive_alignment = 78.0
  trust = 76.0
  legitimacy = 74.0
  norm_strength = 72.0
  enforcement_credibility = 70.0
  communication_quality = 80.0
  coordination_quality = 75.0
  perceived_fairness = 73.0
  free_riding_pressure = 30.0
  burden_inequality = 25.0
  hypocrisy_visibility = 20.0
  scale_complexity = 35.0

  score = 0.12 * incentive_alignment + &
          0.13 * trust + &
          0.12 * legitimacy + &
          0.11 * norm_strength + &
          0.10 * enforcement_credibility + &
          0.11 * communication_quality + &
          0.11 * coordination_quality + &
          0.10 * perceived_fairness - &
          0.12 * free_riding_pressure - &
          0.07 * burden_inequality - &
          0.06 * hypocrisy_visibility - &
          0.05 * scale_complexity

  print *, "Collective action raw score:", score
end program collective_action_score
