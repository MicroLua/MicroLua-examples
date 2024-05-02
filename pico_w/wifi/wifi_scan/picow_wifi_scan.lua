-- Copyright 2024 Remy Blank <remy@c-space.org>
-- SPDX-License-Identifier: MIT

_ENV = module(...)

local io = require 'mlua.io'
local cyw43 = require 'pico.cyw43'
local wifi = require 'pico.cyw43.wifi'
local time = require 'pico.time'

local function scan_result(result, dropped)
    io.printf("ssid: %-32s rssi: %4d chan: %3d mac: %02x:%02x:%02x:%02x:%02x:%02x sec: %u\n",
              result.ssid, result.rssi, result.channel,
              result.bssid:byte(1), result.bssid:byte(2),
              result.bssid:byte(3), result.bssid:byte(4),
              result.bssid:byte(5), result.bssid:byte(6),
              result.auth_mode)
    if dropped > 0 then io.printf("Dropped %s results\n", dropped) end
end

function main()
    if not cyw43.init() then
        io.printf("failed to initialize\n")
        return 1
    end

    wifi.set_up(cyw43.ITF_STA, true, cyw43.COUNTRY_WORLDWIDE)

    local scan_time = time.nil_time
    local scan_in_progress = false
    while true do
        if time.absolute_time_diff_us(time.get_absolute_time(), scan_time) < 0 then
            if not scan_in_progress then
                if wifi.scan(nil, scan_result) then
                    io.printf("\nPerforming wifi scan\n")
                    scan_in_progress = true
                else
                    io.printf("Failed to start scan: %s\n", err)
                    scan_time = time.make_timeout_time_ms(10000)  -- Wait 10s and scan again
                end
            elseif not wifi.scan_active() then
                scan_time = time.make_timeout_time_ms(10000)  -- Wait 10s and scan again
                scan_in_progress = false
            end
        end

        -- This sleep is just an example of some (blocking) work you might be
        -- doing.
        time.sleep_ms(1000)
    end
end
