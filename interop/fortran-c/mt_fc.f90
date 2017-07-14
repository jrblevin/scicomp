module mt_c_binding
  use iso_c_binding
  use mt_mod
  implicit none

contains

  function mt_alloc_c() result(mt_c) bind(c, name='mt_alloc')
    type(c_ptr) :: mt_c
    type(mt_state), pointer :: mt_f
    allocate(mt_f)
    call mt_alloc(mt_f)
    mt_c = c_loc(mt_f)
  end function mt_alloc_c

  subroutine mt_free_c(mt_c) bind(c, name='mt_free')
    type(c_ptr), value :: mt_c
    type(mt_state), pointer :: mt_f
    call c_f_pointer(mt_c, mt_f)
    call mt_free(mt_f)
    deallocate(mt_f)
  end subroutine mt_free_c

  subroutine mt_seed_c(mt_c, seed) bind(c, name='mt_seed')
    type(c_ptr), value :: mt_c
    integer(c_long), value :: seed
    type(mt_state), pointer :: mt_f
    call c_f_pointer(mt_c, mt_f)
    call mt_seed(mt_f, int(seed, mt_i4b))
  end subroutine mt_seed_c

  function mt_get_c(mt_c) result(u) bind(c, name='mt_get')
    type(c_ptr), value :: mt_c
    integer(c_long) :: u
    type(mt_state), pointer :: mt_f
    call c_f_pointer(mt_c, mt_f)
    u = int(mt_get(mt_f), c_long)
  end function mt_get_c

end module mt_c_binding
