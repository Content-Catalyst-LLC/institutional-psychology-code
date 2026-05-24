program compliance_rule_following_score
  implicit none

  real :: legitimacy, fairness, incentive_alignment, norm_support
  real :: enforcement_credibility, communication_quality, cognitive_clarity, trust
  real :: adaptive_learning, compliance_burden, selective_rule_application
  real :: defensive_compliance, hypocrisy_visibility, norm_failure, score

  legitimacy = 76.0
  fairness = 78.0
  incentive_alignment = 72.0
  norm_support = 74.0
  enforcement_credibility = 70.0
  communication_quality = 80.0
  cognitive_clarity = 82.0
  trust = 75.0
  adaptive_learning = 73.0
  compliance_burden = 28.0
  selective_rule_application = 24.0
  defensive_compliance = 20.0
  hypocrisy_visibility = 18.0
  norm_failure = 22.0

  score = 0.13 * legitimacy + &
          0.13 * fairness + &
          0.11 * incentive_alignment + &
          0.11 * norm_support + &
          0.10 * enforcement_credibility + &
          0.11 * communication_quality + &
          0.12 * cognitive_clarity + &
          0.11 * trust + &
          0.09 * adaptive_learning - &
          0.11 * compliance_burden - &
          0.08 * selective_rule_application - &
          0.06 * defensive_compliance - &
          0.05 * hypocrisy_visibility - &
          0.05 * norm_failure

  print *, "Compliance quality raw score:", score
end program compliance_rule_following_score
