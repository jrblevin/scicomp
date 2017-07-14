# CC = gcc
# FC = gfortran
# # CFLAGS = -ansi -pedantic -std=c99 -Wall -g -fbounds-check -Wextra
# # FFLAGS = -Wall -std=f2003 -g -fbounds-check -fbacktrace -finit-real=nan
# CFLAGS = -ansi -pedantic -std=c99 -Wall -O3 -march=native
# FFLAGS = -Wall -std=f2003 -O3 -march=native -ffast-math -funroll-loops
# FC_LIBS = -lgfortran
# AR = ar

CC = icc
FC = ifort
# CFLAGS = -strict-ansi -std=c99 -O0 -g -Wcheck -Wall -traceback
# FFLAGS = -stand f03 -warn all -O0 -g -check all -traceback -fpe0
CFLAGS = -strict-ansi -std=c99 -fast
FFLAGS = -stand f03 -fast
FC_LIBS = -lifcore
AR = xiar

PROGS = bench_cc bench_ff bench_cf bench_fc

%.o: %.c
	$(CC) $(CFLAGS) -c $<

%.o: %.f90
	$(FC) $(FFLAGS) -c $<

all: $(PROGS)

# MT in C with a C driver
bench_cc: bench_c.c mt_cc.c
	$(CC) $(CFLAGS) -c mt_cc.c
	$(CC) $(CFLAGS) -c bench_c.c
	$(CC) $(CFLAGS) -o $@ bench_c.o mt_cc.o

# MT in Fortran with a Fortran driver
bench_ff: mt_ff.f90 bench_f.f90
	$(FC) $(FFLAGS) -c mt_ff.f90
	$(FC) $(FFLAGS) -c bench_f.f90
	$(FC) $(FFLAGS) -o $@ bench_f.o mt_ff.o

# MT in C with a Fortran interface and Fortran driver
bench_cf: mt_cc.c mt_cf.f90 bench_f.f90
	$(CC) $(CFLAGS) -c mt_cc.c
	$(AR) cr mt_c.a mt_cc.o
#	$(FC) $(FFLAGS) -c mt_cf.f90
#	$(FC) $(FFLAGS) -c bench_f.f90
#	$(FC) $(FFLAGS) -o $@ bench_f.o mt_cc.o mt_cf.o
	$(FC) $(FFLAGS) -o $@ mt_cf.f90 bench_f.f90 mt_c.a

# MT in Fortran with a C interface and C driver
bench_fc: mt_ff.f90 mt_fc.f90 bench_c.c
	$(FC) $(FFLAGS) -c mt_ff.f90
	$(FC) $(FFLAGS) -c mt_fc.f90
	$(CC) $(CFLAGS) -c bench_c.c
	$(CC) $(CFLAGS) -o $@ bench_c.o mt_ff.o mt_fc.o $(FC_LIBS)

clean:
	rm -f $(PROGS) *.o *.mod
