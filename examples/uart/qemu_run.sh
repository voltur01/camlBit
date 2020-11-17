#!/bin/bash

qemu-system-arm -M microbit -device loader,file=uart.hex \
    -nographic -monitor null
