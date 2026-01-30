#!/bin/sh
# Utility for opening documents using dmenu.

DOCS="$HOME/documents"

choice=$(find "$DOCS" -type f 2>/dev/null \
    | sed "s|^$DOCS/||" \
    | dmenu -i -l 5 -p "Documents:")

[ -z "$choice" ] && exit 0

xdg-open "$DOCS/$choice" >/dev/null 2>&1 &
