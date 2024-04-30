# Copyright 2023 Remy Blank <remy@c-space.org>
# SPDX-License-Identifier: MIT

mlua_add_lua_modules(mlua_examples_adc_onboard_temperature_main
    onboard_temperature_main.lua
)
target_link_libraries(mlua_examples_adc_onboard_temperature_main INTERFACE
    mlua_mod_hardware.adc
    mlua_mod_hardware.gpio
    mlua_mod_mlua.stdio
    mlua_mod_pico
    mlua_mod_pico.time
    mlua_mod_string
)

add_executable(mlua_examples_adc_onboard_temperature)
target_compile_definitions(mlua_examples_adc_onboard_temperature PRIVATE
    MLUA_MAIN_MODULE=onboard_temperature_main
)
target_link_libraries(mlua_examples_adc_onboard_temperature PRIVATE
    mlua_examples_adc_onboard_temperature_main
    pico_stdlib
)
pico_add_extra_outputs(mlua_examples_adc_onboard_temperature)

mlua_add_lua_modules(mlua_examples_adc_onboard_temperature_irq_main
    onboard_temperature_irq_main.lua
)
target_link_libraries(mlua_examples_adc_onboard_temperature_irq_main INTERFACE
    mlua_mod_hardware.adc
    mlua_mod_hardware.gpio
    mlua_mod_mlua.stdio
    mlua_mod_mlua.thread
    mlua_mod_pico
    mlua_mod_string
)

add_executable(mlua_examples_adc_onboard_temperature_irq)
target_compile_definitions(mlua_examples_adc_onboard_temperature_irq PRIVATE
    MLUA_MAIN_MODULE=onboard_temperature_irq_main
)
target_link_libraries(mlua_examples_adc_onboard_temperature_irq PRIVATE
    mlua_examples_adc_onboard_temperature_irq_main
    pico_stdlib
)
pico_add_extra_outputs(mlua_examples_adc_onboard_temperature_irq)
