-- Copyright 2023 Remy Blank <remy@c-space.org>
-- SPDX-License-Identifier: MIT

local gpio = require 'hardware.gpio'
local time = require 'mlua.time'
local pico = require 'pico'

function main()
    local led_pin = pico.DEFAULT_LED_PIN
    gpio.init(led_pin)
    gpio.set_dir(led_pin, gpio.OUT)
    while true do
        gpio.put(led_pin, 1)
        time.sleep_for(250 * time.msec)
        gpio.put(led_pin, 0)
        time.sleep_for(250 * time.msec)
    end
end
