# Copyright 2023 Remy Blank <remy@c-space.org>
# SPDX-License-Identifier: MIT

mlua_fennel_version(fennel_version)
if("${fennel_version}" STREQUAL "")
    message("Fennel compiler not found, skipping fennel/")
else()
    add_subdirectory(blink)
    add_subdirectory(hello_world)
endif()
