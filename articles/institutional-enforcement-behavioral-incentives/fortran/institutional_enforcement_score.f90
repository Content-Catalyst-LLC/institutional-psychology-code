program institutional_enforcement_score
  implicit none

  real :: monitoring_quality, legitimacy, incentive_alignment, sanction_credibility
  real :: information_quality, adaptive_learning, accountability_reach
  real :: compliance_burden, selective_enforcement, evasion_pressure
  real :: hypocrisy_visibility, defensive_compliance, score

  monitoring_quality = 82.0
  legitimacy = 76.0
  incentive_alignment = 74.0
  sanction_credibility = 72.0
  information_quality = 80.0
  adaptive_learning = 75.0
  accountability_reach = 70.0
  compliance_burden = 30.0
  selective_enforcement = 24.0
  evasion_pressure = 22.0
  hypocrisy_visibility = 18.0
  defensive_compliance = 20.0

  score = 0.13 * monitoring_quality + &
          0.13 * legitimacy + &
          0.12 * incentive_alignment + &
          0.12 * sanction_credibility + &
          0.13 * information_quality + &
          0.11 * adaptive_learning + &
          0.10 * accountability_reach - &
          0.08 * compliance_burden - &
          0.08 * selective_enforcement - &
          0.12 * evasion_pressure - &
          0.06 * hypocrisy_visibility - &
          0.06 * defensive_compliance

  print *, "Institutional enforcement raw score:", score
end program institutional_enforcement_score
