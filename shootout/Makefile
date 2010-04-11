FC=ifort
CC=gcc

#--- binarytrees --------------------------------------------------------------

BIN_BENCH=binarytrees.gcc-7.gcc_run
BIN_OWN=binarytrees.ifc-2.ifc_run

binarytrees.ifc-1.ifc_run: binarytrees.ifc-1.f90
	$(FC) -O3 -static -u -what -u -what $< -o $@

binarytrees.ifc-2.ifc_run: binarytrees.ifc-2.f90
	$(FC) -O3 -static -fast -ipo -no-prec-div $< -o $@

binarytrees.gcc-7.gcc_run: binarytrees.gcc-7.c
	$(CC) -pipe -Wall -O3 -fomit-frame-pointer -march=native -fopenmp \
		-D_FILE_OFFSET_BITS=64 -I/usr/include/apr-1.0 -lapr-1 \
		-lgomp $< -o $@

test_binarytrees: $(BIN_OWN)
	@./$(BIN_OWN) 10 > $(BIN_OWN).out
	@diff binarytrees-output.txt $(BIN_OWN).out
	@rm -f $(BIN_OWN).out

bench_binarytrees: $(BIN_OWN) $(BIN_BENCH)
	@echo "benchmark:"
	@time ./$(BIN_BENCH) 20 > /dev/null
	@echo "own:"
	@time ./$(BIN_OWN) 20 > /dev/null

#--- fasta --------------------------------------------------------------------

FASTA_BENCH=fasta.gcc-3.gcc_run
FASTA_OWN=fasta.ifc-2.ifc_run

fasta.ifc-1.ifc_run: fasta.ifc-1.f90
	$(FC) -O3 -static -o $@ $<

fasta.ifc-2.ifc_run: fasta.ifc-2.f90
	$(FC) -O3 -static -fast -ipo -no-prec-div -o $@ $<

fasta.gcc-3.gcc_run: fasta.gcc-3.c
	$(CC) -pipe -Wall -O3 -fomit-frame-pointer -march=native -std=c99 \
		-mfpmath=sse -msse3 -o $@ $<

test_fasta: $(FASTA_OWN)
	@./$(FASTA_OWN) 1000 > $(FASTA_OWN).out
	@diff fasta-output.txt $(FASTA_OWN).out
	@rm -f $(FASTA_OWN).out

bench_fasta: $(FASTA_OWN) $(FASTA_BENCH)
	@echo "benchmark:"
	@time ./$(FASTA_BENCH) 25000000 > /dev/null
	@echo "own:"
	@time ./$(FASTA_OWN) 25000000 > /dev/null

#--- mandelbrot ---------------------------------------------------------------

MANDEL_BENCH=mandelbrot.gcc-6.gcc_run
MANDEL_OWN=mandelbrot.ifc-4.ifc_run

mandelbrot.ifc-1.ifc_run: mandelbrot.ifc-1.f90
	$(FC) -O3 -static $< -o $@

mandelbrot.ifc-4.ifc_run: mandelbrot.ifc-4.f90
	$(FC) -O3 -static -fast -openmp $< -o $@

mandelbrot.gcc-6.gcc_run: mandelbrot.gcc-6.c
	$(CC) -O3 -fomit-frame-pointer -march=native -D_ISOC9X_SOURCE \
		-mfpmath=sse -msse2 -lm -lpthread $< -o $@

test_mandelbrot: $(MANDEL_OWN)
	@./$(MANDEL_OWN) 200 > $(MANDEL_OWN).out
	@diff mandelbrot-output.txt $(MANDEL_OWN).out
	@rm -f $(MANDEL_OWN).out

bench_mandelbrot: $(MANDEL_OWN) $(MANDEL_BENCH)
	@echo "benchmark:"
	@time ./$(MANDEL_BENCH) 16000 > /dev/null
	@echo "own:"
	@time ./$(MANDEL_OWN) 16000 > /dev/null

#--- Miscellaneous ------------------------------------------------------------

clean:
	rm -f *_run *.out *.mod *.o
