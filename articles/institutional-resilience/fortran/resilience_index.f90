program resilience_index
  implicit none

  real :: robustness, adaptive_capacity, recovery_capacity
  real :: transformational_capacity, legitimacy, trust
  real :: feedback_quality, learning_rate, redundancy
  real :: modularity, coordination, shock_intensity
  real :: score

  robustness = 80.0
  adaptive_capacity = 75.0
  recovery_capacity = 70.0
  transformational_capacity = 60.0
  legitimacy = 85.0
  trust = 82.0
  feedback_quality = 78.0
  learning_rate = 74.0
  redundancy = 65.0
  modularity = 68.0
  coordination = 80.0
  shock_intensity = 50.0

  score = 0.10 * robustness + &
          0.12 * adaptive_capacity + &
          0.10 * recovery_capacity + &
          0.08 * transformational_capacity + &
          0.12 * legitimacy + &
          0.10 * trust + &
          0.10 * feedback_quality + &
          0.08 * learning_rate + &
          0.07 * redundancy + &
          0.05 * modularity + &
          0.08 * coordination - &
          0.10 * shock_intensity

  print *, "Institutional resilience raw score:", score
end program resilience_index
