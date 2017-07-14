module abstract_type_ex
  type, abstract :: file_handle
   contains
     procedure(open_file), deferred, pass :: open
  end type file_handle

  abstract interface
     subroutine open_file(handle)
       import :: file_handle
       class(file_handle), intent(inout) :: handle
     end subroutine open_file
  end interface
end module abstract_type_ex
