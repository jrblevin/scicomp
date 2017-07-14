! normal_quad.f90 -- Gauss-Hermite integration of Normal expectation
!
! Copyright (C) 2011 Jason R. Blevins
! All rights reserved.
!
! Redistribution and use in source and binary forms, with or without
! modification, are permitted provided that the following conditions are met:
! 1. Redistributions of source code must retain the above copyright
!    notice, this list of conditions and the following disclaimer.
! 2. Redistributions in binary form must reproduce the above copyright
!    notice, this list of conditions and the following disclaimer in the
!    documentation  and/or other materials provided with the distribution.
! 3. Neither the names of the copyright holders nor the names of any
!    contributors may be used to endorse or promote products derived from
!    this software without specific prior written permission.
!
! THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
! AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
! IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
! ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
! LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
! CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
! SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
! INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
! CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
! ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
! POSSIBILITY OF SUCH DAMAGE.

program normal_quad
  implicit none

  ! Mathematical constants
  real, parameter :: SQRT2 = 1.4142135623730950488016887242096981
  real, parameter :: SQRTPI = 1.7724538509055160272981674833411452

  ! Order of quadrature
  integer, parameter :: n = 8

  ! Parameters of Normal distribution
  real, parameter :: mu = 2.0
  real, parameter :: sigma = 5.0

  ! Local variables
  real, dimension(:), allocatable :: x, w, z, zw
  real :: zwsum, int
  integer :: i

  ! Allocate memory
  allocate(x(n), w(n), z(n), zw(n))

  ! Set up Gauss-Hermite quadrature
  select case (n)
  case (3)

     x = [ -1.22474, 0.0,     1.22474  ]
     w = [ 0.295409, 1.18164, 0.295409 ]

  case (5)

     x = [ -2.02018287046, -0.958572464614, 0.0, 0.958572464614, 2.02018287046 ]
     w = [ 0.019953242059, 0.393619323152, 0.945308720483, 0.393619323152, 0.019953242059 ]

  case (8)

     x = [ -2.930637420257244, -1.981656756695843, -1.157193712446780, &
           -0.3811869902073221, 0.3811869902073221, 1.157193712446780, &
            1.981656756695843, 2.930637420257244 ]
     w = [ 0.000199604072211, 0.0170779830074, 0.207802325815, &
           0.661147012558, 0.661147012558, 0.207802325815, &
           0.0170779830074, 0.000199604072211 ]

  end select

  ! Transform weights and abscissas to approximate expectation of func
  ! with respect to Z \sim N(mu, sigma^2).
  z = mu + SQRT2 * sigma * x
  zw = w / SQRTPI
  zwsum = sum(zw)

  ! Perform quadrature
  int = 0.0
  do i = 1, n
     int = int + zw(i) * func(z(i))
  end do
  int = int / zwsum

  print *, 'E[func(Z)] with Z ~ N(mu, sigma^2) = ', int

  ! Deallocate memory
  deallocate(x, w, z, zw)

contains

  function func(z) result(f)
    real, intent(in) :: z
    real :: f
    f = (z - mu)**2
  end function func

end program normal_quad
