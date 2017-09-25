#!/usr/bin/bash
if [ $1"x" = '-cx' ]; then
  rm -rf *.la *.lo *.o main_w_* .libs lib bin
else
 libtool --mode=compile gcc -g -c foo.c
 libtool --mode=compile gcc -g -c main.c 

# build static library for foo
# note 'foo.lo', not 'foo.o'
 libtool --mode=link gcc -g -o libfoo.la foo.lo

# link against static library
 libtool --mode=link gcc -g -o main_w_static main.o libfoo.la

# buid shared library
LIBPATH='lib'
if [ ! -d $LIBPATH ]; then mkdir $LIBPATH; fi
LIBPATH=$(readlink -e -n ./lib)

libtool --mode=link gcc -g -o libfoo.la foo.lo -rpath $LIBPATH
libtool --mode=install cp libfoo.la $LIBPATH

# link agains shared library
libtool --mode=link gcc -g -o main_w_shared main.o -L$LIBPATH -lfoo

if [ ! -d bin ]; then mkdir bin; fi
# install binary

libtool --mode=install install -c main_w_shared $(readlink -e -n ./bin)

fi
