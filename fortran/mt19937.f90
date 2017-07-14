module mt19937
  implicit none

  ! integer precision constants
  integer, parameter :: int32 = selected_int_kind(9)

  ! Period parameters
  integer, parameter :: N = 624
  integer, parameter :: M = 397
  integer(int32), parameter :: MATRIX_A = z'9908b0df'   ! constant vector a
  integer(int32), parameter :: UPPER_MASK = z'80000000' ! most signif. w-r bits
  integer(int32), parameter :: LOWER_MASK = z'7fffffff' ! least signif. r bits

  ! Tempering parameters
  integer(int32), parameter :: TMASKB = z'9d2c5680'
  integer(int32), parameter :: TMASKC = z'efc60000'

  ! state
  integer(int32), dimension(N) :: mt ! the array for the state vector
  integer(int32) :: mti

  integer(int32), dimension(0:1), parameter :: mag01 = [ 0, MATRIX_A ]
  ! mag01(x) = x * MATRIX_A  for x=0,1

contains

  ! initializes mt[N] with a seed
  subroutine init_genrand(s)
    integer(int32), intent(in) :: s

    mt(1) = s
    do mti = 2, N
       mt(mti) = 1812433253 * ieor(mt(mti-1), ishft(mt(mti-1), -30)) + mti - 1
    end do
  end subroutine init_genrand

  ! generates a random number on [0,0xffffffff]-interval
  function genrand_int32() result(y)
    integer(int32) :: y
    integer :: kk

    ! generate N words at once
    if (mti >= N + 1) then
        do kk = 1, N - M
           y = ior(iand(mt(kk), UPPER_MASK), iand(mt(kk+1), LOWER_MASK))
           mt(kk) = ieor(ieor(mt(kk+M), ishft(y, -1)), mag01(iand(y,1)))
        end do
        do kk = N - M + 1, N - 1
           y = ior(iand(mt(kk), UPPER_MASK), iand(mt(kk+1), LOWER_MASK))
           mt(kk) = ieor(ieor(mt(kk + (M - N)), ishft(y, -1)), mag01(iand(y, 1)))
        end do
        y = ior(iand(mt(N), UPPER_MASK), iand(mt(1), LOWER_MASK))
        mt(N) = ieor(ieor(mt(M), ishft(y, -1)), mag01(iand(y, 1)))
        mti = 1
    end if

    y = mt(mti)

    ! Tempering
    y = ieor(y, ishft(y, -11))
    y = ieor(y, iand(ishft(y, 7), TMASKB))
    y = ieor(y, iand(ishft(y, 15), TMASKC))
    y = ieor(y, ishft(y, -18))

    mti = mti + 1
  end function genrand_int32

end module mt19937

program test
  use mt19937
  implicit none

  integer(int32), parameter :: init = 4357
  integer(int32), parameter :: shift = 2147483649
  integer(int32) :: u
  integer :: i

  call init_genrand(init)

  do i = 1, 100000
     u = genrand_int32()
  end do
  print '(i0)', u
  print '(b0.32)', u

  if (u /= 1275196716) then
     stop 'ERROR'
  end if
end program test
