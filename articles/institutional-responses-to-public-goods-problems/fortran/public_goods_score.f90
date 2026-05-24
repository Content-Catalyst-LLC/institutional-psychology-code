program public_goods_score
  implicit none

  real :: contribution_rate, legitimacy, trust, coordination, monitoring
  real :: distributional_attention, scale_complexity, capture_risk
  real :: score

  contribution_rate = 70.0
  legitimacy = 78.0
  trust = 75.0
  coordination = 72.0
  monitoring = 80.0
  distributional_attention = 74.0
  scale_complexity = 35.0
  capture_risk = 25.0

  score = 0.22 * contribution_rate + &
          0.13 * legitimacy + &
          0.12 * trust + &
          0.11 * coordination + &
          0.10 * monitoring + &
          0.08 * distributional_attention - &
          0.12 * scale_complexity - &
          0.08 * capture_risk

  print *, "Public goods provision raw score:", score
end program public_goods_score
