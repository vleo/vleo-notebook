
cmake_minimum_required(VERSION 3.9)
project(testboost)
set(CMAKE_CXX_STANDARD 11)

if(CMAKE_BUILD_TYPE MATCHES "VerboseMake")

    set(CMAKE_RULE_MESSAGES off)
    set(CMAKE_COLOR_MAKEFIL on)
    set(CMAKE_VERBOSE_MAKEFILE on)

endif()


add_subdirectory(src)
