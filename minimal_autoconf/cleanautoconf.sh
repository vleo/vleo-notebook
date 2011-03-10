#!/bin/sh
if [ ! -d ./m4 ] ; then mkdir m4; fi

echo 'Cleaning all autoreconf generated files'

find -name Makefile.in -exec rm {} \;
find -name .libs -exec rm -rf {} \;
find -name .deps -exec rm -rf {} \;

rm -rf \
config.h \
config.log \
config.status \
libtool \
compile \
stamp-h1 \

rm -rf \
Makefile \
ac_config.h \
aclocal.m4 \
autom4te.cache \
config.guess \
config.h.in \
config.sub \
configure \
depcomp \
install-sh \
ltmain.sh \
m4/*.m4 \
missing \
*~

