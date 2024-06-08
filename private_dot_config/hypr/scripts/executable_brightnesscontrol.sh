#!/usr/bin/env sh

# Function to print error message
print_error() {
cat << "EOF"
    ./brightnesscontrol.sh <action>
    ...valid actions are...
        i -- <i>ncrease brightness [+5%]
        d -- <d>ecrease brightness [-5%]
EOF
}

# Function to send notification
send_notification() {
    brightness=$(light -G | awk '{printf("%d\n", $1)}')
    # angle="$(((($brightness + 2) / 5) * 5))"
    # icon_path="$HOME/.config/dunst/icons/vol/vol-${angle}.svg"
    icon_path="$HOME/.config/dunst/icons/brightness/brightness-${brightness}.svg"
    bar=$(seq -s "▮" $(($brightness / 10)) | sed 's/[0-9]//g')
    notify-send -a "Brightness Control" -r 91190 -t 800 -i "${icon_path}" "Brightness: ${brightness}% ${bar}"
}

# Check and execute the action
case $1 in
i)  # increase the backlight
    light -A 5
    send_notification ;;
d)  # decrease the backlight
    current_brightness=$(light -G | awk '{printf("%d\n", $1)}')
    if [ "$current_brightness" -le 5 ]; then
        light -S 2
    else
        light -U 5
    fi
    send_notification ;;
*)  # print error
    print_error ;;
esac
