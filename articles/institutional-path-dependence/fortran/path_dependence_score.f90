program path_dependence_score
  implicit none

  real :: initial_conditions, behavioral_reinforcement, feedback_strength
  real :: increasing_returns, coordination_effects, learning_effects
  real :: legitimacy, switching_costs, complementarity
  real :: disruption_pressure, reform_capacity
  real :: score

  initial_conditions = 80.0
  behavioral_reinforcement = 75.0
  feedback_strength = 70.0
  increasing_returns = 82.0
  coordination_effects = 78.0
  learning_effects = 74.0
  legitimacy = 85.0
  switching_costs = 88.0
  complementarity = 79.0
  disruption_pressure = 35.0
  reform_capacity = 40.0

  score = 0.08 * initial_conditions + &
          0.12 * behavioral_reinforcement + &
          0.12 * feedback_strength + &
          0.13 * increasing_returns + &
          0.11 * coordination_effects + &
          0.10 * learning_effects + &
          0.12 * legitimacy + &
          0.12 * switching_costs + &
          0.10 * complementarity - &
          0.12 * disruption_pressure - &
          0.05 * reform_capacity

  print *, "Institutional path dependence raw score:", score
end program path_dependence_score
