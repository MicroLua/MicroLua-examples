# Copyright 2024 Remy Blank <remy@c-space.org>
# SPDX-License-Identifier: MIT

mlua_add_lua_modules(mod_picow_ntp_client picow_ntp_client.lua)
target_link_libraries(mod_picow_ntp_client INTERFACE
    mlua_mod_mlua.io
    mlua_mod_mlua.mem
    mlua_mod_mlua.time
    mlua_mod_pico.cyw43
    mlua_mod_pico.cyw43.util
    mlua_mod_pico.cyw43.wifi
    mlua_mod_pico.lwip
    mlua_mod_pico.lwip.dns
    mlua_mod_pico.lwip.pbuf
    mlua_mod_pico.lwip.udp
    mlua_mod_os
    mlua_mod_string
)

mlua_add_executable(picow_ntp_client)
target_compile_definitions(picow_ntp_client PRIVATE
    LWIP_DHCP=1
    MLUA_MAIN_MODULE=picow_ntp_client
    MLUA_STDIO_INIT_USB=1
    PICO_STDIO_USB_CONNECT_WAIT_TIMEOUT_MS=1000
)
mlua_target_config(picow_ntp_client
    WIFI_SSID:string="${WIFI_SSID}"
    WIFI_PASSWORD:string="${WIFI_PASSWORD}"
)
target_link_libraries(picow_ntp_client PRIVATE
    mod_picow_ntp_client
    mlua_mod_mlua.stdio
    mlua_mod_pico.stdio.usb
    pico_stdlib
)
