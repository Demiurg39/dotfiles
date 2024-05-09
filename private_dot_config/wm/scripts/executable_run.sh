#!/bin/sh

# compositor
picom &

# Walpapers
sh ~/.fehbg &

# status bar
dash ~/.config/wm/scripts/bar.sh &
while type chadwm >/dev/null; do chadwm && continue || break; done
