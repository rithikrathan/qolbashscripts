#!/bin/bash
SEARCH_DIRS=("$HOME/Documents" "$HOME/Downloads" "$HOME/Pictures" "$HOME/Music" "$HOME/Videos" "$HOME/Desktop")

DIR=$( (printf "%s\n" "${SEARCH_DIRS[@]}"; fdfind --type d . "${SEARCH_DIRS[@]}" 2>/dev/null) \
    | rofi -dmenu -i -p "Search Dir: ")

[ -n "$DIR" ] && nautilus "$DIR" &

