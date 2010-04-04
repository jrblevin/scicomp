! binenc_mod.f03 -- A Binomial-coefficient-based state encoding algorithm
!
! Copyright (C) 2008 Jason Blevins <jrblevin@sdf.lonestar.org>
! All rights reserved.
!
! This software may be modified and distributed under the terms
! of the BSD license.  See the LICENSE file for details.
!
! Description:
!
! This is a Fortran 2003 implementation of the Binomial coefficient
! based state vector encoding method described in Section 3 of the
! paper
!
!   Pakes A., G. Gowrisankaran, and P. McGuire (1993).  "Implementing
!   the Pakes-McGuire Algorithm for Computing Markov Perfect
!   Equilibria in Gauss."  Mimeo, Yale University.
!
! This algorithm implements a bijective mapping from the state space
! $\mathcal X$ of all vectors $x$ of length $N$ where each component
! of $x$ may take the values $0, 1, \dots, M$ and where the components
! are sorted in descending order: $x_1 \ge x_2 \ge \dots \ge x_n$.
! The encode function maps $x$ to an integer between 1 and
! $o(\mathcal X)$ while the decode function implements the inverse
! mapping.
!
! Caveats:
!
! It is important that the state vector be sorted before calling
! encode.  This code is intended as an example and as such no error
! checking is performed.

module binenc_mod
implicit none

  private
  public :: binenc_init, binenc_free
  public :: encode, decode
  public :: n_state

  ! Binomial coefficient matrix
  integer, allocatable, dimension(:,:) :: binom

  integer :: n_state
  integer :: N_
  integer :: M_

contains

  ! Allocate memory and initialize the Binomial coefficient matrix
  ! used for encoding and decoding.
  subroutine binenc_init(N, M)
    integer, intent(in) :: N, M
    integer :: i

    ! Store the dimensions
    N_ = N
    M_ = M

    ! Allocate memory for storing Binomial coefficients.
    allocate(binom(N + M + 1, N + M + 2))

    ! Generate the matrix of binomial coefficients to use for encoding
    ! and decoding market structures.
    binom = 0

    ! Upper-diagonal entries are 1.
    do i = 1, N + M + 1
       binom(i,i+1) = 1
    end do

    ! Construct the binomial coefficients.
    do i = 2, N + M + 1
       binom(i,2:i) = binom(i-1,2:i) + binom(i-1,1:i-1)
    end do

    ! Get the number of states (See Claim 1 on page 26 of Pakes,
    ! Gowrisankaran, and McGuire, 1993).
    n_state = binom(N + M + 1, N + 2)
  end subroutine binenc_init


  ! Free allocated memory
  subroutine binenc_free
    deallocate(binom)
  end subroutine binenc_free


  ! Implements a bijective mapping taking vectors in the state space
  ! to the integers between 0 and n_state.  The vector x must be
  ! sorted in decreasing order (e.g., [ 5, 5, 4, 2, 0 ] ).
  function encode(x) result(ix)
    integer, dimension(N_), intent(in) :: x
    integer :: ix
    integer :: n

    ix = 1
    do n = 1, N_
       ix = ix + binom(x(n) + N_ + 1 - n, x(n) + 1)
    end do
  end function encode


  ! Bijectively maps the integers from 0 to n_state to vectors in the
  ! state space.
  function decode(ix) result(x)
    integer, intent(in) :: ix
    integer, dimension(N_) :: x
    integer :: digit, n, code

    code = ix - 1
    do n = 1, N_
       digit = 0
       do while (binom(digit + N_ - n + 2, digit + 2) <= code)
          digit = digit + 1
       end do

       x(n) = digit
       code = code - binom(digit + N_ - n + 1, digit + 1)
    end do
  end function decode

end module binenc_mod
