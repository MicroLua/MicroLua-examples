-- Copyright 2024 Remy Blank <remy@c-space.org>
-- SPDX-License-Identifier: MIT

_ENV = module(...)

local config = require 'mlua.config'
local io = require 'mlua.io'
local mem = require 'mlua.mem'
local pico = require 'pico'
local cyw43 = require 'pico.cyw43'
local util = require 'pico.cyw43.util'
local wifi = require 'pico.cyw43.wifi'
local lwip = require 'pico.lwip'
local pbuf = require 'pico.lwip.pbuf'
local udp = require 'pico.lwip.udp'
local time = require 'pico.time'

local UDP_PORT = 4444
local BEACON_MSG_LEN_MAX = 127
local BEACON_TARGET = "255.255.255.255"
local BEACON_INTERVAL_MS = 1000

local function run_udp_beacon()
    local pcb<close> = udp.new()
    local addr = lwip.ipaddr_aton(BEACON_TARGET)
    local counter = 0
    while true do
        local p<close> = pbuf.alloc(pbuf.TRANSPORT, BEACON_MSG_LEN_MAX + 1)
        mem.fill(p)
        mem.write(p, ('%d\n'):format(counter))
        local ok, err = pcb:sendto(p, addr, UDP_PORT)
        p:free()
        if not ok then
            io.printf("Failed to send UDP packet! error=%s\n", err)
        else
            io.printf("Sent packet %d\n", counter)
            counter = counter + 1
        end

        time.sleep_ms(BEACON_INTERVAL_MS)
    end
end

function main()
    if not (cyw43.init() and lwip.init()) then
        io.printf("failed to initialize\n")
        return 1
    end

    wifi.set_up(cyw43.ITF_STA, true, cyw43.COUNTRY_WORLDWIDE)

    io.printf("Connecting to Wi-Fi...\n")
    local ok, msg = util.wifi_connect(config.WIFI_SSID, config.WIFI_PASSWORD,
                                      cyw43.AUTH_WPA2_AES_PSK, 30000)
    if not ok then
        io.printf("failed to connect: %s\n", msg)
        return 1
    end
    io.printf("Connected.\n")
    run_udp_beacon()
end
