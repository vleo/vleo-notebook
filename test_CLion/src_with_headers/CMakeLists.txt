cmake_minimum_required(VERSION 3.6)
project(test_CLion)

find_package(ZMQ REQUIRED)


include_directories(src)
add_executable(test_CLion_exec
  src/test_std_swap.cxx
)
