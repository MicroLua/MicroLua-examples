# Copyright 2024 Remy Blank <remy@c-space.org>
# SPDX-License-Identifier: MIT

mlua_add_lua_modules(mlua_examples_pico_w_wifi_blink_main picow_blink.lua)
target_link_libraries(mlua_examples_pico_w_wifi_blink_main INTERFACE
    mlua_mod_pico
    mlua_mod_pico.cyw43
    mlua_mod_pico.time
)

add_executable(mlua_examples_pico_w_wifi_blink)
target_compile_definitions(mlua_examples_pico_w_wifi_blink PRIVATE
    MLUA_MAIN_MODULE=picow_blink
    MLUA_STDIO_INIT_USB=1
    PICO_STDIO_USB_CONNECT_WAIT_TIMEOUT_MS=1000
)
target_link_libraries(mlua_examples_pico_w_wifi_blink PRIVATE
    mlua_examples_pico_w_wifi_blink_main
    mlua_mod_mlua.stdio
    mlua_mod_pico.stdio
    mlua_mod_pico.stdio.usb
    pico_stdlib
)
pico_add_extra_outputs(mlua_examples_pico_w_wifi_blink)
