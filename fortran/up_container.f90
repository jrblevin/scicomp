module container
  implicit none

  type :: container_t
     private
     class(*), pointer :: p
  end type container_t

contains

  subroutine container_set(self, p)
    type(container_t), intent(inout) :: self
    class(*), target, intent(in) :: p
    self%p => p
  end subroutine container_set

  subroutine container_get(self, p)
    type(container_t), intent(inout) :: self
    class(*), pointer, intent(out) :: p
    p => self%p
  end subroutine container_get

end module container


program container_test
  use container
  implicit none

  type(container_t) :: c
  class(*), pointer :: p
  integer, target :: x = 17
  integer :: y = 0

  ! Store a pointer to x in the container
  call container_set(c, x)

  ! Retrieve the pointer stored in the container
  call container_get(c, p)

  ! Use select type to manipulate data
  select type (p)
  type is (integer)
     y = p
  end select
  print *, y

end program container_test
