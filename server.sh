#!/bin/bash

while true; do
    watch -n 0.1 -t -g ls -l -R --time-style=full-iso src/game && \
    zig build install -fincremental && \
    pkill -USR1 game
done