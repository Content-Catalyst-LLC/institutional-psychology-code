program institutional_trust_score
  implicit none

  real :: consistency, competence, fairness, transparency, accountability
  real :: integrity, recognition_voice, repair_capacity
  real :: arbitrariness_pressure, visible_violation_pressure, administrative_burden
  real :: score

  consistency = 82.0
  competence = 80.0
  fairness = 84.0
  transparency = 78.0
  accountability = 82.0
  integrity = 79.0
  recognition_voice = 76.0
  repair_capacity = 74.0
  arbitrariness_pressure = 22.0
  visible_violation_pressure = 20.0
  administrative_burden = 18.0

  score = 0.11 * consistency + &
          0.12 * competence + &
          0.14 * fairness + &
          0.10 * transparency + &
          0.13 * accountability + &
          0.12 * integrity + &
          0.09 * recognition_voice + &
          0.09 * repair_capacity - &
          0.13 * arbitrariness_pressure - &
          0.11 * visible_violation_pressure - &
          0.08 * administrative_burden

  print *, "Institutional trust raw score:", score
end program institutional_trust_score
