! encode_test.f90 -- a test program for encode_mod
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

program encode_test
  use encode_mod
  implicit none

  integer :: N, M, n_test, count
  integer, dimension(:,:), allocatable :: x

  count = 0

  print "('Encode-decode tests',/,'===================',/)"

  ! Encode and decode several test vectors.  These are vectors of
  ! length N with elements in { 0, 1, ..., M-1 } such that the sum of
  ! all elements is M-1.

  ! Test 1
  N = 5
  M = 6+1
  n_test = 10
  allocate(x(n_test, N))
  x(1,:)  = (/ 6, 0, 0, 0, 0 /)
  x(2,:)  = (/ 0, 0, 0, 0, 6 /)
  x(3,:)  = (/ 2, 2, 1, 1, 0 /)
  x(4,:)  = (/ 1, 1, 2, 1, 1 /)
  x(5,:)  = (/ 1, 0, 0, 0, 5 /)
  x(6,:)  = (/ 5, 0, 0, 0, 1 /)
  x(7,:)  = (/ 0, 4, 2, 0, 0 /)
  x(8,:)  = (/ 4, 0, 0, 0, 2 /)
  x(9,:)  = (/ 0, 2, 2, 2, 0 /)
  x(10,:) = (/ 3, 3, 0, 0, 0 /)
  call run_tests(M, N, x)
  deallocate(x)

  ! Test 2
  N = 6
  M = 2+1
  n_test = 10
  allocate(x(n_test, N))
  x(1,:)  = (/ 1, 1, 0, 0, 0, 0 /)
  x(2,:)  = (/ 0, 1, 1, 0, 0, 0 /)
  x(3,:)  = (/ 0, 0, 1, 1, 0, 0 /)
  x(4,:)  = (/ 0, 0, 0, 1, 1, 0 /)
  x(5,:)  = (/ 0, 0, 0, 0, 1, 1 /)
  x(6,:)  = (/ 1, 0, 0, 0, 0, 1 /)
  x(7,:)  = (/ 1, 0, 0, 0, 1, 0 /)
  x(8,:)  = (/ 1, 0, 0, 1, 0, 0 /)
  x(9,:)  = (/ 1, 0, 1, 0, 0, 0 /)
  x(10,:) = (/ 0, 1, 0, 0, 0, 1 /)
  call run_tests(M, N, x)
  deallocate(x)

contains

  subroutine run_tests(M, N, tests)
    integer, intent(in) :: M, N
    integer, dimension(:,:) :: tests
    integer :: i, y
    integer, dimension(N) :: diff

    call encode_init(N, M)                          ! initialize the table

    do i = 1, size(tests, DIM=1)
       count = count + 1
       write (*, "('Test ', i3, '...')", advance="no") count

       y = encode(x(i,:))                           ! encode
       diff = x(i,:) - decode(y)                    ! difference (want zero)

       if (all(diff == 0)) then                     ! pass if difference is zero
          print *, "PASSED!"
       else
          print *, "FAILED!"
       end if
    end do

    call encode_free()                              ! free memory
  end subroutine run_tests

end program encode_test
