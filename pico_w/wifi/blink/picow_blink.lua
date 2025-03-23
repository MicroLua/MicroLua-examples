-- Copyright 2024 Remy Blank <remy@c-space.org>
-- SPDX-License-Identifier: MIT

local time = require 'mlua.time'
local pico = require 'pico'
local cyw43 = require 'pico.cyw43'

function main()
    if not cyw43.init() then error("failed to initialize CYW43") end
    local cyw43_done<close> = cyw43.deinit
    local pin = pico.CYW43_WL_GPIO_LED_PIN
    while true do
        cyw43.gpio_set(pin, 1)
        time.sleep_for(250 * time.msec)
        cyw43.gpio_set(pin, 0)
        time.sleep_for(250 * time.msec)
    end
end
