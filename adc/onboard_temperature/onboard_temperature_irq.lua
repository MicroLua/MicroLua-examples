-- Copyright 2023 Remy Blank <remy@c-space.org>
-- SPDX-License-Identifier: MIT

_ENV = module(...)

local adc = require 'hardware.adc'
local gpio = require 'hardware.gpio'
local pico = require 'pico'
local string = require 'string'

local TEMPERATURE_UNIT = "C"
local conv = 3.3 / (1 << 12)

local function read_onboard_temperature(unit)
    local value = adc.fifo_get_blocking() * conv
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
    adc.fifo_setup(true, false, 1, false, false)
    adc.set_clkdiv(48000 - 1)
    adc.fifo_drain()
    adc.fifo_enable_irq()
    adc.run(true)

    -- Read from the ADC FIFO.
    local cnt = 0
    while true do
        local temp = read_onboard_temperature(TEMPERATURE_UNIT)
        cnt = cnt + 1
        if cnt < 1000 then goto continue end
        cnt = 0
        print(("Onboard temperature = %.2f %s"):format(
            temp, TEMPERATURE_UNIT))
        if led_pin then gpio.xor_mask(1 << led_pin) end
        ::continue::
    end
end
