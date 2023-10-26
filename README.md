# MicroLua examples

This repository contains example programs based on
[MicroLua](https://github.com/MicroLua/MicroLua) that demonstrate how to use the
features of the RP2040 from Lua.

## Building

```shell
# Configure the locations of the pico-sdk and MicroLua. Adjust to your setup.
$ export PICO_SDK_PATH="${HOME}/pico-sdk"
$ export MLUA_PATH="${HOME}/MicroLua"

# Clone the MicroLua-examples repository.
$ git clone https://github.com/MicroLua/MicroLua-examples.git
$ cd MicroLua-examples

# Build all examples.
$ cmake -s . -B build -DPICO_BOARD=pico
$ make -j9 -C build

# Flash the "blink" example to a target with a Picoprobe. Alternatively, start
# the target in BOOTSEL mode and copy build/blink/mlua_examples_blink.uf2 to its
# drive.
$ "${MLUA_PATH}/tools/flash" build/blink/mlua_examples_blink.elf
```
