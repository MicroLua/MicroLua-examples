# Copyright 2023 Remy Blank <remy@c-space.org>
# SPDX-License-Identifier: MIT

mlua_add_lua_modules(mod_blink blink.lua)
target_link_libraries(mod_blink INTERFACE
    mlua_mod_hardware.gpio
    mlua_mod_pico
    mlua_mod_pico.time
)

add_executable(blink)
target_compile_definitions(blink PRIVATE
    MLUA_MAIN_MODULE=blink
)
target_link_libraries(blink PRIVATE
    mod_blink
    pico_stdlib
)
pico_add_extra_outputs(blink)
