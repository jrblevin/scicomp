! The Great Computer Language Shootout
! http://shootout.alioth.debian.org/
!
! contributed by Jason Blevins
! based on the Fortran version by Steve Decker
! which is in turn based on the D version by Dave Fladebo
! revised for new specification
! compilation:
!    gfortran -O3 -fomit-frame-pointer fannkuch.f90
!    ifort -O3 -ipo -static fannkuch.f90

program fannkuch
  implicit none

  integer :: n
  character(len=2) :: argv

  call get_command_argument(1, argv)
  read (argv, *) n
  call do(n)

contains

  subroutine do(n)
    integer, intent(in) :: n

    integer :: i, r, flips, temp, j, k, max_flips = 0, curPerm = 1
    integer, dimension(n) :: perm, perm1, cnt

    ! Initialize permutation
    perm1 = (/ (i, i = 1, n) /)

    r = n + 1
    outer: do  ! For all n! permutations
       if (curPerm <= 30) then
          curPerm = curPerm + 1
          write(*,"(99(i0))") perm1
       end if

       do while (r > 2)
          cnt(r-1) = r
          r = r - 1
       end do

       if (perm1(1) > 1 .and. perm1(n) < n) then
          perm = perm1

          i = perm(1)
          flips = 0
          do while (i > 1)  ! Perform flips until first element is 1
             temp = perm(i)
             perm(i) = i
             i = temp
             j = 2; k = i - 1
             do while (j < k)
                temp = perm(j)
                perm(j) = perm(k)
                perm(k) = temp
                j = j + 1; k = k - 1
             end do
             flips = flips + 1  ! Count number of flips
          end do

          if (flips > max_flips) max_flips = flips
       end if

       do  ! Produce next permutation
          if (r == n+1) then
             write(*,"(2(a,i0))") "Pfannkuchen(", n, ") = ", max_flips
             exit outer
          end if

          temp = perm1(1)
          i = 1
          do while (i < r)
             j = i + 1
             perm1(i) = perm1(j)
             i = j
          end do
          perm1(r) = temp

          cnt(r) = cnt(r) - 1
          if (cnt(r) > 1) exit
          r = r + 1
       end do

    end do outer

  end subroutine do

end program fannkuch
