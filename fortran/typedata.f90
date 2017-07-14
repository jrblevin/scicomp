module typedata

  integer, parameter :: n = 5
  integer, parameter :: m = 10

  type :: base
     real, dimension(:), allocatable :: dat
  end type base

  type, extends(base) :: extension
     real, dimension(m) :: dat
  end type extension

end module typedata


program test_typedata
  use typedata
  implicit none

  type(base) :: foo
  type(base) :: bar

  print *, 'size(foo%dat) = ', size(foo%dat)
  print *, 'size(bar%dat) = ', size(bar%dat)

end program test_typedata
