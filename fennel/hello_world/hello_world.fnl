; Copyright 2023 Remy Blank <remy@c-space.org>
; SPDX-License-Identifier: MIT

(local time (require :mlua.time))

(global main (fn []
  (while true
    (print "Hello, world!")
    (time.sleep_for time.sec))))
