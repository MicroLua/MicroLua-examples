# Copyright 2023 Remy Blank <remy@c-space.org>
# SPDX-License-Identifier: MIT

mlua_add_fnl_modules(mod_fennel_hello_world hello_world.fnl)
target_link_libraries(mod_fennel_hello_world INTERFACE
    mlua_mod_mlua.time
)

mlua_add_executable(fennel_hello_world)
target_compile_definitions(fennel_hello_world PRIVATE
    MLUA_MAIN_MODULE=hello_world
    MLUA_STDIO_INIT_USB=1
    PICO_STDIO_USB_CONNECT_WAIT_TIMEOUT_MS=1000
)
target_link_libraries(fennel_hello_world PRIVATE
    mlua_mod_mlua.stdio
    mlua_mod_pico.stdio
    mlua_mod_pico.stdio.usb
    mod_fennel_hello_world
    pico_stdlib
)
