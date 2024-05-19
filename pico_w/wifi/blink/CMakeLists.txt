# Copyright 2024 Remy Blank <remy@c-space.org>
# SPDX-License-Identifier: MIT

mlua_add_lua_modules(mod_picow_blink picow_blink.lua)
target_link_libraries(mod_picow_blink INTERFACE
    mlua_mod_mlua.time
    mlua_mod_pico
    mlua_mod_pico.cyw43
)

mlua_add_executable(picow_blink)
target_compile_definitions(picow_blink PRIVATE
    MLUA_MAIN_MODULE=picow_blink
    MLUA_STDIO_INIT_USB=1
    PICO_STDIO_USB_CONNECT_WAIT_TIMEOUT_MS=1000
)
target_link_libraries(picow_blink PRIVATE
    mod_picow_blink
    mlua_mod_mlua.stdio
    mlua_mod_pico.stdio
    mlua_mod_pico.stdio.usb
    pico_stdlib
)
