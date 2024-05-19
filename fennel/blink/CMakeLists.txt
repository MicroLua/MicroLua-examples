# Copyright 2023 Remy Blank <remy@c-space.org>
# SPDX-License-Identifier: MIT

mlua_add_fnl_modules(mod_fennel_blink blink.fnl)
target_link_libraries(mod_fennel_blink INTERFACE
    mlua_mod_hardware.gpio
    mlua_mod_mlua.time
    mlua_mod_pico
)

mlua_add_executable(fennel_blink)
target_compile_definitions(fennel_blink PRIVATE
    MLUA_MAIN_MODULE=blink
    MLUA_STDIO_INIT_USB=1
    PICO_STDIO_USB_CONNECT_WAIT_TIMEOUT_MS=1000
)
target_link_libraries(fennel_blink PRIVATE
    mlua_mod_mlua.stdio
    mlua_mod_pico.stdio
    mlua_mod_pico.stdio.usb
    mod_fennel_blink
    pico_stdlib
)
