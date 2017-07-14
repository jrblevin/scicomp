program pointer_test
  implicit none

  integer, dimension(2), target :: x = (/ 2, 10 /)
  integer, dimension(:), pointer :: p => null()
  integer, dimension(:), pointer :: q => null()

  print *, 'Upon initialization, pointer p:'
  if (associated(p)) then
     print *, ' * is associated'
  else
     print *, ' * is not associated'
  end if
     
end program pointer_test
