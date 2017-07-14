! poly_bench.f90 -- simple polymorphism performance comparison
!
! Copyright (C) 2010 Jason R. Blevins
! All rights reserved.
!
! This software may be modified and distributed under the terms of the
! BSD license.  See the LICENSE file for details.
!
! Description:
!
! This benchmark seeks to compare the performance of two types of
! polymorphism in Fortran.  The first is Fortran 90
! "pseudo-polymorphism" implemented by an integer type variable and
! select type constructs which call the appropriate procedures for
! each type.  The second type is polymorphism through a Fortran 90
! generic interface in which the appropriate routines are
! automatically selected based on the type at runtime.

module pseudo_counter
  implicit none

  private

  public :: PSEUDO_COUNTER_TYPE_1
  public :: PSEUDO_COUNTER_TYPE_2
  public :: pseudo_counter_t
  public :: pseudo_counter_increment
  public :: pseudo_counter_set_type

  integer, parameter :: PSEUDO_COUNTER_TYPE_1 = 1
  integer, parameter :: PSEUDO_COUNTER_TYPE_2 = 2

  type :: pseudo_counter_t
     integer :: type = PSEUDO_COUNTER_TYPE_1
     integer :: count = 0
  end type pseudo_counter_t

contains

  subroutine pseudo_counter_set_type(self, type)
    type(pseudo_counter_t), intent(inout) :: self
    integer, intent(in) :: type
    self%type = type
  end subroutine pseudo_counter_set_type

  subroutine pseudo_counter_increment(self)
    type(pseudo_counter_t), intent(inout) :: self
    select case (self%type)
    case (PSEUDO_COUNTER_TYPE_1)
       call pseudo_counter_increment_1(self)
    case (PSEUDO_COUNTER_TYPE_2)
       call pseudo_counter_increment_2(self)
    end select
  end subroutine pseudo_counter_increment

  subroutine pseudo_counter_increment_1(self)
    type(pseudo_counter_t), intent(inout) :: self
    self%count = self%count * 2
    self%count = self%count / 2
    self%count = self%count + 1
  end subroutine pseudo_counter_increment_1

  subroutine pseudo_counter_increment_2(self)
    type(pseudo_counter_t), intent(inout) :: self
    self%count = self%count * 2
    self%count = self%count / 2
    self%count = self%count + 2
  end subroutine pseudo_counter_increment_2

end module pseudo_counter


module ext_poly
  implicit none

  type :: ext_counter_t
     integer :: count = 0
  end type ext_counter_t

  type, extends(ext_counter_t) :: ext_counter_1_t
  end type ext_counter_1_t

  type, extends(ext_counter_t) :: ext_counter_2_t
  end type ext_counter_2_t

  interface ext_counter_increment
     module procedure ext_counter_1_increment
     module procedure ext_counter_2_increment
  end interface ext_counter_increment

contains

  subroutine ext_counter_1_increment(self)
    type(ext_counter_1_t), intent(inout) :: self
    self%count = self%count * 2
    self%count = self%count / 2
    self%count = self%count + 1
  end subroutine ext_counter_1_increment

  subroutine ext_counter_2_increment(self)
    type(ext_counter_2_t), intent(inout) :: self
    self%count = self%count * 2
    self%count = self%count / 2
    self%count = self%count + 2
  end subroutine ext_counter_2_increment

end module ext_poly


program poly_bench
  use pseudo_counter
  use ext_poly
  implicit none

  integer, parameter :: n = 100000000
  integer :: i
  real :: t1, t2, pseudo_time, ext_time

  type(pseudo_counter_t) :: pseudo_1
  type(pseudo_counter_t) :: pseudo_2
  type(ext_counter_1_t) :: ext_1
  type(ext_counter_2_t) :: ext_2

  ! Initialize pseudo-polymorphic counters
  call pseudo_counter_set_type(pseudo_1, PSEUDO_COUNTER_TYPE_1)
  call pseudo_counter_set_type(pseudo_2, PSEUDO_COUNTER_TYPE_2)

  ! increment both pseudo-polymorphic counters n times
  call cpu_time(t1)
  do i = 1, n
     call pseudo_counter_increment(pseudo_1)
     call pseudo_counter_increment(pseudo_2)
  end do
  call cpu_time(t2)
  pseudo_time = t2 - t1

  ! increment both type-extension-polymorphic counters n times
  call cpu_time(t1)
  do i = 1, n
     call ext_counter_increment(ext_1)
     call ext_counter_increment(ext_2)
  end do
  call cpu_time(t2)
  ext_time = t2 - t1

  print '("ext:    ", g17.5, " sec.")', ext_time
  print '("pseudo: ", g17.5, " sec.")', pseudo_time
end program poly_bench
