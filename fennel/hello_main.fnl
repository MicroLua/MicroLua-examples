; Copyright 2023 Remy Blank <remy@c-space.org>
; SPDX-License-Identifier: MIT

(global _ENV (mlua.Module ...))

(global main (fn []
    (print "Hello, world!")
))
