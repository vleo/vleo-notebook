#!/bin/sh
echo cksum: \>$1\<
md5sum "$1" >> all_files_checksums.lst
cksum "$1" >> all_files_checksums.lst
sum "$1" >> all_files_checksums.lst
./test_argc_argv "$1" >> all_files_checksums.lst
