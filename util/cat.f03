! cat.f03 -- cat in Fortran 2003
!
! Copyright (C) 2009 Jason R. Blevins
! All rights reserved.
!
! This software may be modified and distributed under the terms
! of the BSD license.  See the LICENSE file for details.

program cat
  use iso_fortran_env
  implicit none

  integer, parameter :: BUFSIZE = 256
  integer, parameter :: DEFAULT_LUN = 15

  character(len=BUFSIZE) :: buf
  integer :: lun, n, stat

  ! check for a filename
  call get_command_argument(1, buf, length=n, status=stat)

  ! status is positive if get_command_argument failed, zero if
  ! successful, and negative if the argument was truncated
  if (stat > 0) then
     lun = input_unit
  else if (stat == 0) then
     lun = DEFAULT_LUN
     open(unit=lun, file=buf)
  else
     stop 'Filename too long!'
  end if

  ! cat standard input or named file
  call cat_file(lun)

  ! close the input source
  close(lun)

contains

  ! read input into buffer and write to standard output
  subroutine cat_file(lun)
    integer, intent(in) :: lun

    do
       ! read at most BUFSIZE characters
       read (unit=lun, iostat=stat, advance='no', fmt='(a)', size=n) buf
       write (*, advance='no', fmt='(a)') buf(1:n)

       ! if stat is negative, but not iostat_end, then end of record
       if (is_iostat_end(stat)) then
          ! exit loop upon reaching EOF
          exit
       else if (stat < 0) then
          ! print a newline at EOR
          write (*, fmt='(a)') ''
       end if
    end do
  end subroutine cat_file

end program cat
