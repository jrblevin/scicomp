! encode_test.f03 -- A test program for encode_mod.f03
! Copyright (C) 2008 Jason Blevins <jrblevin@sdf.lonestar.org>
!
! Description:
!
! A short program which tests for correctness of the encoding
! algorithm by encoding and decoding several state vectors and
! checking for differences.  It also prints the full encoding table.
!
! License:
!
! This program is free software: you can redistribute it and/or modify
! it under the terms of the GNU General Public License as published by
! the Free Software Foundation, either version 3 of the License, or
! (at your option) any later version.
!
! This program is distributed in the hope that it will be useful,
! but WITHOUT ANY WARRANTY; without even the implied warranty of
! MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
! GNU General Public License for more details.
!
! You should have received a copy of the GNU General Public License
! along with this program.  If not, see <http://www.gnu.org/licenses/>.

program encode_test
  use encode_mod
  implicit none

  integer, parameter :: N = 5
  integer, parameter :: M = 6+1
  integer, parameter :: ntest = 10

  integer, dimension(ntest,N) :: x
  integer, dimension(N) :: diff
  integer :: i, y

  print "('Encode-decode tests',/,'===================',/)"

  ! Encode and decode several test vectors.  These are vectors of
  ! length N with elements in [ 0, 1, ..., M-1 ] such that the sum of
  ! all elements is M-1.
  x(1,:)  = [ 6, 0, 0, 0, 0 ]
  x(2,:)  = [ 0, 0, 0, 0, 6 ]
  x(3,:)  = [ 2, 2, 1, 1, 0 ]
  x(4,:)  = [ 1, 1, 2, 1, 1 ]
  x(5,:)  = [ 1, 0, 0, 0, 5 ]
  x(6,:)  = [ 5, 0, 0, 0, 1 ]
  x(7,:)  = [ 0, 4, 2, 0, 0 ]
  x(8,:)  = [ 4, 0, 0, 0, 2 ]
  x(9,:)  = [ 0, 2, 2, 2, 0 ]
  x(10,:) = [ 3, 3, 0, 0, 0 ]

  call encode_init(N, M)                          ! initialize the table

  do i = 1, ntest
     write (*, "('Test ', i2, '...')", advance="no") i

     y = encode(x(i,:))                           ! encode
     diff = x(i,:) - decode(y)                    ! difference (want zero)

     if (all(diff == 0)) then                     ! pass if difference is zero
        print *, "PASSED!"
     else
        print *, "FAILED!"
     end if
  end do

  ! Print the encoding table
  print "(/,'Encoding table',/,'==============',/)"
  do i = 0, n_state - 1
     diff = decode(i)
     print '(6i4)', diff
  end do

  call encode_free()                              ! free memory

end program encode_test
