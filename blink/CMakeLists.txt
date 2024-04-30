# Copyright 2023 Remy Blank <remy@c-space.org>
# SPDX-License-Identifier: MIT

mlua_add_lua_modules(mlua_examples_blink_main main.lua)
target_link_libraries(mlua_examples_blink_main INTERFACE
    mlua_mod_hardware.gpio
    mlua_mod_pico
    mlua_mod_pico.time
)

add_executable(mlua_examples_blink)
target_link_libraries(mlua_examples_blink PRIVATE
    mlua_examples_blink_main
    pico_stdlib
)
pico_add_extra_outputs(mlua_examples_blink)
