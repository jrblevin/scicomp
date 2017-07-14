module mt_mod
  use iso_c_binding, &
       mt_state => c_ptr, &  ! opaque pointer interface
       mt_i4b => c_long      ! interoperable integer kind
  implicit none

  private
  public :: mt_state
  public :: mt_alloc
  public :: mt_free
  public :: mt_seed
  public :: mt_get
  public :: mt_i4b

  interface

     function mt_alloc_c() result(mt) bind(c, name='mt_alloc')
       import
       type(mt_state) :: mt
     end function mt_alloc_c

     subroutine mt_free(mt) bind(c)
       import
       type(mt_state), value :: mt
     end subroutine mt_free

     subroutine mt_seed(mt, seed) bind(c)
       import
       type(mt_state), value :: mt
       integer(mt_i4b), value :: seed
     end subroutine mt_seed

     function mt_get(mt) result(u) bind(c)
       import
       type(mt_state), value :: mt
       integer(mt_i4b) :: u
     end function mt_get

  end interface

contains

  subroutine mt_alloc(mt)
    type(mt_state), intent(inout) :: mt
    mt = mt_alloc_c()
  end subroutine mt_alloc

end module mt_mod
