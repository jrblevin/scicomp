program real_kinds
  use iso_c_binding
  implicit none

  print '("kind(0.d0)  ",i2)', kind(0.d0)
  print '("c_double    ",i2)', c_double
end program real_kinds
