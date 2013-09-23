#!/bin/sh

make clean
make

LD_LIBRARY_PATH=.
export LD_LIBRARY_PATH

ldd ./main

gcc -c mylib.c -o mylib.o -Wa,-adhln=mylib.s -g -fverbose-asm -masm=intel -O3 -march=native
