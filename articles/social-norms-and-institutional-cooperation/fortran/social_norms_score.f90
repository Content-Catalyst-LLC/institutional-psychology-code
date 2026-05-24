program social_norms_score
  implicit none

  real :: descriptive_norm, injunctive_norm, trust, legitimacy
  real :: sanction_intensity, transmission_strength, institutional_reinforcement
  real :: norm_conflict, hypocrisy_visibility, unequal_enforcement
  real :: performative_compliance, distributional_attention, score

  descriptive_norm = 80.0
  injunctive_norm = 78.0
  trust = 75.0
  legitimacy = 72.0
  sanction_intensity = 60.0
  transmission_strength = 74.0
  institutional_reinforcement = 82.0
  norm_conflict = 30.0
  hypocrisy_visibility = 25.0
  unequal_enforcement = 20.0
  performative_compliance = 25.0
  distributional_attention = 70.0

  score = 0.14 * descriptive_norm + &
          0.14 * injunctive_norm + &
          0.13 * trust + &
          0.12 * legitimacy + &
          0.10 * sanction_intensity + &
          0.11 * transmission_strength + &
          0.12 * institutional_reinforcement - &
          0.13 * norm_conflict - &
          0.08 * hypocrisy_visibility - &
          0.07 * unequal_enforcement - &
          0.05 * performative_compliance + &
          0.04 * distributional_attention

  print *, "Social norms cooperation raw score:", score
end program social_norms_score
