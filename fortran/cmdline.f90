program cmdline
  implicit none

  character(len=*), parameter :: version = '1.0'
  character(len=32) :: arg
  character(len=8) :: date
  character(len=10) :: time
  character(len=5) :: zone
  logical :: do_time = .false.
  integer :: i

  do i = 1, command_argument_count()
     call get_command_argument(i, arg)

     select case (arg)
     case ('-v', '--version')
        print '(2a)', 'cmdline version ', version
        stop
     case ('-h', '--help')
        call print_help()
        stop
     case ('-t', '--time')
        do_time = .true.
     case default
        print '(a,a,/)', 'Unrecognized command-line option: ', arg
        call print_help()
        stop
     end select
  end do

  ! Print the date and, optionally, the time
  call date_and_time(DATE=date, TIME=time, ZONE=zone)
  write (*, '(a,"-",a,"-",a)', advance='no') date(1:4), date(5:6), date(7:8)
  if (do_time) then
     write (*, '(x,a,":",a,x,a)') time(1:2), time(3:4), zone
  else
     write (*, '(a)') ''
  end if

contains

  subroutine print_help()
    print '(a)', 'usage: cmdline [OPTIONS]'
    print '(a)', ''
    print '(a)', 'Without further options, cmdline prints the date and exits.'
    print '(a)', ''
    print '(a)', 'cmdline options:'
    print '(a)', ''
    print '(a)', '  -v, --version     print version information and exit'
    print '(a)', '  -h, --help        print usage information and exit'
    print '(a)', '  -t, --time        print time'
  end subroutine print_help

end program cmdline
