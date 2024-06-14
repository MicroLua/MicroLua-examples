# Copyright 2024 Remy Blank <remy@c-space.org>
# SPDX-License-Identifier: MIT

mlua_set(WIFI_SSID "" CACHE STRING "Compiled-in Wi-Fi SSID")
mlua_set(WIFI_PASSWORD "" CACHE STRING "Compiled-in Wi-Fi password")
mlua_set(TEST_SERVER "" CACHE STRING "Test server address")

add_subdirectory(blink)
add_subdirectory(ntp_client)
add_subdirectory(tcp_client)
add_subdirectory(udp_beacon)
add_subdirectory(wifi_scan)
