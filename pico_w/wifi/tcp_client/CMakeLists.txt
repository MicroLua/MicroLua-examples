# Copyright 2024 Remy Blank <remy@c-space.org>
# SPDX-License-Identifier: MIT

check_vars(WIFI_SSID WIFI_PASSWORD TEST_SERVER)

mlua_add_lua_modules(mod_picow_tcp_client picow_tcp_client.lua)
target_link_libraries(mod_picow_tcp_client INTERFACE
    mlua_mod_lwip
    mlua_mod_lwip.dns
    mlua_mod_lwip.tcp
    mlua_mod_mlua.io
    mlua_mod_mlua.time
    mlua_mod_pico.cyw43
    mlua_mod_pico.cyw43.util
    mlua_mod_pico.cyw43.wifi
    mlua_mod_string
)

mlua_add_executable(picow_tcp_client)
target_compile_definitions(picow_tcp_client PRIVATE
    LWIP_DHCP=1
    MLUA_MAIN_MODULE=picow_tcp_client
    MLUA_STDIO_INIT_USB=1
    PICO_STDIO_USB_CONNECT_WAIT_TIMEOUT_MS=1000
)
mlua_target_config(picow_tcp_client
    TEST_SERVER:string="${TEST_SERVER}"
    WIFI_PASSWORD:string="${WIFI_PASSWORD}"
    WIFI_SSID:string="${WIFI_SSID}"
)
target_link_libraries(picow_tcp_client PRIVATE
    mod_picow_tcp_client
    mlua_mod_mlua.stdio
    mlua_mod_pico.stdio.usb
    pico_stdlib
)
