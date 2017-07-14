program bench
  use mt_mod
  implicit none

  integer, parameter :: i4b = mt_i4b
  integer, parameter :: i8b = selected_int_kind(18)
  integer(i8b), parameter :: N = 1000000000
  type(mt_state) :: mt
  real :: start, end, time
  integer :: i, ints, u
 
  call mt_alloc(mt)
  call mt_seed(mt, 4357_i4b)

  call cpu_time(start)
  do i = 1, N
     u = mt_get(mt)
  end do
  call cpu_time(end)

  time = (end - start)
  ints = N / time
  print '(a, i0)', "32-bit integers per second: ", ints
  print '(a, i0)', "last: ", u
  call mt_free(mt)
end program bench
