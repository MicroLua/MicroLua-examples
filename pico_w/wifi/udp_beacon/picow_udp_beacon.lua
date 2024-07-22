-- Copyright 2024 Remy Blank <remy@c-space.org>
-- SPDX-License-Identifier: MIT

_ENV = module(...)

local lwip = require 'lwip'
local pbuf = require 'lwip.pbuf'
local udp = require 'lwip.udp'
local config = require 'mlua.config'
local io = require 'mlua.io'
local mem = require 'mlua.mem'
local time = require 'mlua.time'
local cyw43 = require 'pico.cyw43'
local util = require 'pico.cyw43.util'
local wifi = require 'pico.cyw43.wifi'

local UDP_PORT = 4444
local BEACON_MSG_LEN_MAX = 127
local BEACON_TARGET = "255.255.255.255"
local BEACON_INTERVAL = 1000 * time.msec

local function run_udp_beacon()
    local pcb<close> = udp.new(nil, 0)
    local addr = lwip.ipaddr_aton(BEACON_TARGET)
    local counter = 0
    while true do
        local p<close> = pbuf.alloc(pbuf.TRANSPORT, BEACON_MSG_LEN_MAX + 1)
        mem.fill(p)
        mem.write(p, ('%d\n'):format(counter))
        local ok, err = pcb:sendto(p, addr, UDP_PORT)
        p:free()
        if not ok then
            io.printf("Failed to send UDP packet: %s\n", lwip.err_str(err))
        else
            io.printf("Sent packet %d\n", counter)
            counter = counter + 1
        end
        time.sleep_for(BEACON_INTERVAL)
    end
end

function main()
    if not cyw43.init() then error("failed to initialize CYW43") end
    local cyw43_done<close> = cyw43.deinit
    if not lwip.init() then error("failed to initialize lwIP") end
    local lwip_done<close> = lwip.deinit
    wifi.set_up(cyw43.ITF_STA, true, cyw43.COUNTRY_WORLDWIDE)
    io.printf("Connecting to Wi-Fi...\n")
    local ok, msg = util.wifi_connect(
        config.WIFI_SSID, config.WIFI_PASSWORD, cyw43.AUTH_WPA2_AES_PSK,
        time.deadline(30 * time.sec))
    if not ok then error(("failed to connect: %s"):format(msg)) end
    io.printf("Connected\n")
    run_udp_beacon()
end
