#!/bin/bash

zig build

while true; do

    inotifywait -e modify,create,delete -r ./src/game &&
    zig build install && pgrep game | xargs kill -USR1

done
