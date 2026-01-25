#!/bin/sh
############################################################
# Utility for prompting user affirmation before executing a
# command.
# $1 - Prompt message
# $2 - Command to execute if affirmed
############################################################
[ $(echo "No\nYes" | dmenu -i -p "$1") = "Yes" ] && $2
