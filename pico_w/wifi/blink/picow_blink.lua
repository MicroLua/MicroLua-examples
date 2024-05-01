-- Copyright 2024 Remy Blank <remy@c-space.org>
-- SPDX-License-Identifier: MIT

_ENV = module(...)

local cyw43 = require 'pico.cyw43'
local pico = require 'pico'
local time = require 'pico.time'

function main()
    if not cyw43.init() then
        print("Wi-Fi init failed")
        return
    end
    local pin = pico.CYW43_WL_GPIO_LED_PIN
    while true do
        cyw43.gpio_set(pin, 1)
        time.sleep_ms(250)
        cyw43.gpio_set(pin, 0)
        time.sleep_ms(250)
    end
end
