! Example illustrating how subtracting the minimum in a log-sum-exp
! routine can result in overflow, while subtracting the maximum
!
! Jason R. Blevins <jrblevin@sdf.org>
! Columbus, February 5, 2013
program log_sum_exp_test
  implicit none

  real, dimension(3) :: v = (/ -100.0, -200.0, -300.0 /)
  real :: max, min

  max = maxval(v)
  min = minval(v)

  print *, 'No centering:'
  print *, 'v =                            ', v
  print *, 'exp(v) =                       ', exp(v)
  print *, 'sum(exp(v)) =                  ', sum(exp(v))
  print *, 'log(sum(exp(v))) =             ', log(sum(exp(v)))
  print *, ''
  print *, 'Subtracting the maximum:'
  print *, 'v - max =                      ', v - max
  print *, 'exp(v - max) =                 ', exp(v - max)
  print *, 'sum(exp(v - max)) =            ', sum(exp(v - max))
  print *, 'log(sum(exp(v - max))) + max = ', log(sum(exp(v - max))) + max
  print *, ''
  print *, 'Subtracting the minimum:'
  print *, 'v - min =                      ', v - min
  print *, 'exp(v - min) =                 ', exp(v - min)
  print *, 'sum(exp(v - min)) =            ', sum(exp(v - min))
  print *, 'log(sum(exp(v - min))) + min = ', log(sum(exp(v - min))) + min
end program log_sum_exp_test
