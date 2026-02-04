#!/bin/sh
# Utility for opening projects using dmenu.

CONFIG="$HOME/.config"

choice=$(ls "$CONFIG" | dmenu -i -l 5 -p "Config:")

[ -z "$choice" ] && exit 0

"$TERMINAL" -e sh -c "cd '$CONFIG/$choice' && exec '$SHELL'"
