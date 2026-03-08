#!/bin/sh
# Utility for opening projects using dmenu.

PROJECTS="$XDG_WORK_DIR"

choice=$(ls "$PROJECTS" | dmenu -i -l 5 -p "Projects:")

[ -z "$choice" ] && exit 0

"$TERMINAL" -e sh -c "cd '$PROJECTS/$choice' && exec '$SHELL'"
