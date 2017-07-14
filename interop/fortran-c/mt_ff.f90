module mt_mod
  use iso_c_binding, only: c_long
  implicit none

  private
  public :: mt_state
  public :: mt_alloc
  public :: mt_free
  public :: mt_seed
  public :: mt_get
  public :: mt_i4b

  integer, parameter :: mt_i4b = c_long ! public
  integer, parameter :: i4b = mt_i4b    ! internal use

  integer, parameter :: N = 624
  integer, parameter :: M = 397

  integer(i4b), parameter :: MATRIX_A = -1727483681       ! 0x9908b0df
  integer(i4b), parameter :: UPPER_MASK = -2147483647 - 1 ! 0x80000000
  integer(i4b), parameter :: LOWER_MASK = 2147483647      ! 0x7fffffff
  integer(i4b), parameter :: TMASKB = -1658038656         ! 0x9d2c5680
  integer(i4b), parameter :: TMASKC = -272236544          ! 0xefc60000

  integer(i4b), dimension(0:1), parameter :: mag01 =&
       (/ 0_i4b, int(MATRIX_A, i4b) /)

  type :: mt_state
     private
     integer(i4b), dimension(N) :: mt
     integer(i4b) :: mti = N + 2
  end type mt_state

contains

  subroutine mt_alloc(state)
    type(mt_state), intent(inout) :: state
    call mt_seed(state, 4357_i4b)
  end subroutine mt_alloc

  subroutine mt_free(state)
    type(mt_state), intent(inout) :: state
    state%mti = N + 2
  end subroutine mt_free

  subroutine mt_seed(state, s)
    type(mt_state), intent(inout) :: state
    integer(i4b), intent(in) :: s
    integer :: mti

    state%mt(1) = s
    do mti = 2, N
       state%mt(mti) = 1812433253 &
            * ieor(state%mt(mti - 1), ishft(state%mt(mti - 1), -30)) &
            + mti - 1
    end do
    state%mti = N + 1
  end subroutine mt_seed

  function mt_get(state) result(y)
    type(mt_state), intent(inout) :: state
    integer(i4b) :: y
    integer :: kk

    ! generate N words at once
    if (state%mti >= N + 1) then
        do kk = 1, N - M
           y = ior(iand(state%mt(kk), UPPER_MASK), &
                   iand(state%mt(kk+1), LOWER_MASK))
           state%mt(kk) = ieor(ieor(state%mt(kk + M), ishft(y, -1_i4b)), &
                              mag01(iand(y, 1_i4b)))
        end do
        do kk = N - M + 1, N - 1
           y = ior(iand(state%mt(kk), UPPER_MASK), &
                   iand(state%mt(kk+1), LOWER_MASK))
           state%mt(kk) = ieor(ieor(state%mt(kk + (M - N)), ishft(y, -1_i4b)), &
                              mag01(iand(y, 1_i4b)))
        end do
        y = ior(iand(state%mt(N), UPPER_MASK), iand(state%mt(1), LOWER_MASK))
        state%mt(N) = ieor(ieor(state%mt(M), ishft(y, -1_i4b)), &
                           mag01(iand(y, 1_i4b)))
        state%mti = 1_i4b
    end if

    y = state%mt(state%mti)

    ! Tempering
    y = ieor(y, ishft(y, -11))
    y = ieor(y, iand(ishft(y, 7), TMASKB))
    y = ieor(y, iand(ishft(y, 15), TMASKC))
    y = ieor(y, ishft(y, -18))

    state%mti = state%mti + 1
  end function mt_get

end module mt_mod
