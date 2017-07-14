! The Computer Language Benchmarks Game
! http://shootout.alioth.debian.org/
!
! contributed by Jason Blevins
! based on the C version by Francesco Abbate
! and mem_pool.f90 from FLIBS by Arjen Markus
!
! ifort -fast -o binarytrees binarytrees.f90
module tree
  implicit none

  private

  public :: node, node_check, make
  public :: pool_initialize, pool_free, pool_acquire, pool_release

  integer, parameter :: NONE = -1
  integer, parameter :: chunk_size = 100
  logical, parameter :: release_asap = .true.

  type :: node
     integer :: item
     integer :: id
     integer :: index
     type(node), pointer :: left => null()
     type(node), pointer :: right => null()
  end type node

  type :: chunk_node
     integer :: id
     type(node), dimension(:), pointer :: data
     type(chunk_node), pointer :: next => null()
  end type chunk_node

  integer, dimension(:,:), pointer :: stack
  integer :: stack_index
  type(chunk_node), pointer :: chunk_list

contains

  ! Initializes the memory pool with a single chunk.
  subroutine pool_initialize
    allocate(stack(chunk_size, 2))
    stack_index = 0
    call pool_add_chunk()
  end subroutine pool_initialize

  ! Frees the memory pool
  subroutine pool_free
    deallocate(stack)
  end subroutine pool_free

  subroutine stack_grow
    integer, dimension(:,:), pointer :: temp
    integer :: i
    allocate(temp(size(stack,1)+chunk_size, 2))
    do i = 1, size(stack,1)
       temp(i,1) = stack(i,1)
       temp(i,2) = stack(i,2)
    end do
    deallocate(stack)
    stack => temp
  end subroutine stack_grow

  subroutine stack_pop(id, index)
    integer, intent(out) :: id, index
    if (stack_index > 0) then
       id = stack(stack_index, 1)
       index = stack(stack_index, 2)
       stack_index = stack_index - 1
    else
       id = NONE
       index = NONE
    end if
  end subroutine stack_pop

  subroutine stack_push(id, index)
    integer, intent(in) :: id, index
    if (stack_index == size(stack,1)) then
       call stack_grow()
    end if
    stack_index = stack_index + 1
    stack(stack_index, 1) = id
    stack(stack_index, 2) = index
  end subroutine stack_push

  subroutine pool_acquire(node_p)
    type(node), pointer :: node_p
    type(chunk_node), pointer :: cur
    integer :: id, index

    call stack_pop(id, index)
    if (id == NONE) then
       call pool_add_chunk()
       call stack_pop(id, index)
    end if

    print '(a,i0)', 'pool_acquire: searching for id ', id
    cur => chunk_list
    do while (cur%id /= id)
       print '(a,i0)', 'skipping ', cur%id
       cur => cur%next
    end do
    print '(a,i0)', 'stopped at ', cur%id
    print '(a,i0)', 'index ', index
    node_p => cur%data(index)
    node_p%id = id
    node_p%index = index
  end subroutine pool_acquire

  subroutine pool_release(node_p)
    type(node), pointer :: node_p
    call stack_push(node_p%id, node_p%index)
    nullify(node_p)
  end subroutine pool_release

  ! Adds a new chunk to the memory pool, expanding the CHUNK array
  ! with one extra useable array of node data.
  subroutine pool_add_chunk()
    type(chunk_node), pointer :: cur
    integer :: id, index

    print '(a)', 'adding chunk'

    id = 1
    if (.not. associated(chunk_list)) then
       allocate(chunk_list)
       cur => chunk_list
       cur%id = id
    else
       cur => chunk_list
       do while (associated(cur%next))
          id = id + 1
          cur => cur%next
       end do
       allocate(cur%next)
       cur => cur%next
       cur%id = id
    end if

    allocate(cur%data(chunk_size))
    nullify(cur%next)

    do index = chunk_size, 1, -1
       call stack_push(id, index)
    end do
  end subroutine pool_add_chunk

  recursive function node_check(n) result(check)
    type(node), pointer :: n
    integer :: check

    if (associated(n%left)) then
       check = n%item + node_check(n%left) - node_check(n%right)
    else
       check = n%item
    end if
    call pool_release(n)
  end function node_check

  recursive subroutine make(item, depth, n)
    integer, intent(in) :: item, depth
    type(node), pointer :: n

    call pool_acquire(n)
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

  ! initialize memory pool
  call pool_initialize()

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

  call pool_free()
end program binarytrees
