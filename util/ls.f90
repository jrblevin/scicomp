! ls.f90 -- lists all files in a directory
!
! Copyright (C) 2010 Jason R. Blevins
! License: 3-clause BSD
!
! This program depends on the Posix90 library:
!
!     http://savannah.nongnu.org/projects/posix90/
!
! To compile and link (after seting $POSIX90 appropriately):
!
!   $ gfortran -I$POSIX90 -o ls ls.f90 -L$POSIX90 -lposix90

program ls
  use f90_unix_dirent
  implicit none

  type(DIR) :: dirp
  integer :: errno, name_len
  character(LEN=128) :: name

  call opendir('/home/jrblevin', dirp)
  do
     call readdir(dirp, name, name_len)
     if (name_len > 0) then
        print *, name(1:name_len)
     else
        exit
     end if
  end do
  call closedir(dirp)
end program ls
