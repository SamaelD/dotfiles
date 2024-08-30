#!/bin/sh

set -e

ICONS="$HOME/.config/hypr/scripts/assets"

set_brightness() {
    brightnessctl set "$1"
}

get_brightness() {
    precentage=$(brightnessctl -m | cut -d, -f4)
    echo "${precentage%\%}"
}

get_icon() {
    current=$1
    if [ "$current" -le "20" ]; then
		icon="$ICONS/brightness-20.png"
	elif [ "$current" -le "40" ]; then
		icon="$ICONS/brightness-40.png"
	elif [ "$current" -le "60" ]; then
		icon="$ICONS/brightness-60.png"
	elif [ "$current" -le "80" ]; then
		icon="$ICONS/brightness-80.png"
	else
		icon="$ICONS/brightness-100.png"
	fi
    echo "$icon"
}

notify() {
    current=$(get_brightness)
    icon=$(get_icon "$current")
    notify-send -h string:x-canonical-private-synchronous:sys-notify -h int:value:"$current" -u low -i "$icon" "Brightness: ${current}%"
}

case "$1" in
    "up")
        set_brightness "+5%"
        notify
		;;
	"down")
		set_brightness "5%-"
        notify
		;;
	*)
		;;
esac
