program institutional_learning_score
  implicit none

  real :: feedback_quality, memory_retention, communication_openness
  real :: interpretive_quality, decision_revisability, psychological_safety
  real :: accountability_reach, disconfirming_evidence, institutional_inertia
  real :: signal_distortion, memory_decay, defensive_routines
  real :: power_protection, feedback_delay, score

  feedback_quality = 84.0
  memory_retention = 78.0
  communication_openness = 76.0
  interpretive_quality = 80.0
  decision_revisability = 74.0
  psychological_safety = 77.0
  accountability_reach = 72.0
  disconfirming_evidence = 68.0
  institutional_inertia = 25.0
  signal_distortion = 22.0
  memory_decay = 18.0
  defensive_routines = 20.0
  power_protection = 24.0
  feedback_delay = 21.0

  score = 0.13 * feedback_quality + &
          0.12 * memory_retention + &
          0.12 * communication_openness + &
          0.12 * interpretive_quality + &
          0.12 * decision_revisability + &
          0.12 * psychological_safety + &
          0.10 * accountability_reach + &
          0.06 * disconfirming_evidence - &
          0.12 * institutional_inertia - &
          0.10 * signal_distortion - &
          0.08 * memory_decay - &
          0.08 * defensive_routines - &
          0.08 * power_protection - &
          0.07 * feedback_delay

  print *, "Institutional learning raw score:", score
end program institutional_learning_score
