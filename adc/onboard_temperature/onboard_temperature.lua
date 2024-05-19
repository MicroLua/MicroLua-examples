-- Copyright 2023 Remy Blank <remy@c-space.org>
-- SPDX-License-Identifier: MIT

_ENV = module(...)

local adc = require 'hardware.adc'
local gpio = require 'hardware.gpio'
local time = require 'mlua.time'
local pico = require 'pico'
local string = require 'string'

local TEMPERATURE_UNIT = "C"
local conv = 3.3 / (1 << 12)

local function read_onboard_temperature(unit)
    local value = adc.read() * conv
    local temp = 27.0 - (value - 0.706) / 0.001721
    if unit == "F" then temp = temp * 9 / 5 + 32 end
    return temp
end

function main()
    -- Set up the LED pin.
    local led_pin = pico.DEFAULT_LED_PIN
    if led_pin then
        gpio.init(led_pin)
        gpio.set_dir(led_pin, gpio.OUT)
    end

    -- Configure the ADC.
    adc.init()
    adc.set_temp_sensor_enabled(true)
    adc.select_input(4)

    -- Perform conversions.
    while true do
        local temp = read_onboard_temperature(TEMPERATURE_UNIT)
        print(("Onboard temperature = %.2f %s"):format(
            temp, TEMPERATURE_UNIT))
        if led_pin then
            gpio.put(led_pin, 1)
            time.sleep_for(10 * time.msec)
            gpio.put(led_pin, 0)
        end
        time.sleep_for(990 * time.msec)
    end
end
