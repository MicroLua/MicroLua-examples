# Copyright 2023 Remy Blank <remy@c-space.org>
# SPDX-License-Identifier: MIT

mlua_add_lua_modules(mod_adc_onboard_temperature onboard_temperature.lua)
target_link_libraries(mod_adc_onboard_temperature INTERFACE
    mlua_mod_hardware.adc
    mlua_mod_hardware.gpio
    mlua_mod_pico
    mlua_mod_pico.time
    mlua_mod_string
)

add_executable(onboard_temperature)
target_compile_definitions(onboard_temperature PRIVATE
    MLUA_MAIN_MODULE=onboard_temperature
    MLUA_STDIO_INIT_USB=1
    PICO_STDIO_USB_CONNECT_WAIT_TIMEOUT_MS=1000
)
target_link_libraries(onboard_temperature PRIVATE
    mlua_mod_mlua.stdio
    mlua_mod_pico.stdio
    mlua_mod_pico.stdio.usb
    mod_adc_onboard_temperature
    pico_stdlib
)
pico_add_extra_outputs(onboard_temperature)


mlua_add_lua_modules(mod_adc_onboard_temperature_irq
    onboard_temperature_irq.lua
)
target_link_libraries(mod_adc_onboard_temperature_irq INTERFACE
    mlua_mod_hardware.adc
    mlua_mod_hardware.gpio
    mlua_mod_pico
    mlua_mod_string
)

add_executable(onboard_temperature_irq)
target_compile_definitions(onboard_temperature_irq PRIVATE
    MLUA_MAIN_MODULE=onboard_temperature_irq
    MLUA_STDIO_INIT_USB=1
    PICO_STDIO_USB_CONNECT_WAIT_TIMEOUT_MS=1000
)
target_link_libraries(onboard_temperature_irq PRIVATE
    mlua_mod_mlua.stdio
    mlua_mod_mlua.thread
    mlua_mod_pico.stdio
    mlua_mod_pico.stdio.usb
    mod_adc_onboard_temperature_irq
    pico_stdlib
)
pico_add_extra_outputs(onboard_temperature_irq)
