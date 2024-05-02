; Copyright 2023 Remy Blank <remy@c-space.org>
; SPDX-License-Identifier: MIT

(global _ENV (module ...))

(local time (require :pico.time))

(global main (fn []
  (while true
    (print "Hello, world!")
    (time.sleep_ms 1000))))
