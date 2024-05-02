# MicroLua examples

<!-- Copyright 2023 Remy Blank <remy@c-space.org> -->
<!-- SPDX-License-Identifier: MIT -->

This repository contains example programs for
[MicroLua](https://github.com/MicroLua/MicroLua).

## Building

```shell
# Configure the locations of the Pico SDK and MicroLua. Adjust for your setup.
$ export PICO_SDK_PATH="${HOME}/pico-sdk"
$ export MLUA_PATH="${HOME}/MicroLua"

# Clone the MicroLua-examples repository.
$ git clone https://github.com/MicroLua/MicroLua-examples.git
$ cd MicroLua-examples

# Build all examples.
$ cmake -B build -DPICO_BOARD=pico
$ cmake --build build --parallel=9

# Start the target in BOOTSEL mode and flash the "blink" example with picotool.
$ picotool load -u -x build/blink/blink.elf

# Alternatively, start the target in BOOTSEL mode and copy to its boot drive.
$ cp build/blink/blink.uf2 /mnt/RPI-RP2/
```
