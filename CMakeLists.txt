cmake_minimum_required(VERSION 3.0)
project(maiwayland CXX)

set(CMAKE_C_COMPILER "/usr/bin/gcc")
set(CMAKE_CXX_COMPILER "/usr/bin/g++")

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

add_executable(solver src/solver.cpp)
target_link_libraries(solver pthread)
