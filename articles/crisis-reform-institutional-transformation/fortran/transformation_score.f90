program transformation_score
  implicit none

  real :: crisis_severity, feedback_breakdown, legitimacy_failure
  real :: adaptive_capacity, reform_window, coalition_strength
  real :: coordination_quality, learning_rate, governance_alignment
  real :: power_concentration, capture_risk, distributional_attention
  real :: score

  crisis_severity = 85.0
  feedback_breakdown = 78.0
  legitimacy_failure = 80.0
  adaptive_capacity = 70.0
  reform_window = 75.0
  coalition_strength = 68.0
  coordination_quality = 72.0
  learning_rate = 65.0
  governance_alignment = 74.0
  power_concentration = 55.0
  capture_risk = 35.0
  distributional_attention = 80.0

  score = 0.15 * crisis_severity + &
          0.11 * feedback_breakdown + &
          0.14 * legitimacy_failure + &
          0.10 * adaptive_capacity + &
          0.12 * reform_window + &
          0.12 * coalition_strength + &
          0.08 * coordination_quality + &
          0.06 * learning_rate + &
          0.06 * governance_alignment + &
          0.05 * distributional_attention - &
          0.07 * capture_risk - &
          0.04 * abs(power_concentration - 50.0)

  print *, "Institutional transformation raw score:", score
end program transformation_score
