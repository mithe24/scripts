#!/bin/sh
# Utility for opening projects using dmenu.

PROJECTS="$HOME/dev"

choice=$(ls "$PROJECTS" | dmenu -i -l 5 -p "Projects:")

[ -z "$choice" ] && exit 0

"$TERMINAL" -e sh -c "cd '$PROJECTS/$choice' && exec '$SHELL'"
