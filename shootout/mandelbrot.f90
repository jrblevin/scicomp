! The Computer Language Benchmarks Game
! http://shootout.alioth.debian.org/
!
! Contributed by Jason Blevins
! Adapted from mandelbrot.f90 by Simon Geard
!
! ifort -O3 -o mandelbrot mandelbrot.f90
program mandelbrot
  implicit none

  integer, parameter :: dp = selected_real_kind(15, 307)
  integer, parameter :: int8 = selected_int_kind(2)
  integer, parameter :: iter = 50
  real(dp), parameter :: limit2 = 4.0_dp
  character(len=8) :: argv
  integer :: w, h, x, y, i, bit_num = 8
  integer(int8) :: byte = 0_int8
  real(dp) :: inverse_w, inverse_h
  complex(dp) :: Z, C
  logical :: in_mandelbrot

  call get_command_argument(1,argv)
  read(argv, *) w
  h = w

  inverse_w = 2.0_dp / w
  inverse_h = 2.0_dp / h

  ! Output pbm header
  write(*,'(a)') 'P4'
  write(*,'(i0,a,i0)') w,' ',h

  do y = 0, h - 1
     do x = 0, w - 1
        bit_num = bit_num - 1

        C = cmplx(inverse_w*x-1.5_dp, inverse_h*y-1.0_dp, dp)
        Z = cmplx(0.0_dp, 0.0_dp, dp)
        in_mandelbrot = .true.
        do i = 1, iter
           Z = Z*Z + C
           if (real(Z*conjg(Z), dp) > limit2) then
              in_mandelbrot = .false.
              exit
           end if
        end do

        ! We're in the set, set this bit to 0
        if (in_mandelbrot) byte = ibset(byte, bit_num)

        if (bit_num == 0 .or. x == w - 1) then
           ! All bits set or end of row, so output bits
           write(*,'(a1)',advance='no') char(byte)
           byte = 0_int8
           bit_num = 8
        end if
     end do
  end do

end program mandelbrot
