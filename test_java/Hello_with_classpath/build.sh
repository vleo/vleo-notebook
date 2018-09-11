#!/bin/sh
rm -rf build
mkdir  build
javac -d ./build foo/bar/Hello.java
cd build
jar cvf myhellocp.jar *
