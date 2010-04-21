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
  character(len=8) :: argv
  integer :: n, x, y, i, j, pos
  integer(int8) :: byte
  real(dp) :: inv_2n, Zi, Zr, Ti, Tr, Cr, Ci
  integer(int8), dimension(:,:), allocatable :: buf

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

     do x = 0, n - 1, 8 ! ASSUMING DIVISIBLE BY 8

        byte = 0_int8

        do j = 0, 7

           Zr = 0.0_dp
           Zi = 0.0_dp
           Tr = 0.0_dp
           Ti = 0.0_dp

           Cr = inv_2n * (x + j) - 1.5_dp
           do i = 1, iter
              Zi = 2.0_dp * Zr * Zi + Ci
              Zr = Tr - Ti + Cr
              Ti = Zi * Zi
              Tr = Zr * Zr
              if (Tr + Ti > limit2) then
                 exit
              end if
           end do

           ! We're in the set, set this bit to 0
!           if (i > iter) byte = ibset(byte, 7 - j)
           byte = ishft(byte, 1)
           if (i > iter) then
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
