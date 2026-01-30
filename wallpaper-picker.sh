#!/bin/sh
# Pick a wallpaper using dmenu

WALLPAPER_DIR="$HOME/pictures/wallpaper"

pick_wallpaper() {
    choice=$(find "$WALLPAPER_DIR" -maxdepth 1 -type f -printf '%f\n' 2>/dev/null \
        | dmenu -i -l 5 -p "Wallpaper:")

    [ -n "$choice" ] || exit 0

    wallpaper "$WALLPAPER_DIR/$choice"
}

case $# in
    0)
        pick_wallpaper
        ;;
    1)
        wallpaper "$1"
        ;;
    *)
        exit 1
        ;;
esac
