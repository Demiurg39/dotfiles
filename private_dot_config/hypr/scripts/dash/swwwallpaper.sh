#!/usr/bin/env sh

# lock instance
lockFile="/tmp/hyde$(id -u)$(basename $0).lock"
[ -e "$lockFile" ] && echo "An instance of the script is already running..." && exit 1
touch "$lockFile"
trap 'rm -f $lockFile' EXIT

# specify wallpaper directory
wallpaperDir="$HOME/Pictures/Wallpapers" # измените путь к вашей папке с обоями

# define functions

Wall_Cache() {
    ln -fs "$(echo "$wallList" | sed -n "${setIndex}p")" "$wallSet"
    ln -fs "$(echo "$wallList" | sed -n "${setIndex}p")" "$wallCur"
    "$scrDir/swwwallcache.sh" -w "$(echo "$wallList" | sed -n "${setIndex}p")" > /dev/null
    "$scrDir/swwwallbash.sh" "$(echo "$wallList" | sed -n "${setIndex}p")" &
}

Wall_Change() {
    curWall=$(set_hash "$wallSet")
    indx=0
    for hash in $(echo "$wallHash"); do
        if [ "$curWall" = "$hash" ]; then
            if [ "$1" = "n" ]; then
                setIndex=$(( (indx + 1) % $(echo "$wallList" | wc -l) ))
            elif [ "$1" = "p" ]; then
                setIndex=$(( indx - 1 ))
            fi
            break
        fi
        indx=$((indx + 1))
    done
    Wall_Cache
}

# set variables

scrDir=$(dirname "$(realpath "$0")")
. "$scrDir/globalcontrol.sh"
wallSet="$cacheDir/wall.set"
wallCur="$cacheDir/wall.set"

# check wall

setIndex=0
[ ! -d "$wallpaperDir" ] && echo "ERROR: \"$wallpaperDir\" does not exist" && exit 1
wallList=$(find "$wallpaperDir" -type f \( -iname "*.jpg" -o -iname "*.png" \))
get_hashmap $wallList
[ ! -e "$(readlink -f "$wallSet")" ] && echo "fixing link :: $wallSet" && ln -fs "$(echo "$wallList" | head -1)" "$wallSet"

# evaluate options

while getopts "nps:" option; do
    case $option in
    n) # set next wallpaper
        xtrans="grow"
        Wall_Change n
        ;;
    p) # set previous wallpaper
        xtrans="outer"
        Wall_Change p
        ;;
    s) # set input wallpaper
        if [ -n "$OPTARG" ] && [ -f "$OPTARG" ]; then
            get_hashmap "$OPTARG"
        fi
        Wall_Cache
        ;;
    *) # invalid option
        echo "... invalid option ..."
        echo "$(basename "$0") -[option]"
        echo "n : set next wall"
        echo "p : set previous wall"
        echo "s : set input wallpaper"
        exit 1 ;;
    esac
done

# check swww daemon

swww query > /dev/null
if [ $? -ne 0 ]; then
    swww-daemon --format xrgb &
fi

# set defaults

[ -z "$xtrans" ] && xtrans="grow"
[ -z "$wallFramerate" ] && wallFramerate=60
[ -z "$wallTransDuration" ] && wallTransDuration=0.4

# apply wallpaper

echo ":: applying wall :: \"$(readlink -f "$wallSet")\""
swww img "$(readlink "$wallSet")" --transition-bezier .43,1.19,1,.4 --transition-type "$xtrans" --transition-duration "$wallTransDuration" --transition-fps "$wallFramerate" --invert-y --transition-pos "$(hyprctl cursorpos)" &
