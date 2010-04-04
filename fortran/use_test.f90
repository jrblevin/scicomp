! use_test.f90 -- testing multi-level use statements
!
! This is a test program to answer the following question: If bar_mod
! uses foo_mod, do we get access to the public symbols of foo_mod when
! we use bar_mod?
!
! The answer is: yes.
!
! % gfortran -o use_test use_test.f90
! % ./use_test
!  foo:   3.1415999    
!  bar:   2.7183001

module foo_mod
  implicit none

  real, parameter :: foo = 3.1416
end module foo_mod

module bar_mod
  use foo_mod
  implicit none

  real, parameter :: bar = 2.7183
end module bar_mod

program use_test
  use bar_mod
  implicit none

  print *, 'foo:', foo
  print *, 'bar:', bar
end program use_test
