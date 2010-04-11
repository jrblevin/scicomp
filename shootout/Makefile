FC=ifort
FFLAGS=-O3 -static -fast -ipo -no-prec-div

CC=gcc
CFLAGS=-pipe -Wall -O3 -fomit-frame-pointer -march=native -D_ISOC9X_SOURCE -mfpmath=sse -msse2 -lm -lpthread

#--- mandelbrot ---------------------------------------------------------------

MANDEL_BENCH=mandelbrot.gcc-6.gcc_run
MANDEL_OWN=mandelbrot.ifc-4.ifc_run

mandelbrot.ifc-1.ifc_run: mandelbrot.ifc-1.f90
	$(FC) $(FFLAGS) $< -o $@

mandelbrot.ifc-4.ifc_run: mandelbrot.ifc-4.f90
	$(FC) $(FFLAGS) -openmp $< -o $@

mandelbrot.gcc-6.gcc_run: mandelbrot.gcc-6.c
	$(CC) $(CFLAGS) $< -o $@

test_mandelbrot: $(MANDEL_OWN)
	@./$(MANDEL_OWN) 200 > $(MANDEL_OWN).out
	@diff mandelbrot-output.txt $(MANDEL_OWN).out
	@rm -f $(MANDEL_OWN).out

bench_mandelbrot: $(MANDEL_OWN) $(MANDEL_BENCH)
	@echo "gcc-6:"
	@time ./$(MANDEL_BENCH) 16000 > /dev/null
	@echo "ifc-4:"
	@time ./$(MANDEL_OWN) 16000 > /dev/null

#--- miscellaneous ------------------------------------------------------------

clean:
	rm -f *_run *.out *.mod *.o
