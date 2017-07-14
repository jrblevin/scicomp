! Reads a complete file into memory, making use of allocatable
! deferred-length character strings in Fortran 2003.  No assumptions
! are made about the width of the file.

module read_mod
  implicit none

  integer, parameter :: bufsize = 256
  integer, parameter :: default_lun = 15

contains

  ! read the entire input file into a character variable
  subroutine read_file(lun, string)
    integer, intent(in) :: lun
    character(len=bufsize) :: buf
    character(len=:), allocatable, intent(out) :: string
    integer :: n, point, stat

    if (allocated(string)) then
       deallocate(string)
    end if

    point = 1
    allocate(character(len=bufsize) :: string)

    do
       ! read at most BUFSIZE characters
       read (unit=lun, iostat=stat, advance='no', fmt='(a)', size=n) buf

       print *, 'READ ', n, ' characters'
       print *, 'LENGTH of string: ', len(string)

       ! if stat is negative, but not iostat_end, then end of record
       if (is_iostat_end(stat)) then
          ! exit loop upon reaching EOF
          print *, 'EOF'
          exit
       else
          ! Append to str, expanding if necessary (adding new_line at EOR)
          if (is_iostat_eor(stat)) then
             call append(trim(buf) // new_line(string), n + 1)
             print *, 'EOR'
          else
             call append(buf, n)
          end if
       end if
    end do

  contains

    subroutine append(c, sz)
      character(len=*), intent(in) :: c
      integer, intent(in) :: sz
      character(len=:), allocatable :: tmp
      integer :: length, new_length

      length = len(string)

      ! Expand STRING if the resulting string is too long
      if (point + sz > length) then

         ! Expand the string by BUFSIZE
         new_length = length + bufsize

         ! Store contents in TMP while reallocating
         allocate(character(len=length) :: tmp)
         tmp = string
         deallocate(string)
         allocate(character(len=new_length) :: string)

         ! Copy contents back to STRING
         string(1:point-1) = tmp

         deallocate(tmp)

      end if

      string(point:point+sz) = c(1:sz)
      string(point+sz:) = ''
      point = point + sz

    end subroutine append

  end subroutine read_file

end module read_mod


program read
  use iso_fortran_env
  use read_mod
  implicit none

  character(len=bufsize) :: filename
  character(len=:), allocatable :: string
  integer :: lun, n, stat

  ! check for a filename
  call get_command_argument(1, filename, length=n, status=stat)

  ! status is positive if get_command_argument failed, zero if
  ! successful, and negative if the argument was truncated
  if (stat > 0) then
     lun = input_unit
  else if (stat == 0) then
     lun = default_lun
     open(unit=lun, file=filename)
  else
     stop 'ERROR: filename too long!'
  end if

  ! Read source into string and print
  call read_file(lun, string)
  print '(a)', trim(string)

  ! close the input source
  close(lun)

  ! clean up
  if (allocated(string)) then
     deallocate(string)
  end if

end program read
