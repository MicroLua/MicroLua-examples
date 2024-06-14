# Copyright 2024 Remy Blank <remy@c-space.org>
# SPDX-License-Identifier: MIT

if(NOT PICO_CYW43_SUPPORTED)
    message("Skipping picow/*: not targeting pico_w")
else()
    add_subdirectory(wifi)
endif()
