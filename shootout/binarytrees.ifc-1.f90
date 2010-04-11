! -*- mode: f90 -*-
!
! $Id: binarytrees.1.ifc.code,v 1.5 2010-02-20 19:34:17 igouy-guest Exp $ ; $Name:  $
!
! The Computer Language Shootout Benchmarks
! http://shootout.alioth.debian.org/

! contributed by Steve Decker
! based on the C version by Kevin Carson
! compilation:
!    gfortran -O3 -fomit-frame-pointer -funroll-loops binarytrees.f90
!
! This implementation does not need TR15581
!
module b_tree
  implicit none
  save

  integer, parameter :: short = selected_int_kind(1)

  type treeNode
     integer :: item
     type(treeNode), pointer :: left
     type(treeNode), pointer :: right
  end type treeNode

contains

  subroutine NewTreeNode(left, right, item, node)
    type(treeNode), target, intent(in) :: left, right
    integer, intent(in) :: item
    type(treeNode), pointer :: node

    allocate(node)
    node = treeNode(item, left, right)
  end subroutine NewTreeNode

  recursive function ItemCheck(tree) result (check)
    type(treeNode), pointer :: tree
    integer :: check

    if (.not. associated(tree%left)) then
       check = tree%item
    else
       check = tree%item + ItemCheck(tree%left) - ItemCheck(tree%right)
    end if
    deallocate(tree)
  end function ItemCheck

  recursive subroutine BottomUpTree(item, depth, node)
    integer, intent(in) :: item
    integer(kind=short), intent(in) :: depth
    type(treeNode), pointer :: node

    type(treeNode), pointer :: left, right

    nullify(left, right)

    if (depth > 0) then
       call BottomUpTree(2 * item - 1, depth - 1_short, left)
       call BottomUpTree(2 * item, depth - 1_short, right)
    end if
    call NewTreeNode(left, right, item, node)
  end subroutine BottomUpTree
end module b_tree

program binarytrees
  use b_tree
  implicit none

  integer(kind=short), parameter :: minDepth = 4_short
  character,           parameter :: tab = achar(9)

  integer :: i, iterations, check
  integer(kind=short) :: N, depth, maxDepth, stretchDepth
  character(len=2) :: argv
  type(treeNode), pointer :: stretchTree => null(), longLivedTree => null(),  &
                             tempTree => null()

  call get_command_argument(1, argv)
  read (argv, "(i2)") N

  maxDepth = max(minDepth + 2_short, N)

  stretchDepth = maxDepth + 1_short
  call BottomUpTree(0, stretchDepth, stretchTree)
  write(*,"(2(a,i0))") "stretch tree of depth ", stretchDepth,  &
       tab//" check: ", ItemCheck(stretchTree)

  call BottomUpTree(0, maxDepth, longLivedTree)

  do depth = minDepth, maxDepth, 2
     iterations = 2**(maxDepth - depth + minDepth)
     check = 0
     do i = 1, iterations
        call BottomUpTree(i, depth, tempTree)
        check = check + ItemCheck(tempTree)

        call BottomUpTree(-i, depth, tempTree)
        check = check + ItemCheck(tempTree)
     end do
     write(*,"(2(i0,a),i0)") iterations*2, tab//" trees of depth ", depth,  &
          tab//" check: ", check
  end do

  write(*,"(2(a,i0))") "long lived tree of depth ", maxDepth,  &
       tab//" check: ", ItemCheck(longLivedTree)
end program binarytrees
