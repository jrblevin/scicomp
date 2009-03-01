program memleak
  implicit none

  call foo()

contains

  subroutine foo
    integer, dimension(:), allocatable :: x

    allocate(x(10))

    x(11) = 0         ! heap block overrun
    return            ! x not deallocated
  end subroutine foo

end program memleak
