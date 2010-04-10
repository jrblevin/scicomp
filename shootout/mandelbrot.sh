#!/bin/sh

id=$1

rm mandelbrot
ifort -fast -openmp -o mandelbrot mandelbrot.ifc-$1.f90
time ./mandelbrot 200 > mandelbrot.pbm
diff mandelbrot-output.txt mandelbrot.pbm
time ./mandelbrot 16000 > /tmp/foo.pbm
