#!/usr/bin/env bash
cd $(readlink -en $(dirname $0))
rm -rf build
mkdir build
cd build
#cmake -DCMAKE_RULE_MESSAGES:BOOL=OFF -DCMAKE_VERBOSE_MAKEFILE:BOOL=ON ..
cmake -DCMAKE_RULE_MESSAGES:BOOL=OFF ..
#cmake ..
make --no-print-directory
