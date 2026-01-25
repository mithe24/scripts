#!/bin/sh
############################################################
# Utility for changing wallpaper and generating colorscheme.
# $1 - Picture to use as wallpaper
############################################################

wallust run $1
feh --bg-fill $1
xrdb -merge ~/.Xresources

# Send st signal to reload colors from Xresources
pidof st | xargs kill -s USR1
