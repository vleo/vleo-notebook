cmake_minimum_required(VERSION 3.9)
find_package(PkgConfig)
pkg_check_modules(XXXPREFIX libzmq)


message("set to 1 if module(s) exist               :" _FOUND:${XXXPREFIX_FOUND})
message("only the libraries (w/o the '-l')         :" _LIBRARIES:${XXXPREFIX_LIBRARIES})
message("the paths of the libraries (w/o the '-L') :" _LIBRARY_DIRS:${XXXPREFIX_LIBRARY_DIRS})
message("all required linker flags                 :" _LDFLAGS:${XXXPREFIX_LDFLAGS})
message("all other linker flags                    :" _LDFLAGS_OTHER:${XXXPREFIX_LDFLAGS_OTHER})
message("the '-I' preprocessor flags (w/o the '-I'):" _INCLUDE_DIRS:${XXXPREFIX_INCLUDE_DIRS})
message("all required cflags                       :" _CFLAGS:${XXXPREFIX_CFLAGS})
message("the other compiler flags                  :" _CFLAGS_OTHER:${XXXPREFIX_CFLAGS_OTHER})
message("version of the module                     :" _VERSION:${XXXPREFIX_VERSION})
message("prefix-directory of the module            :" _PREFIX:${XXXPREFIX_PREFIX})
message("include-dir of the module                 :" _INCLUDEDIR:${XXXPREFIX_INCLUDEDIR})
message("lib-dir of the module                     :" _LIBDIR:${XXXPREFIX_LIBDIR})

find_library(XXXPREFIX_LIBRARY zmq)

message(LIBRARY:${XXXPREFIX_LIBRARY})

find_path(XXXPREFIX_PATH zmq.h)

message(PATH:${XXXPREFIX_PATH})

