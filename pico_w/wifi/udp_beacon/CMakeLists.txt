# Copyright 2024 Remy Blank <remy@c-space.org>
# SPDX-License-Identifier: MIT

mlua_add_lua_modules(mod_picow_udp_beacon picow_udp_beacon.lua)
target_link_libraries(mod_picow_udp_beacon INTERFACE
    mlua_mod_mlua.io
    mlua_mod_mlua.mem
    mlua_mod_mlua.time
    mlua_mod_pico.cyw43
    mlua_mod_pico.cyw43.util
    mlua_mod_pico.cyw43.wifi
    mlua_mod_pico.lwip
    mlua_mod_pico.lwip.pbuf
    mlua_mod_pico.lwip.udp
)

mlua_add_executable(picow_udp_beacon)
target_compile_definitions(picow_udp_beacon PRIVATE
    LWIP_DHCP=1
    MLUA_MAIN_MODULE=picow_udp_beacon
    MLUA_STDIO_INIT_USB=1
    PICO_STDIO_USB_CONNECT_WAIT_TIMEOUT_MS=1000
)
mlua_target_config(picow_udp_beacon
    WIFI_SSID:string="${WIFI_SSID}"
    WIFI_PASSWORD:string="${WIFI_PASSWORD}"
)
target_link_libraries(picow_udp_beacon PRIVATE
    mod_picow_udp_beacon
    mlua_mod_mlua.stdio
    mlua_mod_pico.stdio
    mlua_mod_pico.stdio.usb
    pico_stdlib
)
