! The Computer Language Benchmarks Game
! http://shootout.alioth.debian.org/
!
! Contributed by Jason Blevins
! Adapted from Fortran versions by George R. Gonzalez and Simon Geard
!
! ifort -fast -openmp -o mandelbrot mandelbrot.f90
program mandelbrot
  implicit none

  integer, parameter :: dp = selected_real_kind(15, 307)
  integer, parameter :: int8 = selected_int_kind(2)
  integer, parameter :: iter = 50
  real(dp), parameter :: limit2 = 4.0_dp
  integer, dimension(8), parameter :: incr = (/ 0, 1, 2, 3, 4, 5, 6, 7 /)
  real(dp), dimension(8) :: Zi, Zr, Ti, Tr, Cr, Ci
  integer(int8), dimension(:,:), allocatable :: buf
  character(len=8) :: argv
  integer :: n, x, y, i, pos
  integer(int8) :: byte
  real(dp) :: inv_2n

  ! read dimension from command line
  call get_command_argument(1, argv)
  read(argv, *) n

  ! allocate output buffer
  allocate(buf(ceiling(n / 8.0_dp), n))

  ! precalculate constants
  inv_2n = 2.0_dp / n

  ! pbm header
  write(*,'("P4",/,i0," ",i0)') n, n

  !$OMP PARALLEL DO DEFAULT(PRIVATE) SHARED(n, inv_2n, buf)
  do y = 0, n - 1
     pos = 0
     Ci = inv_2n * y - 1.0_dp

     do x = 0, n - 1, 8

        Zr = 0.0_dp
        Zi = 0.0_dp
        Tr = 0.0_dp
        Ti = 0.0_dp

        Cr = inv_2n * (x + incr) - 1.5_dp

        do i = 1, iter
           Zi = 2.0_dp * Zr * Zi + Ci
           Zr = Tr - Ti + Cr
           Ti = Zi * Zi
           Tr = Zr * Zr
        end do

        do i = 1, 8
           byte = ishft(byte, 1)
           if (Tr(i) + Ti(i) < limit2) then
              byte = ior(byte, 1)
           end if
        end do

        pos = pos + 1
        buf(pos, y + 1) = byte

     end do

  end do
  !$OMP END PARALLEL DO

  ! print output
  do y = 1, n
     write(*, '(10000000a1)', advance='no') buf(:, y)
  end do
  deallocate(buf)
end program mandelbrot
