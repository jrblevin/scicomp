! binenc_test.f03 -- A test program for binenc_mod.f03
!
! Copyright (C) 2008 Jason Blevins <jrblevin@sdf.lonestar.org>
! All rights reserved.
!
! This software may be modified and distributed under the terms
! of the BSD license.  See the LICENSE file for details.
!
! Description:
!
! A short program which tests for correctness of the encoding
! algorithm by encoding and decoding several state vectors and
! checking for differences.  It also prints the full encoding table.

program binenc_test
  use binenc_mod
  implicit none

  integer, parameter :: N = 5
  integer, parameter :: M = 6
  integer, parameter :: ntest = 10

  integer, dimension(ntest,N) :: x
  integer, dimension(N) :: diff
  integer :: i, y

  print "('Encode-decode tests',/,'===================',/)"

  ! Encode and decode several test vectors.  These are sorted vectors
  ! of length N with elements in [ 0, 1, ..., M ].
  x(1,:)  = [ 0, 0, 0, 0, 0 ]
  x(2,:)  = [ 6, 6, 6, 6, 6 ]
  x(3,:)  = [ 2, 2, 1, 1, 0 ]
  x(4,:)  = [ 1, 1, 1, 1, 0 ]
  x(5,:)  = [ 6, 0, 0, 0, 0 ]
  x(6,:)  = [ 5, 4, 3, 2, 1 ]
  x(7,:)  = [ 6, 4, 4, 4, 0 ]
  x(8,:)  = [ 4, 0, 0, 0, 0 ]
  x(9,:)  = [ 6, 6, 2, 2, 0 ]
  x(10,:) = [ 3, 3, 1, 0, 0 ]

  call binenc_init(N, M)                          ! initialize the table

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
  do i = 0, n_state
     diff = decode(i)
     print '(6i4)', diff
  end do

  call binenc_free()                              ! free memory

end program binenc_test
