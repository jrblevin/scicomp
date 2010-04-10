#!/bin/sh

id=$1

rm mandelbrot
ifort -O3 -static -fast -openmp -o mandelbrot mandelbrot.ifc-$1.f90
time ./mandelbrot 200 > mandelbrot-$1.pbm
diff mandelbrot-output.txt mandelbrot-$1.pbm
time ./mandelbrot 16000 > /tmp/mandelbrot-$1.pbm
