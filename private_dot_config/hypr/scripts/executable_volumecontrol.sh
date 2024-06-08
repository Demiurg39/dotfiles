#!/usr/bin/env sh

scrDir=$(dirname "$(realpath "$0")")
source "$scrDir/globalcontrol.sh"

# Ensure DISPLAY is set
export DISPLAY=:0
export XDG_RUNTIME_DIR="/run/user/$(id -u)"

# Define functions

print_error() {
    cat << "EOF"
Usage: ./volumecontrol.sh -[device] <action>
  Valid devices:
    i   -- input device (microphone)
    o   -- output device (speaker)
    p   -- player application
  Valid actions:
    i   -- increase volume [+5]
    d   -- decrease volume [-5]
    m   -- mute/unmute
EOF
    exit 1
}

notify_vol() {
    angle="$(( (($vol + 2) / 5) * 5 ))"
    ico="${icodir}/vol-${angle}.svg"
    bar=$(printf '█%.0s' $(seq 1 $(($vol / 5))))
    dunstify -a "Volume Control" -r 91190 -t 800 -i "${ico}" "Volume: ${vol}% ${bar}" "${nsink}"
}

mute() {
    muted="$(pamixer "${srce}" --get-mute)"
    if $muted; then
        pamixer "${srce}" -u
        dunstify -a "VOLUME" "UNMUTED" -i "${icodir}/unmuted-${dvce}.svg" -r 2593 -t 800 -u normal
    else
        pamixer "${srce}" -m
        dunstify -a "VOLUME" "MUTED" -i "${icodir}/muted-${dvce}.svg" -r 2593 ut 800 -u normal
    fi
}

action_pamixer() {
    pamixer "${srce}" -"${1}" "${step}"
    vol=$(pamixer "${srce}" --get-volume)
}

action_playerctl() {
    [ "${1}" = "i" ] && pvl="+" || pvl="-"
    playerctl --player="${srce}" volume "0.0${step}${pvl}"
    vol=$(playerctl --player "${srce}" volume | awk '{ printf "%.0f\n", $0 * 100 }')
}

# Evaluate device option

while getopts iop: DeviceOpt; do
    case "${DeviceOpt}" in
        i)
            nsink=$(pamixer --list-sources | awk -F '"' 'END {print $(NF - 1)}')
            [ -z "${nsink}" ] && echo "ERROR: Input device not found..." && exit 1
            ctrl="pamixer"
            srce="--default-source"
            dvce="mic"
            ;;
        o)
            nsink=$(pamixer --get-default-sink | awk -F '"' 'END {print $(NF - 1)}')
            [ -z "${nsink}" ] && echo "ERROR: Output device not found..." && exit 1
            ctrl="pamixer"
            srce=""
            dvce="speaker"
            ;;
        p)
            nsink=$(playerctl --list-all | grep -w "${OPTARG}")
            [ -z "${nsink}" ] && echo "ERROR: Player ${OPTARG} not active..." && exit 1
            ctrl="playerctl"
            srce="${nsink}"
            ;;
        *)
            print_error
            ;;
    esac
done

# Set default variables

icodir="${confDir}/dunst/icons/vol"
shift $((OPTIND - 1))
step="${2:-5}"

# Execute action

case "${1}" in
    i)
        action_${ctrl} i
        notify_vol
        ;;
    d)
        action_${ctrl} d
        notify_vol
        ;;
    m)
        mute
        ;;
    *)
        print_error
        ;;
esac
