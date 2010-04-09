#!/bin/sh

ifort -fast -o binarytrees binarytrees.f90
time ./binarytrees 10 > binarytrees.txt
diff binarytrees-output.txt binarytrees.txt
time ./binarytrees 20
