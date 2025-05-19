#!/bin/bash
DIR=$(find ~/ -mindepth 1 -type d -printf '%d %p\n' 2>/dev/null \
    | sort -n \
    | cut -d' ' -f2- \
    | rofi -dmenu -i -p "Searcb for Dir: ")

[ -n "$DIR" ] && nautilus "$DIR" &

