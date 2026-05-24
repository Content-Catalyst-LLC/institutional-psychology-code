program authority_legitimacy_score
  implicit none

  real :: formal_authority_clarity, procedural_legitimacy, outcome_legitimacy
  real :: trust, rule_clarity, social_recognition, accountability
  real :: repair_capacity, fairness, arbitrariness_pressure
  real :: visible_inconsistency, unequal_burden, opacity_pressure
  real :: score

  formal_authority_clarity = 82.0
  procedural_legitimacy = 84.0
  outcome_legitimacy = 78.0
  trust = 80.0
  rule_clarity = 82.0
  social_recognition = 76.0
  accountability = 79.0
  repair_capacity = 74.0
  fairness = 81.0
  arbitrariness_pressure = 22.0
  visible_inconsistency = 20.0
  unequal_burden = 18.0
  opacity_pressure = 19.0

  score = 0.11 * formal_authority_clarity + &
          0.14 * procedural_legitimacy + &
          0.12 * outcome_legitimacy + &
          0.13 * trust + &
          0.11 * rule_clarity + &
          0.11 * social_recognition + &
          0.12 * accountability + &
          0.10 * repair_capacity + &
          0.10 * fairness - &
          0.14 * arbitrariness_pressure - &
          0.10 * visible_inconsistency - &
          0.09 * unequal_burden - &
          0.08 * opacity_pressure

  print *, "Authority-legitimacy raw score:", score
end program authority_legitimacy_score
