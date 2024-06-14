# Copyright 2023 Remy Blank <remy@c-space.org>
# SPDX-License-Identifier: MIT

cmake_minimum_required(VERSION 3.20)

include(mlua_import.cmake)

project(MicroLua_examples C CXX ASM)
set(CMAKE_C_STANDARD 11)
set(CMAKE_CXX_STANDARD 17)

mlua_init()

macro(check_vars)
    foreach(var ${ARGN})
        if("${${var}}" STREQUAL "")
            file(RELATIVE_PATH rel "${CMAKE_SOURCE_DIR}"
                 "${CMAKE_CURRENT_SOURCE_DIR}")
            message("Skipping ${rel}: ${var} isn't set")
            return()
        endif()
    endforeach()
endmacro()

add_compile_definitions(
    MLUA_MAIN_SHUTDOWN=1
    MLUA_MAIN_TRACEBACK=1
    PICO_ENTER_USB_BOOT_ON_EXIT=1
    PICO_STACK_SIZE=0x1000
    PICO_USE_STACK_GUARDS=1
)

add_subdirectory(adc)
add_subdirectory(blink)
add_subdirectory(fennel)
add_subdirectory(pico_w)
