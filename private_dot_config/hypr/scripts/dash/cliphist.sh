#!/usr/bin/env sh

#// set variables

scrDir=$(dirname "$(realpath "$0")")
. "$scrDir/globalcontrol.sh"
roconf="${confDir}/rofi/clipboard.rasi"

#// set rofi scaling

if ! echo "$rofiScale" | grep -Eq '^[0-9]+$'; then
    rofiScale=10
fi
r_scale="configuration {font: \"JetBrainsMono Nerd Font ${rofiScale}\";}"
wind_border=$((hypr_border * 3 / 2))
if [ "$hypr_border" -eq 0 ]; then
    elem_border=5
else
    elem_border=$hypr_border
fi

#// evaluate spawn position

curPos=$(hyprctl cursorpos -j | jq -r '.x,.y')
monRes=$(hyprctl -j monitors | jq '.[] | select(.focused==true) | .width,.height,.scale,.x,.y')
offRes=$(hyprctl -j monitors | jq -r '.[] | select(.focused==true).reserved | map(tostring) | join("\n")')

curPosX=$(echo "$curPos" | sed -n 1p)
curPosY=$(echo "$curPos" | sed -n 2p)

monWidth=$(echo "$monRes" | sed -n 1p)
monHeight=$(echo "$monRes" | sed -n 2p)
monScale=$(echo "$monRes" | sed -n 3p)
monX=$(echo "$monRes" | sed -n 4p)
monY=$(echo "$monRes" | sed -n 5p)

offTop=$(echo "$offRes" | sed -n 1p)
offRight=$(echo "$offRes" | sed -n 2p)
offBottom=$(echo "$offRes" | sed -n 3p)
offLeft=$(echo "$offRes" | sed -n 4p)

monScale=$(echo "$monScale" | sed "s/\.//")
monWidth=$(( monWidth * 100 / monScale ))
monHeight=$(( monHeight * 100 / monScale ))
curPosX=$(( curPosX - monX ))
curPosY=$(( curPosY - monY ))

if [ "$curPosX" -ge "$((monWidth / 2))" ]; then
    x_pos="east"
    x_off="-$(( monWidth - curPosX - offRight ))"
else
    x_pos="west"
    x_off="$(( curPosX - offLeft ))"
fi

if [ "$curPosY" -ge "$((monHeight / 2))" ]; then
    y_pos="south"
    y_off="-$(( monHeight - curPosY - offBottom ))"
else
    y_pos="north"
    y_off="$(( curPosY - offTop ))"
fi

r_override="window{location:${x_pos} ${y_pos};anchor:${x_pos} ${y_pos};x-offset:${x_off}px;y-offset:${y_off}px;border:${hypr_width}px;border-radius:${wind_border}px;} wallbox{border-radius:${elem_border}px;} element{border-radius:${elem_border}px;}"

#// clipboard action

case "$1" in
    c|-c|--copy)
        cliphist list | rofi -dmenu -theme-str 'entry { placeholder: "Copy...";}' -theme-str "$r_scale" -theme-str "$r_override" -config "$roconf" | cliphist decode | wl-copy
        ;;
    d|-d|--delete)
        cliphist list | rofi -dmenu -theme-str 'entry { placeholder: "Delete...";}' -theme-str "$r_scale" -theme-str "$r_override" -config "$roconf" | cliphist delete
        ;;
    w|-w|--wipe)
        if [ "$(echo -e "Yes\nNo" | rofi -dmenu -theme-str 'entry { placeholder: "Clear Clipboard History?";}' -theme-str "$r_scale" -theme-str "$r_override" -config "$roconf")" = "Yes" ]; then
            cliphist wipe
        fi
        ;;
    *)
        echo -e "cliphist.sh [action]"
        echo "c -c --copy    :  cliphist list and copy selected"
        echo "d -d --delete  :  cliphist list and delete selected"
        echo "w -w --wipe    :  cliphist wipe database"
        exit 1
        ;;
esac
