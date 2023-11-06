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
mlua_fennel_version(fennel_version)
if(NOT "${fennel_version}" STREQUAL "")
    add_subdirectory(fennel)
else()
    message(WARNING "Fennel compiler not found, skipping fennel/")
endif()
