#!/usr/bin/env sh

# hyde envs
confDir="${XDG_CONFIG_HOME:-$HOME/.config}"
hydeConfDir="${confDir}/hyde"
cacheDir="$HOME/.cache/hyde"
thmbDir="${cacheDir}/thumbs"
dcolDir="${cacheDir}/dcols"
hashMech="sha1sum"

export confDir hydeConfDir cacheDir thmbDir dcolDir hashMech

get_hashmap() {
    wallHash=""
    wallList=""
    skipStrays=""
    verboseMap=""

    for wallSource in "$@"; do
        [ -z "$wallSource" ] && continue
        [ "$wallSource" = "--skipstrays" ] && skipStrays=1 && continue
        [ "$wallSource" = "--verbose" ] && verboseMap=1 && continue

        hashMap=$(find "$wallSource" -type f \( -iname "*.gif" -o -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \) -exec "$hashMech" {} + | sort -k2)
        if [ -z "$hashMap" ]; then
            echo "WARNING: No image found in \"$wallSource\""
            continue
        fi

        while IFS= read -r line; do
            hash=$(echo "$line" | awk '{print $1}')
            image=$(echo "$line" | awk '{print $2}')
            wallHash="${wallHash}${hash}\n"
            wallList="${wallList}${image}\n"
        done <<EOF
$hashMap
EOF
    done

    if [ -z "$wallList" ]; then
        if [ "$skipStrays" = "1" ]; then
            return 1
        else
            echo "ERROR: No image found in any source"
            exit 1
        fi
    fi

    if [ "$verboseMap" = "1" ]; then
        echo "// Hash Map //"
        wallHashArray=$(echo -e "$wallHash")
        wallListArray=$(echo -e "$wallList")
        IFS=$'\n'
        indx=0
        for hash in $wallHashArray; do
            image=$(echo "$wallListArray" | sed "${indx}q;d")
            echo ":: \${wallHash[$indx]}=\"$hash\" :: \${wallList[$indx]}=\"$image\""
            indx=$((indx+1))
        done
    fi
}

get_themes() {
    thmSortS=""
    thmListS=""
    thmWallS=""
    thmSort=""
    thmList=""
    thmWall=""

    find "$hydeConfDir/themes" -mindepth 1 -maxdepth 1 -type d | while IFS= read -r thmDir; do
        if [ ! -e "$(readlink "$thmDir/wall.set")" ]; then
            get_hashmap "$thmDir" --skipstrays || continue
            echo "fixing link :: $thmDir/wall.set"
            ln -fs "$(echo -e "$wallList" | head -1)" "$thmDir/wall.set"
        fi
        [ -f "$thmDir/.sort" ] && thmSortS="${thmSortS}$(head -1 "$thmDir/.sort")\n" || thmSortS="${thmSortS}0\n"
        thmListS="${thmListS}$(basename "$thmDir")\n"
        thmWallS="${thmWallS}$(readlink "$thmDir/wall.set")\n"
    done > /tmp/thmDirs.txt

    while IFS= read -r line; do
        sort=$(echo "$line" | awk '{print $1}')
        theme=$(echo "$line" | awk '{print $2}')
        wall=$(echo "$line" | awk '{print $3}')
        thmSort="${thmSort}${sort}\n"
        thmList="${thmList}${theme}\n"
        thmWall="${thmWall}${wall}\n"
    done < /tmp/thmDirs.txt

    if [ "$1" = "--verbose" ]; then
        echo "// Theme Control //"
        thmSortArray=$(echo -e "$thmSort")
        thmListArray=$(echo -e "$thmList")
        thmWallArray=$(echo -e "$thmWall")
        IFS=$'\n'
        indx=0
        for sort in $thmSortArray; do
            theme=$(echo "$thmListArray" | sed "${indx}q;d")
            wall=$(echo "$thmWallArray" | sed "${indx}q;d")
            echo ":: \${thmSort[$indx]}=\"$sort\" :: \${thmList[$indx]}=\"$theme\" :: \${thmWall[$indx]}=\"$wall\""
            indx=$((indx+1))
        done
    fi
}

. "$hydeConfDir/hyde.conf"

case "$enableWallDcol" in
    0 | 1 | 2 | 3) ;;
    *) enableWallDcol=0 ;;
esac

if [ -z "$hydeTheme" ] || [ ! -d "$hydeConfDir/themes/$hydeTheme" ]; then
    get_themes
    hydeTheme=$(echo -e "$thmList" | head -1)
fi

export hydeTheme
export hydeThemeDir="$hydeConfDir/themes/$hydeTheme"
export wallbashDir="$hydeConfDir/wallbash"
export enableWallDcol

# hypr vars

if printenv HYPRLAND_INSTANCE_SIGNATURE >/dev/null 2>&1; then
    hypr_border=$(hyprctl -j getoption decoration:rounding | jq '.int')
    hypr_width=$(hyprctl -j getoption general:border_size | jq '.int')
    export hypr_border hypr_width
fi

# extra fns

pkg_installed() {
    local pkgIn="$1"
    if pacman -Qi "$pkgIn" >/dev/null 2>&1; then
        return 0
    elif pacman -Qi "flatpak" >/dev/null 2>&1 && flatpak info "$pkgIn" >/dev/null 2>&1; then
        return 0
    elif command -v "$pkgIn" >/dev/null 2>&1; then
        return 0
    else
        return 1
    fi
}

get_aurhlpr() {
    if pkg_installed yay; then
        aurhlpr="yay"
    elif pkg_installed paru; then
        aurhlpr="paru"
    fi
}

set_conf() {
    local varName="$1"
    local varData="$2"
    touch "$hydeConfDir/hyde.conf"

    if [ "$(grep -c "^$varName=" "$hydeConfDir/hyde.conf")" -eq 1 ]; then
        sed -i "/^$varName=/c$varName=\"$varData\"" "$hydeConfDir/hyde.conf"
    else
        echo "$varName=\"$varData\"" >>"$hydeConfDir/hyde.conf"
    fi
}

set_hash() {
    local hashImage="$1"
    "$hashMech" "$hashImage" | awk '{print $1}'
}
