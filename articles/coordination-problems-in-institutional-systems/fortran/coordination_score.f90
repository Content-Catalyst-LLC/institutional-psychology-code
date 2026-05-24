program coordination_score
  implicit none

  real :: trust, information_quality, communication_clarity, focal_salience
  real :: authority_signal, norm_strength, learning_capacity, uncertainty
  real :: adaptation_burden, competing_standards, competing_authority
  real :: distributional_attention, score

  trust = 80.0
  information_quality = 78.0
  communication_clarity = 82.0
  focal_salience = 76.0
  authority_signal = 74.0
  norm_strength = 70.0
  learning_capacity = 72.0
  uncertainty = 30.0
  adaptation_burden = 35.0
  competing_standards = 25.0
  competing_authority = 20.0
  distributional_attention = 68.0

  score = 0.14 * trust + &
          0.14 * information_quality + &
          0.13 * communication_clarity + &
          0.12 * focal_salience + &
          0.10 * authority_signal + &
          0.10 * norm_strength + &
          0.09 * learning_capacity - &
          0.13 * uncertainty - &
          0.07 * adaptation_burden - &
          0.06 * competing_standards - &
          0.05 * competing_authority + &
          0.04 * distributional_attention

  print *, "Institutional coordination raw score:", score
end program coordination_score
