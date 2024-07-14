-- Copyright 2024 Remy Blank <remy@c-space.org>
-- SPDX-License-Identifier: MIT

_ENV = module(...)

local lwip = require 'lwip'
local dns = require 'lwip.dns'
local tcp = require 'lwip.tcp'
local config = require 'mlua.config'
local io = require 'mlua.io'
local time = require 'mlua.time'
local cyw43 = require 'pico.cyw43'
local util = require 'pico.cyw43.util'
local wifi = require 'pico.cyw43.wifi'
local string = require 'string'

local SERVER_ADDR = config.TEST_SERVER
local SERVER_PORT = 4242
local BUF_SIZE = 2048
local TEST_ITERATIONS = 10

function main()
    -- Connect to the network.
    if not cyw43.init() then error("failed to initialize CYW43") end
    local cyw43_done<close> = cyw43.deinit
    if not lwip.init() then error("failed to initialize lwIP") end
    local lwip_done<close> = lwip.deinit
    wifi.set_up(cyw43.ITF_STA, true, cyw43.COUNTRY_WORLDWIDE)
    io.printf("Connecting to Wi-Fi\n")
    local ok, msg = util.wifi_connect(config.WIFI_SSID, config.WIFI_PASSWORD,
                                      cyw43.AUTH_WPA2_AES_PSK, 30 * time.sec)
    if not ok then error(("failed to connect: %s"):format(msg)) end

    -- Resolve the server address.
    io.printf("Resolving %s\n", SERVER_ADDR)
    local addr = lwip.assert(dns.gethostbyname(SERVER_ADDR, nil,
                                               time.deadline(5 * time.sec)))
    io.printf("Resolved to %s\n", addr)

    -- Connect to the server.
    local pcb<close> = lwip.assert(tcp.new())
    io.printf("Connecting to server\n")
    lwip.assert(pcb:connect(addr, SERVER_PORT, time.deadline(10 * time.sec)))

    -- Perform the test iterations.
    io.printf("Performing test\n");
    for i = 1, TEST_ITERATIONS do
        local data = lwip.assert(io.read_all(pcb, BUF_SIZE))
        io.printf("Read %s bytes\n", #data)
        if #data ~= BUF_SIZE then error("wrong amount of data recv") end
        lwip.assert(pcb:send(data))
        io.printf("Wrote %s bytes\n", #data)
    end
    io.printf("Test completed\n")
end
