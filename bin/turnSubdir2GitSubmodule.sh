#!/bin/sh

SUPER=$1
SUBDIR=$2
NEWPROJ=$3

MYPWD=$(pwd)
echo $PWD
git clone --no-hardlinks $SUPER $NEWPROJ
cd $NEWPROJ
git remote rm origin
git filter-branch --subdirectory-filter  $SUBDIR --prune-empty --tag-name-filter cat -- --all
git update-ref -d refs/original/refs/heads/master
git reflog expire --expire=now --all
git gc --aggressive --prune=now
git repack -ad
cd $MYPWD
pwd

git clone --no-hardlinks $SUPER $SUPER.ORIG
cd $SUPER.ORIG
git remote rm origin
rm -rf $SUBDIR 
git rm -r $SUBDIR
git commit -m "extracted $SUBDIR into its own repo"
cd $MYPWD

git clone --no-hardlinks $SUPER $SUPER.NEW
cd $SUPER.NEW
git remote rm origin
#git filter-branch --tree-filter "rm -r -f $UBDIR" --prune-empty
git filter-branch --index-filter "git rm -q -r -f --cached --ignore-unmatch $SUBDIR" --prune-empty
git reflog expire --expire=now --all
cd $MYPWD
