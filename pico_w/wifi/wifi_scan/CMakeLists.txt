# Copyright 2024 Remy Blank <remy@c-space.org>
# SPDX-License-Identifier: MIT

mlua_add_lua_modules(mod_picow_wifi_scan picow_wifi_scan.lua)
target_link_libraries(mod_picow_wifi_scan INTERFACE
    mlua_mod_mlua.io
    mlua_mod_pico
    mlua_mod_pico.cyw43
    mlua_mod_pico.cyw43.wifi
    mlua_mod_pico.time
)

add_executable(picow_wifi_scan)
target_compile_definitions(picow_wifi_scan PRIVATE
    MLUA_MAIN_MODULE=picow_wifi_scan
    MLUA_STDIO_INIT_USB=1
    PICO_STDIO_USB_CONNECT_WAIT_TIMEOUT_MS=1000
)
target_link_libraries(picow_wifi_scan PRIVATE
    mod_picow_wifi_scan
    mlua_mod_mlua.stdio
    mlua_mod_pico.stdio
    mlua_mod_pico.stdio.usb
    pico_stdlib
)
pico_add_extra_outputs(picow_wifi_scan)
