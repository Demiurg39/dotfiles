#!/bin/sh

# X-server
xrdb merge ../.Xresources &
xbacklight -set 10 &
xset r rate 200 50 &
xsetroot -cursor_name left_ptr &
xinput set-prop 12 "libinput Tapping Enabled" 1 &
xinput set-prop 12 "libinput Natural Scrolling Enabled" 1 &
setxkbmap "us,ru" -option "grp:win_space_toggle" &

# compositor
picom &

# Walpapers
sh ~/.fehbg &

# status bar
dash ~/.config/wm/scripts/bar.sh &
while type chadwm >/dev/null; do chadwm && continue || break; done
