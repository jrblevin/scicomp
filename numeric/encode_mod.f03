! encode_mod.f03 -- A module for encoding and decoding state vectors
! Copyright (C) 2008 Jason Blevins <jrblevin@sdf.lonestar.org>
!
! Description:
!
! This is a Fortran 2003 implementation of the "probability density"
! encoding algorithm presented in the following article:
!
!   Gowrisankaran, G. (1999). "Efficient representation of state
!   spaces for some dynamic models."  Journal of Economic Dynamics and
!   Control 23 (8), 1077-1098.
!
! This module implements an encoding of the state space $Z(N,M)$
! consisting of all discrete approximations to probability
! distributions on the interval $[0,1]$ with $N-1$ discrete regions
! and $N$ endpoints.  The mass assigned to any of these $N$ endpoints
! may take $M$ discrete values $0/(M-1), 1/(M-1), \dots, (M-1)/(M-1)$
! such that the elements sum to one.
!
! This encoding can be used, for example, to represent the space of
! all probability distributions or to represent the state space in a
! dynamic oligopoly model such as that of Ericson and Pakes (1995).
! In the dynamic oligopoly example, with $n$ firms and $L$ possible
! states, one can represent the state space using $Z(L,n+1)$.  The
! $k$-th element of the state vector then represents the fraction of
! firms in state $k$.
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

module encode_mod
  implicit none
  private

  public :: encode_init, encode_free
  public :: encode, decode
  public :: n_state

  integer, dimension(:,:), allocatable :: table   ! encoding table
  integer :: N_                                   ! number of endpoints
  integer :: M_                                   ! sum of values
  integer :: n_state                              ! number of states

contains

  ! Initializes the encoding table.
  subroutine encode_init(N, M)
    integer, intent(in) :: N, M
    integer :: i, j
    N_ = N
    M_ = M
    allocate(table(N,M))
    table(1,:) = 1
    table(:,1) = 1
    do i = 2, N
       do j = 2, M
          table(i,j) = table(i-1,j) + table(i, j-1)
       end do
    end do

    ! Cardinality of the state space (see Theorem 1, pg. 1084).
    n_state = table(N_, M_)
  end subroutine encode_init


  ! Frees memory used by the encoding table.
  subroutine encode_free
    deallocate(table)
  end subroutine encode_free

  ! Bijectively maps elements of the state space to integers from 0 to
  ! n_state - 1.
  function encode(x) result(enc)
    integer, dimension(N_), intent(in) :: x
    integer :: enc
    integer :: i, xsum, idx

    enc = 0
    xsum = 0
    do i = 1, N_
       idx = N_ - i + 1
       enc = enc + table(idx, M_ - xsum)
       xsum = xsum + x(i)
       enc = enc - table(idx, M_ - xsum)
    end do
  end function encode


  ! Bijectively maps the integers from 0 to n_state to vectors in the
  ! state space.
  function decode(ix) result(x)
    integer, intent(in) :: ix
    integer, dimension(N_) :: x
    integer :: digit, xsum, i, j, idx, code, enc

    x = 0
    code = ix
    xsum = 0
    do i = 1, N_
       idx = N_ - i + 1
       digit = 0

       ! Search for the largest valid digit that would result in an
       ! encoded value no larger the encoded value ix (see pg. 1088).
       do j = 1, M_ - 1 - xsum
          enc = table(idx, M_ - xsum) - table(idx, M_ - xsum - j)
          if (enc <= code) then
             digit = j
          end if
       end do

       ! Use the remainder of the encoded value to find the next digit.
       code = code - (table(idx, M_ - xsum) - table(idx, M_ - xsum - digit))
       x(i) = digit
       xsum = xsum + x(i)
    end do
  end function decode

end module encode_mod
