-- Copyright 2023 Remy Blank <remy@c-space.org>
-- SPDX-License-Identifier: MIT

_ENV = module(...)

local gpio = require 'hardware.gpio'
local pico = require 'pico'
local time = require 'pico.time'

function main()
    local led_pin = pico.DEFAULT_LED_PIN
    gpio.init(led_pin)
    gpio.set_dir(led_pin, gpio.OUT)
    while true do
        gpio.put(led_pin, 1)
        time.sleep_ms(250)
        gpio.put(led_pin, 0)
        time.sleep_ms(250)
    end
end
