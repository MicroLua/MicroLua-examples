; Copyright 2023 Remy Blank <remy@c-space.org>
; SPDX-License-Identifier: MIT

(global _ENV (mlua.module ...))

(global main (fn []
  (print "Hello, world!")))
