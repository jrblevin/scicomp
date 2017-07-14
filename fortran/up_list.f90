module flist
  implicit none

  type :: flist_node_t
     private
     class(*), pointer :: p
     type(flist_node_t), pointer :: next
  end type flist_node_t

  type :: flist_t
     type(flist_node_t), pointer :: head => null()
     type(flist_node_t), pointer :: tail => null()
  end type flist_t

contains

  subroutine flist_init(self)
    type(flist_t), intent(inout) :: self
    self%head => null()
    self%tail => null()
  end subroutine flist_init

  ! Append a new node containing the given pointer P to the end of the list.
  subroutine flist_append(self, p)
    type(flist_t), intent(inout) :: self
    class(*), target, intent(in) :: p
    type(flist_node_t), pointer :: new

    if (.not. associated(self%tail)) then
      allocate(self%tail)
    else
      allocate(new)
      self%tail%next => new
      self%tail => new
    end if

    self%tail%p => p

    if (.not. associated(self%head)) then
      self%head => self%tail
    end if
  end subroutine flist_append

  ! Insert a new node containing the given pointer P after the given NODE.
  subroutine flist_insert(self, node, p)
    type(flist_t), intent(inout) :: self
    type(flist_node_t), pointer, intent(inout) :: node
    class(*), target, intent(in) :: p
    type(flist_node_t), pointer :: next

    allocate(next)
    next%next => node%next
    node%next => next
    next%p => p
  end subroutine flist_insert

  subroutine flist_first(self, first)
    type(flist_t), intent(inout) :: self
    type(flist_node_t), pointer, intent(out) :: first

    first => self%head
  end subroutine flist_first

  subroutine flist_next(self, node, next)
    type(flist_t), intent(inout) :: self
    type(flist_node_t), pointer, intent(in) :: node
    type(flist_node_t), pointer, intent(out) :: next

    next => node%next
  end subroutine flist_next

  subroutine flist_get(self, node, p)
    type(flist_t), intent(inout) :: self
    type(flist_node_t), pointer, intent(in) :: node
    class(*), pointer, intent(out) :: p

    p => node%p
  end subroutine flist_get

  subroutine flist_free(self)
    type(flist_t), intent(inout) :: self
    type(flist_node_t), pointer :: current, next

    current => self%head
    do while (associated(current))
      next => current%next
      deallocate(current)
      nullify(current)
      current => next
    end do
  end subroutine flist_free

  function flist_count(self)
    type(flist_t), intent(inout) :: self
    type(flist_node_t), pointer :: current, next
    integer :: flist_count

    flist_count = 0
    current => self%head
    do while (associated(current))
       current => current%next
       flist_count = flist_count + 1
    end do
  end function flist_count

end module flist

program test
  use flist
  implicit none

  class(*), pointer :: p, q
  real, target :: x = 17.5, y = 42.0
  type(flist_t) :: list
  type(flist_node_t), pointer :: node
  real, pointer :: a, b

  ! Initialize the list
  call flist_init(list)

  ! Add two items
  p => x
  call flist_append(list, p)
  p => y
  call flist_append(list, p)

  ! Walk the list and print elements
  call flist_first(list, node)
  do while (associated(node))
    call flist_get(list, node, p)
    select type (p)
    type is (real)
      print *, p
    end select
    call flist_next(list, node, node)
  end do

  ! Count the elements
  print *, 'count: ', flist_count(list)

  ! Free the list (note that items are not dynamically allocated)  
  call flist_free(list)

end program test
