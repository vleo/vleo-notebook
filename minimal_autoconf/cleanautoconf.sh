#!/bin/sh
if [ ! -d ./m4 ] ; then mkdir m4; fi

echo 'Cleaning all autoreconf generated files'

rm -rf \
config.h \
config.log \
config.status \
libtool \
stamp-h1 \
.deps \
.libs

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
Makefile.in \
missing \
*~

