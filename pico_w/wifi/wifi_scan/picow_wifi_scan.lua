-- Copyright 2024 Remy Blank <remy@c-space.org>
-- SPDX-License-Identifier: MIT

local io = require 'mlua.io'
local time = require 'mlua.time'
local cyw43 = require 'pico.cyw43'
local wifi = require 'pico.cyw43.wifi'
local string = require 'string'

local function escape(s)
    return s:gsub('([\0-\x1f\\])', function(c)
        return c == '\\' and '\\\\' or ('\\x%02x'):format(c:byte())
    end)
end

function main()
    if not cyw43.init() then error("failed to initialize CYW43") end
    local cyw43_done<close> = cyw43.deinit
    wifi.set_up(cyw43.ITF_STA, true, cyw43.COUNTRY_WORLDWIDE)
    while true do
        io.printf("\nStarting Wi-Fi scan\n")
        for result, dropped in wifi.scan() do
            io.printf("ssid: %-32s  rssi: %4d, chan: %3d, mac: %02x:%02x:%02x:%02x:%02x:%02x, sec: %u\n",
                      escape(result.ssid), result.rssi, result.channel,
                      result.bssid:byte(1), result.bssid:byte(2),
                      result.bssid:byte(3), result.bssid:byte(4),
                      result.bssid:byte(5), result.bssid:byte(6),
                      result.auth_mode)
            if dropped > 0 then io.printf("Dropped %s results\n", dropped) end
        end
        io.printf("Scan complete\n")
        time.sleep_for(10 * time.sec)
    end
end
