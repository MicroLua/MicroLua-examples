<!-- Copyright 2023 Remy Blank <remy@c-space.org> -->
<!-- SPDX-License-Identifier: MIT -->

# MicroLua examples

This repository contains example programs for
[MicroLua](https://github.com/MicroLua/MicroLua).

## Building

```shell
# Configure the location of MicroLua. Adjust for your setup.
$ export MLUA_PATH="${HOME}/MicroLua"

# Clone the MicroLua-examples repository.
$ git clone https://github.com/MicroLua/MicroLua-examples.git
$ cd MicroLua-examples

# Build all examples.
$ cmake -B build -DPICO_BOARD=pico
$ cmake --build build --parallel=9

# Start the target in BOOTSEL mode and flash the "blink" example with picotool.
$ picotool load --update --execute build/blink/blink.elf --force-no-reboot

# Alternatively, start the target in BOOTSEL mode and copy to its boot drive.
$ cp build/blink/blink.uf2 /mnt/RPI-RP2/
```
