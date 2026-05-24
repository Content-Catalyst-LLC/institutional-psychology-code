program regulatory_accountability_score
  implicit none

  real :: oversight_strength, legitimacy, incentive_alignment, enforcement_credibility
  real :: information_quality, adaptive_learning, accountability_reach
  real :: capture_pressure, regulatory_burden, evasion_pressure
  real :: hypocrisy_visibility, unequal_accountability, score

  oversight_strength = 82.0
  legitimacy = 76.0
  incentive_alignment = 74.0
  enforcement_credibility = 72.0
  information_quality = 80.0
  adaptive_learning = 75.0
  accountability_reach = 70.0
  capture_pressure = 25.0
  regulatory_burden = 30.0
  evasion_pressure = 22.0
  hypocrisy_visibility = 18.0
  unequal_accountability = 24.0

  score = 0.13 * oversight_strength + &
          0.13 * legitimacy + &
          0.11 * incentive_alignment + &
          0.12 * enforcement_credibility + &
          0.13 * information_quality + &
          0.11 * adaptive_learning + &
          0.11 * accountability_reach - &
          0.12 * capture_pressure - &
          0.08 * regulatory_burden - &
          0.07 * evasion_pressure - &
          0.06 * hypocrisy_visibility - &
          0.06 * unequal_accountability

  print *, "Regulatory accountability raw score:", score
end program regulatory_accountability_score
