#!/bin/sh

ifort -fast -openmp -o mandelbrot mandelbrot.f90
time ./mandelbrot 200 > mandelbrot.pbm
diff mandelbrot-output.txt mandelbrot.pbm
time ./mandelbrot 16000 > /tmp/foo.pbm
