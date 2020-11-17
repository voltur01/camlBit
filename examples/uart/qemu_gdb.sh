#!/bin/bash

# to connect with arm-none-eabi-gdb use the following command:
# (gdb) target remote :1234

qemu-system-arm -M microbit -device loader,file=uart.hex \
    -nographic -monitor null -gdb tcp::1234 -S
