#!/bin/sh
if [ ! -d ./m4 ] ; then mkdir m4; fi
if [ "$1" = '--clean' ]
then
  echo 'Cleaning all autoreconf generated files'
  if [ -f Makefile ]
  then 
    make distclean
  else 
    rm -rf \
config.h \
config.log \
config.status \
glibstring \
glibstring.o \
libtool \
stamp-h1 \
.deps \
.libs

  fi
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

elif [ "$1" = '--reconf' ]
then
  echo "Preparing ./configure from configure.ac and Makefile.am files"
  if [ -d .git ]
  then
    REVID=$(git log -1 --format=format:"%h %ci" | perl -pe's/ ..:.*$//;s/ ../_/g;s/-//g')
    mv configure.in configure.in.orig
    perl -pe "s/MTREVID/$REVID/" < configure.in.orig > configure.in
  fi
  autoreconf -i
  if [ -d .git ] ; then mv configure.in.orig configure.in; fi
  echo "Run ./configure to prepare Makefile"
elif [ "$1" = '--conf' -o "$1" = '--confdeb' ]
then
  if [ ! -f configure ]; then ./build.sh --reconf; fi
  if [ "$1" == "--confdeb" ]
  then 
    ENABLE_DEBUG="--enable-debug"
    CFLAGS="-ggdb3 -O3 "
    export CFLAGS
  fi
  echo "preparing Makefile with ./configure"
  if [ ${OS}x = "Windows_NTx" ] 
  then
    ./configure  $ENABLE_DEBUG --prefix=/opt/hellowworld --enable-shared --disable-static
  else
    ./configure -q  $ENABLE_DEBUG --prefix=/usr
  fi
  echo "run make to build"
elif [ "$1" = '--refresh' ]
then
  echo "regenerating configure and all Makefiles"
  ./build.sh --clean
  ./build.sh --conf
  echo "run make to build"
elif [ "$1" = '--build' ]
then
  echo "building applicaton with make"
  if [ ! -f Makefile ]; then ./build.sh --conf; fi
  make V=1
  if [ ${OS}x = "Windows_NTx" ] 
  then
  make setup.exe
  fi
else
  echo "Usage: ./build --clean | --reconf | --conf | --confdeb | --refresh | --build"
fi
