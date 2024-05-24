-- Copyright 2024 Remy Blank <remy@c-space.org>
-- SPDX-License-Identifier: MIT

_ENV = module(...)

local config = require 'mlua.config'
local io = require 'mlua.io'
local mem = require 'mlua.mem'
local time = require 'mlua.time'
local cyw43 = require 'pico.cyw43'
local util = require 'pico.cyw43.util'
local wifi = require 'pico.cyw43.wifi'
local lwip = require 'pico.lwip'
local dns = require 'pico.lwip.dns'
local pbuf = require 'pico.lwip.pbuf'
local udp = require 'pico.lwip.udp'
local os = require 'os'
local string = require 'string'

local NTP_SERVER = 'pool.ntp.org'
local NTP_MSG_LEN = 48
local NTP_PORT = 123
local NTP_DELTA = -2085978496  -- Seconds between 1900-01-01 and 1970-01-01

local function request(pcb, addr)
    local p<close> = pbuf.alloc(pbuf.TRANSPORT, NTP_MSG_LEN)
    mem.fill(p)
    mem.set(p, 0, 0x1b)  -- version: 3, mode: client
    pcb:sendto(p, addr, NTP_PORT)
end

local function receive(pcb, addr, deadline)
    while true do
        local p<close>, saddr, port = pcb:recv(deadline)
        if not p then return io.printf("Receive timeout\n") end
        if saddr == addr and port == NTP_PORT and #p == NTP_MSG_LEN then
            local mode, stratum = mem.get(p, 0, 2)
            if mode & 0x3f == 0x1c and stratum ~= 0 then
                local txts = ('>I4'):unpack(mem.read(p, 40, 4))
                -- TODO: The following line will break on 2036-02-07, when NTP
                --       timestamps roll over.
                local utc = os.date('!*t', (txts - NTP_DELTA) & 0x7fffffff)
                io.printf("NTP response: %04d-%02d-%02d %02d:%02d:%02d\n",
                          utc.year, utc.month, utc.day, utc.hour, utc.min,
                          utc.sec)
                return
            end
        end
        io.printf("Invalid NTP response\n")
    end
end

local function run_ntp_test()
    local pcb<close> = udp.new(nil, 4)
    if not pcb then error("failed to create pcb") end
    while true do
        local addr, err = dns.gethostbyname(NTP_SERVER, nil,
                                            time.deadline(5 * time.sec))
        if addr then
            io.printf("NTP server address: %s\n", addr)
            request(pcb, addr)
            receive(pcb, addr, time.deadline(5 * time.sec))
        elseif addr == false then
            io.printf("DNS request failed: host not found\n")
        else
            io.printf("DNS request failed: %s\n", lwip.err_str(err))
        end
        time.sleep_for(5 * time.sec)
    end
end

function main()
    if not (cyw43.init() and lwip.init()) then error("failed to initialize") end
    wifi.set_up(cyw43.ITF_STA, true, cyw43.COUNTRY_WORLDWIDE)
    io.printf("Connecting to Wi-Fi...\n")
    local ok, msg = util.wifi_connect(config.WIFI_SSID, config.WIFI_PASSWORD,
                                      cyw43.AUTH_WPA2_AES_PSK, 30 * time.sec)
    if not ok then error(("failed to connect: %s"):format(msg)) end
    io.printf("Connected\n")
    run_ntp_test()
end
