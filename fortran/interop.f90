module interop
  use iso_c_binding
  implicit none

  interface
     function osl_foo_c(n, x, y) result(status) bind(c, name="osl_foo")
       use iso_c_binding
       integer(c_size_t), value :: n
       type(c_ptr), value :: x
       type(c_ptr), value :: y
       integer(c_int) :: status
     end function osl_foo_c
  end interface

contains

  function osl_foo(x, status) result(y)
    real(c_double), dimension(:), intent(in) :: x
    integer(c_int), intent(out), optional :: status
    integer(c_int) :: stat
    integer(c_size_t) :: n
    type(c_ptr) :: xp, yp

    real(c_double), dimension(size(x, 1)) :: y

    n = size(x, 1)
    xp = c_loc(x)
    yp = c_loc(y)
    stat = osl_foo_c(n, xp, yp)

    if (present(status)) then
       status = stat
    else
       if (status /= 0) then
          stop 'ERROR: unhandled error'
       end if
    end if
  end function osl_foo

end module interop


program main
  use interop
  implicit none

  integer, parameter :: n = 4
  real(c_double), dimension(n) :: x = [ 2, 4, 6 ]

  print *, x
  print *, osl_foo(x)
end program main
