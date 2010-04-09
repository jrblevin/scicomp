! The Computer Language Benchmarks Game
! http://shootout.alioth.debian.org/
!
! contributed by Jason Blevins
! based on the C version by Francesco Abbate
!
! ifort -O3 -o binarytrees binarytrees.f90
module tree
  implicit none

  type :: node
     integer :: item
     type(node), pointer :: left => null()
     type(node), pointer :: right => null()
  end type node

contains

  recursive function node_check(n) result(check)
    type(node), pointer :: n
    integer :: lc, rc, check

    if (associated(n%left)) then
       check = n%item + node_check(n%left) - node_check(n%right)
    else
       check = n%item
    end if
    deallocate(n)
  end function node_check

  recursive subroutine make(item, depth, n)
    integer, intent(in) :: item, depth
    type(node), pointer :: n

    allocate(n)
    n%item = item

    if (depth > 0) then
       call make(2*item-1, depth-1, n%left)
       call make(2*item, depth-1, n%right)
    else
       nullify(n%left)
       nullify(n%right)
    end if
  end subroutine make

end module tree

program binarytrees
  use tree
  implicit none

  character, parameter :: tab = achar(9)
  integer, parameter :: min_depth = 4
  integer :: req_depth, max_depth, stretch_depth
  integer :: check, depth, i, iterations
  type(node), pointer :: stretch, long_lived, a, b
  character(len=8) :: arg

  call get_command_argument(1, arg)
  read(arg, *) req_depth
  max_depth = max(min_depth + 2, req_depth)
  stretch_depth = max_depth + 1

  ! stretch tree
  call make(0, stretch_depth, stretch)
  print '(2(a,i0))', 'stretch tree of depth ', stretch_depth, &
       tab // ' check: ', node_check(stretch)

  ! allocate long lived tree
  call make(0, max_depth, long_lived)

  ! bottom-up trees
  do depth = min_depth, max_depth, 2
     iterations = 2**(max_depth - depth + min_depth)
     check = 0
     do i = 1, iterations
        call make(i, depth, a)
        check = check + node_check(a)
        call make(-i, depth, b)
        check = check + node_check(b)
     end do
     print '(2(i0,a),i0)', iterations*2, tab // ' trees of depth ', &
          depth, tab // ' check: ', check
  end do

  ! deallocate long lived tree
  print '(2(a,i0))', 'long lived tree of depth ', max_depth, &
       tab // ' check: ', node_check(long_lived)
end program binarytrees
