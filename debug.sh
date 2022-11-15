#!/bin/bash

ERROR=$(iverilog -o fir_filter.vvp ./tb/testbench.v ./src/fir_filter.v 2>&1 > /dev/null)
if [ "$ERROR" ]; then
    echo "Error in verification"
    echo "$ERROR"
    exit 1
fi
vvp fir_filter.vvp &
sleep 1
kill -9 $!
../gtkwave/bin/gtkwave.exe fir_filter.vcd
