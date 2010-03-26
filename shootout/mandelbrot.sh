#!/bin/sh

ifort -O3 -o mandelbrot mandelbrot.f90
./mandelbrot 200 > mandelbrot.pbm
diff mandelbrot-output.txt mandelbrot.pbm
