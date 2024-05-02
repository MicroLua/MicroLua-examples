# Copyright 2023 Remy Blank <remy@c-space.org>
# SPDX-License-Identifier: MIT

cmake_minimum_required(VERSION 3.20)

include(mlua_import.cmake)

project(MicroLua_examples C CXX ASM)
set(CMAKE_C_STANDARD 11)
set(CMAKE_CXX_STANDARD 17)

mlua_init()

add_subdirectory(adc)
add_subdirectory(blink)
add_subdirectory(fennel)
add_subdirectory(pico_w)
