! gcc -c csub.c
! gfortran -o call_csub csub.o call_csub.f90
! ./a.out
! The value of i is 42
! The value of d is 4.200000
! The value of a[3] is 3.300000
! The value of c is abc

program call_csub
   integer, parameter :: i = 42
   integer, parameter :: dp = selected_real_kind(15, 307)
   real(dp) :: d = 3.1416_dp
   real(dp), dimension(1:3) :: a = [ 1.0_dp, 2.0_dp, 3.0_dp ]
   character(len=5) :: s = "hello"

   call csub(i, d, a, s)
end program call_csub

! file csub.c:

! void csub_ (int *i, double d, double *a, char *c) {
!
! printf("The value of i is %d\n", *i);
! printf("The value of d is %f\n", *d);
! printf("The value of a[3] is %f\n", a[3]);
! printf("The value of c is %s\n", c);
! 
! }
