#!/bin/bash

JLink -device STM32L476RG -if SWD -speed 4000 << EOF
Connect
Halt
LoadFile build/Src/Blinky.hex
Reset
Go
EOF
