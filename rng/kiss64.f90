! 64-bit KISS random number generator
!
! Original version posted to comp.lang.fortran by George Marsaglia:
! http://groups.google.com/group/comp.lang.fortran/msg/1e274596190aaf20
!
! This version was modified by Jason Blevins to use implicit none and
! to portably declare 64-bit/eight-byte integer type.

program test_kiss64
  implicit none
  integer, parameter :: i8b = selected_int_kind(18)  ! eight-byte integer
  integer(i8b) :: i, t

  do i = 1, 100000000
     t = kiss()
  end do

  if (t .eq. 1666297717051644203_i8b) then
     print *, "100 million calls to KISS() OK"
  else
     print *, "Fail"
  end if

contains

  function kiss64()
    integer(i8b), save :: x, y, z, c
    integer(i8b) :: t, k, m, s, kiss
    data x, y, z, c &
         / 1234567890987654321_i8b, &
           362436362436362436_i8b, &
           1066149217761810_i8b, &
           123456123456123456_i8b /
    m(x,k) = ieor(x, ishft(x,k))  ! statement function
    s(x) = ishft(x, -63)          ! statement function
    t = ishft(x, 58) + c
    if (s(x) .eq. s(t)) then
       c = ishft(x, -6) + s(x)
    else
       c = ishft(x, -6) + 1 - s(x + t)
    endif
    x = t + x
    y = m(m(m(y,13_i8b),-17_i8b), 43_i8b)
    z = 6906969069_i8b * z + 1234567
    kiss = x + y + z
  end function kiss64

end program test_kiss64
