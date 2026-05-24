program cognitive_bias_score
  implicit none

  real :: overconfidence, conformity_pressure, filtering_distortion
  real :: path_lock_in, metric_tunnel_vision, power_protection
  real :: dissent_capacity, corrective_review, information_quality
  real :: feedback_openness, psychological_safety, justice_voice
  real :: score

  overconfidence = 22.0
  conformity_pressure = 25.0
  filtering_distortion = 24.0
  path_lock_in = 28.0
  metric_tunnel_vision = 20.0
  power_protection = 21.0
  dissent_capacity = 82.0
  corrective_review = 80.0
  information_quality = 84.0
  feedback_openness = 78.0
  psychological_safety = 76.0
  justice_voice = 72.0

  score = 0.14 * dissent_capacity + &
          0.14 * corrective_review + &
          0.14 * information_quality + &
          0.13 * feedback_openness + &
          0.11 * psychological_safety + &
          0.10 * justice_voice - &
          0.13 * overconfidence - &
          0.13 * conformity_pressure - &
          0.14 * filtering_distortion - &
          0.12 * path_lock_in - &
          0.10 * metric_tunnel_vision - &
          0.09 * power_protection

  print *, "Institutional decision quality raw score:", score
end program cognitive_bias_score
