# Copyright 2024 Remy Blank <remy@c-space.org>
# SPDX-License-Identifier: MIT

mlua_set(WIFI_SSID "" CACHE STRING "Compiled-in WiFi SSID")
mlua_set(WIFI_PASSWORD "" CACHE STRING "Compiled-in WiFi password")

add_subdirectory(blink)
