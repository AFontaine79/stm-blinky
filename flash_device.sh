#!/bin/bash

JLink -device STM32L476RG -if SWD -speed 4000 << EOF
connect
halt
loadfile build/stm/debug/Src/Blinky.hex
r
go
EOF
