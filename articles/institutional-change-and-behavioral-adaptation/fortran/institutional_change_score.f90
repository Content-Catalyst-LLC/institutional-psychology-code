program institutional_change_score
  implicit none

  real :: feedback_quality, adaptive_capacity, legitimacy
  real :: incentive_alignment, normative_support, governance_capacity
  real :: path_dependence, behavioral_flexibility, coordination_quality
  real :: environmental_change, distributional_attention, transition_burden
  real :: score

  feedback_quality = 80.0
  adaptive_capacity = 78.0
  legitimacy = 75.0
  incentive_alignment = 70.0
  normative_support = 72.0
  governance_capacity = 82.0
  path_dependence = 40.0
  behavioral_flexibility = 76.0
  coordination_quality = 74.0
  environmental_change = 65.0
  distributional_attention = 70.0
  transition_burden = 35.0

  score = 0.13 * feedback_quality + &
          0.14 * adaptive_capacity + &
          0.10 * legitimacy + &
          0.10 * incentive_alignment + &
          0.09 * normative_support + &
          0.12 * governance_capacity - &
          0.12 * path_dependence + &
          0.10 * behavioral_flexibility + &
          0.08 * coordination_quality + &
          0.06 * environmental_change + &
          0.05 * distributional_attention - &
          0.05 * transition_burden

  print *, "Institutional change raw score:", score
end program institutional_change_score
