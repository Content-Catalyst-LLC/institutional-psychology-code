program institutional_resilience
  implicit none

  integer :: t
  real :: functioning
  real, parameter :: baseline = 0.80
  real, parameter :: recovery = 0.09
  real, parameter :: learning = 0.07
  real, parameter :: fragmentation = 0.04

  functioning = 0.42

  print *, "Time", "InstitutionalFunctioning"

  do t = 1, 20
     functioning = functioning + recovery * (baseline - functioning) + learning - fragmentation
     if (functioning > 1.0) functioning = 1.0
     if (functioning < 0.0) functioning = 0.0
     print *, t, functioning
  end do

end program institutional_resilience
