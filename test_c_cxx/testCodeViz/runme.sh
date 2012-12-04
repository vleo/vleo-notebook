#!/bin/sh

# generate a.out and test_initializer.c.cdepn
/usr/local/gcc-graph/bin/gcc test_initializer.c

# generate full.graph
genfull

# produce PDF rendering (other types with -Txxx,
# use dot -Thelp to find options)
dot -Tpdf full.graph > /tmp/x.pdf; evince /tmp/x.pdf

rm a.out  full.graph  test_initializer.c.cdepn /tmp/x.pdf

