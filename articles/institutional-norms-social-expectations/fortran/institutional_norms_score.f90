program institutional_norms_score
  implicit none

  real :: norm_repetition, expectation_convergence, internalization
  real :: social_enforcement, legitimacy_alignment, trust_reinforcement
  real :: role_clarity, learning_capacity, fragmentation_pressure
  real :: unequal_normative_burden, suppressive_pressure
  real :: score

  norm_repetition = 82.0
  expectation_convergence = 84.0
  internalization = 78.0
  social_enforcement = 76.0
  legitimacy_alignment = 80.0
  trust_reinforcement = 79.0
  role_clarity = 77.0
  learning_capacity = 74.0
  fragmentation_pressure = 22.0
  unequal_normative_burden = 20.0
  suppressive_pressure = 18.0

  score = 0.13 * norm_repetition + &
          0.14 * expectation_convergence + &
          0.13 * internalization + &
          0.11 * social_enforcement + &
          0.13 * legitimacy_alignment + &
          0.11 * trust_reinforcement + &
          0.09 * role_clarity + &
          0.08 * learning_capacity - &
          0.13 * fragmentation_pressure - &
          0.10 * unequal_normative_burden - &
          0.08 * suppressive_pressure

  print *, "Normative stability raw score:", score
end program institutional_norms_score
