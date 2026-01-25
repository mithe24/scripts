#!/bin/sh
# Program for picking wallpaper using Dmenu.

FOLDER="$HOME/pictures/wallpaper"

menu() {
    CHOICE=$(ls "$FOLDER" | dmenu -l 15 -i -p "Wallpaper: ")

    case "$CHOICE" in
        *.*)
            wallpaper "$FOLDER/$CHOICE"
            ;;
        *)
            exit 0
            ;;
       
    esac
}

case "$#" in
    0)
        menu
        ;;
    1)
        wallpaper "$1"
        ;;
    *)
        exit 0
        ;;
esac
