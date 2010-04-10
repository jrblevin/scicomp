#!/bin/sh

rm mandelbrot-$1
ifort -O3 -static -fast -openmp -o mandelbrot-$1 mandelbrot.ifc-$1.f90
time ./mandelbrot-$1 200 > mandelbrot-$1.pbm
diff mandelbrot-output.txt mandelbrot-$1.pbm
time ./mandelbrot-$1 16000 > /tmp/mandelbrot-$1.pbm
