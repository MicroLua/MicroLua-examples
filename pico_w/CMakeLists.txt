# Copyright 2024 Remy Blank <remy@c-space.org>
# SPDX-License-Identifier: MIT

if(NOT PICO_CYW43_SUPPORTED)
    message("Not targeting pico_w, skipping pico_w/")
else()
    add_subdirectory(wifi)
endif()
