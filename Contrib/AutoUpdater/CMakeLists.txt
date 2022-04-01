cmake_minimum_required(VERSION 2.8)

project(TibiaLoader)
file(GLOB TibiaLoader_src "*.cpp")

add_definitions(-std=c++0x)

add_executable(TibiaLoader main.cpp ${TibiaLoader_src})
