program char_ptr_test
  implicit none

  character(len=:), pointer :: p, q

  p = get_ptr(100)
  p = 'Pointed to by p'

  print '(a,a)', 'p: ', trim(p)

  q => p
  q = q // ' and q'

  print '(a,a)', 'q: ', trim(q)


  contains

    subroutine alloc(p, n)
      integer, intent(in) :: n
      character(len=:), pointer :: get_ptr

      allocate(character(len=n) :: get_ptr)
      get_ptr = 'Allocated by get_ptr'
      print '(a,a)', 'get_ptr: ', trim(get_ptr)
    end function get_ptr

end program char_ptr_test
