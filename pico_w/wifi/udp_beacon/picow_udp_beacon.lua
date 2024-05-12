-- Copyright 2024 Remy Blank <remy@c-space.org>
-- SPDX-License-Identifier: MIT

_ENV = module(...)

local config = require 'mlua.config'
local io = require 'mlua.io'
local mem = require 'mlua.mem'
local pico = require 'pico'
local cyw43 = require 'pico.cyw43'
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

local function connect(ssid, password, auth, timeout)
    local deadline = time.make_timeout_time_ms(timeout)
    local status = cyw43.LINK_NONET
    while true do
        if status == cyw43.LINK_NONET then
            local ok, err = wifi.join(ssid, password, auth)
            if not ok then return ok, pico.error_str(err) end
        end
        local st = cyw43.tcpip_link_status(cyw43.ITF_STA)
        if st ~= status then
            io.printf("Link status: %s\n", cyw43.link_status_str(st))
        end
        status = st
        if status == cyw43.LINK_UP then return true
        elseif status < 0 then return false, cyw43.link_status_str(status)
        elseif time.get_absolute_time_int() - deadline > 0 then
            return false, "connection timed out"
        end
        time.sleep_ms(500)
    end
end

function main()
    if not (cyw43.init() and lwip.init()) then
        io.printf("failed to initialize\n")
        return 1
    end

    wifi.set_up(cyw43.ITF_STA, true, cyw43.COUNTRY_WORLDWIDE)

    io.printf("Connecting to Wi-Fi...\n")
    local ok, msg = connect(config.WIFI_SSID, config.WIFI_PASSWORD,
                            cyw43.AUTH_WPA2_AES_PSK, 30000)
    if not ok then
        io.printf("failed to connect: %s\n", msg)
        return 1
    end
    io.printf("Connected.\n")
    run_udp_beacon()
end
