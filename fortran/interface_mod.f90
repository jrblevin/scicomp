! A module containing function interfaces
module interfaces
  implicit none

  abstract interface
     real function func(x)
       real :: x
     end function func
  end interface

end module interfaces

! A module containing a function which implements func
module functions
  implicit none

contains

  real function square(x)
    real :: x
    square = x*x
  end function square

end module functions

! A simple control program showing how to use the func interface
program main
  use interfaces
  use functions
  implicit none

  call print_func(square)

contains

  subroutine print_func(f)
    procedure(func) :: f
    print *, f(0.0)
  end subroutine print_func

end program main
