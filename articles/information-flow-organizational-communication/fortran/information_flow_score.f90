program information_flow_score
  implicit none

  real :: signal_quality, communication_quality, interpretive_integration
  real :: feedback_usability, memory_retention, openness, escalation_access
  real :: trust, community_voice, digital_transparency, distortion_loss
  real :: overload, siloing, suppression_pressure, metric_tunnel_vision
  real :: score

  signal_quality = 84.0
  communication_quality = 78.0
  interpretive_integration = 80.0
  feedback_usability = 76.0
  memory_retention = 74.0
  openness = 77.0
  escalation_access = 72.0
  trust = 75.0
  community_voice = 70.0
  digital_transparency = 73.0
  distortion_loss = 24.0
  overload = 28.0
  siloing = 22.0
  suppression_pressure = 20.0
  metric_tunnel_vision = 26.0

  score = 0.12 * signal_quality + &
          0.12 * communication_quality + &
          0.12 * interpretive_integration + &
          0.11 * feedback_usability + &
          0.10 * memory_retention + &
          0.11 * openness + &
          0.09 * escalation_access + &
          0.08 * trust + &
          0.07 * community_voice + &
          0.07 * digital_transparency - &
          0.12 * distortion_loss - &
          0.09 * overload - &
          0.08 * siloing - &
          0.08 * suppression_pressure - &
          0.07 * metric_tunnel_vision

  print *, "Information flow raw score:", score
end program information_flow_score
