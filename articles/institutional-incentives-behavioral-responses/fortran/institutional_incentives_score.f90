program institutional_incentives_score
  implicit none

  real :: value_alignment, fairness, information_quality, legitimacy
  real :: learning_support, accountability, bias_pressure, metric_substitution
  real :: reporting_distortion, behavioral_burden, short_termism
  real :: status_inequality, motivation_crowding, score

  value_alignment = 82.0
  fairness = 76.0
  information_quality = 80.0
  legitimacy = 78.0
  learning_support = 75.0
  accountability = 72.0
  bias_pressure = 25.0
  metric_substitution = 22.0
  reporting_distortion = 20.0
  behavioral_burden = 28.0
  short_termism = 24.0
  status_inequality = 18.0
  motivation_crowding = 21.0

  score = 0.14 * value_alignment + &
          0.12 * fairness + &
          0.13 * information_quality + &
          0.12 * legitimacy + &
          0.12 * learning_support + &
          0.10 * accountability - &
          0.10 * bias_pressure - &
          0.12 * metric_substitution - &
          0.09 * reporting_distortion - &
          0.08 * behavioral_burden - &
          0.07 * short_termism - &
          0.06 * status_inequality - &
          0.05 * motivation_crowding

  print *, "Institutional incentive raw score:", score
end program institutional_incentives_score
