#!/bin/sh

function createDir {
  if [ ! -d $1 ] ; then mkdir $1; fi
}

function createCleanDir {
  createDir $1
  pushd $1 >/dev/null
  if [ $? = 0 ] ; then rm -rf *; else exit 1;  fi
  popd >/dev/null
}

createCleanDir BUILD
createCleanDir BUILDROOT

createDir RPMS
pushd RPMS >/dev/null
if [ $? = 0 ] 
then 
  RPMDIRS="noarch i386 i586 i686 x86_64"
  for d in $RPMDIRS; do createCleanDir $d ; done
else 
  exit 3
fi
popd >/dev/null

createDir SRPMS
createCleanDir SOURCES
