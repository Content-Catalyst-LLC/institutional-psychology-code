program decision_quality_score
  implicit none

  real :: bounded_rationality_pressure, organizational_structure_quality
  real :: incentive_alignment, information_flow_effectiveness, legitimacy
  real :: uncertainty_management, corrective_capacity, justice_voice
  real :: memory_quality, feedback_openness, bias_distortion, power_protection
  real :: metric_fixation, siloing, premature_closure
  real :: score

  bounded_rationality_pressure = 24.0
  organizational_structure_quality = 82.0
  incentive_alignment = 78.0
  information_flow_effectiveness = 84.0
  legitimacy = 80.0
  uncertainty_management = 76.0
  corrective_capacity = 82.0
  justice_voice = 72.0
  memory_quality = 74.0
  feedback_openness = 78.0
  bias_distortion = 22.0
  power_protection = 20.0
  metric_fixation = 24.0
  siloing = 18.0
  premature_closure = 21.0

  score = 0.12 * organizational_structure_quality + &
          0.12 * incentive_alignment + &
          0.13 * information_flow_effectiveness + &
          0.11 * legitimacy + &
          0.11 * uncertainty_management + &
          0.13 * corrective_capacity + &
          0.09 * justice_voice + &
          0.08 * memory_quality + &
          0.08 * feedback_openness - &
          0.13 * bounded_rationality_pressure - &
          0.11 * bias_distortion - &
          0.09 * power_protection - &
          0.08 * metric_fixation - &
          0.07 * siloing - &
          0.07 * premature_closure

  print *, "Institutional decision quality raw score:", score
end program decision_quality_score
