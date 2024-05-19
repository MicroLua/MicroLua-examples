-- Copyright 2024 Remy Blank <remy@c-space.org>
-- SPDX-License-Identifier: MIT

_ENV = module(...)

local io = require 'mlua.io'
local time = require 'mlua.time'
local cyw43 = require 'pico.cyw43'
local wifi = require 'pico.cyw43.wifi'

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
        io.printf("Failed to initialize\n")
        return 1
    end
    wifi.set_up(cyw43.ITF_STA, true, cyw43.COUNTRY_WORLDWIDE)
    local scan_time = time.min_ticks
    local scan_in_progress = false
    while true do
        if time.compare(time.ticks(), scan_time) >= 0 then
            if not scan_in_progress then
                if wifi.scan(nil, scan_result) then
                    io.printf("\nPerforming wifi scan\n")
                    scan_in_progress = true
                else
                    io.printf("Failed to start scan: %s\n", err)
                    scan_time = time.deadline(10 * time.sec)
                end
            elseif not wifi.scan_active() then
                scan_time = time.deadline(10 * time.sec)
                scan_in_progress = false
            end
        end
        time.sleep_for(time.sec)
    end
end
