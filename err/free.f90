!! Generates a "free(): invalid pointer" error.
program free
  integer, dimension(:), allocatable :: data
  integer :: i

  allocate(data(5))
  do i = 1, 5
     data(i-1) = i
  end do
  deallocate(data)
end program free
