# Copyright 2023 Remy Blank <remy@c-space.org>
# SPDX-License-Identifier: MIT

mlua_add_fnl_modules(mlua_examples_fennel_blink_main
    blink_main.fnl
)
target_link_libraries(mlua_examples_fennel_blink_main INTERFACE
    mlua_mod_hardware_gpio
    mlua_mod_pico
    mlua_mod_pico_time
)

add_executable(mlua_examples_fennel_blink)
target_compile_definitions(mlua_examples_fennel_blink PRIVATE
    MLUA_MAIN_MODULE=blink_main
)
target_link_libraries(mlua_examples_fennel_blink PRIVATE
    mlua_examples_fennel_blink_main
    pico_stdlib
)
pico_add_extra_outputs(mlua_examples_fennel_blink)

mlua_add_fnl_modules(mlua_examples_fennel_hello_main
    hello_main.fnl
)
target_link_libraries(mlua_examples_fennel_hello_main INTERFACE
    mlua_mod_mlua_stdio
)

add_executable(mlua_examples_fennel_hello)
target_compile_definitions(mlua_examples_fennel_hello PRIVATE
    MLUA_MAIN_MODULE=hello_main
)
target_link_libraries(mlua_examples_fennel_hello PRIVATE
    mlua_examples_fennel_hello_main
    pico_stdlib
)
pico_add_extra_outputs(mlua_examples_fennel_hello)
