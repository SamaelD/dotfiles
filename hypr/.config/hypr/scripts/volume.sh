#!/bin/sh

set -e

ICONS="$HOME/.config/hypr/scripts/assets"

set_volume_up() {
    pamixer -i 1
}

set_volume_down() {
    pamixer -d 1
}

get_volume() {
    volume=$(pamixer --get-volume)
	echo "$volume"
}

get_icon() {
    current=$1
    if [ "$current" -eq "0" ]; then
		icon="$ICONS/volume-mute.png"
	elif [ "$current" -ge "0" ] && [ "$current" -le "30" ]; then
		icon="$ICONS/volume-low.png"
	elif [ "$current" -ge "30" ] && [ "$current" -le "60" ]; then
		icon="$ICONS/volume-mid.png"
	elif [ "$current" -ge "60" ] && [ "$current" -le "100" ]; then
		icon="$ICONS/volume-high.png"
	fi
    echo "$icon"
}

notify() {
    current=$(get_volume)
    icon=$(get_icon "$current")
    notify-send -h string:x-canonical-private-synchronous:sys-notify -h int:value:"$current" -u low -i "$icon" "Volume: ${current}%"
}

case "$1" in
    "up")
        set_volume_up
        notify
		;;
	"down")
        set_volume_down
        notify
		;;
	*)
		;;
esac
