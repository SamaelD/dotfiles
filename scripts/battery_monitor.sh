#!/bin/bash

declare -A last_status
declare -A last_capacity

send_notification() {
    local device=$1
    local msg=$2
    notify-send -h string:x-canonical-private-synchronous:power-status "$device" "$msg"
}

udevadm monitor --udev --subsystem-match=power_supply --property |
while true; do
    dev=""
    status=""
    capacity=""

    while read -r line; do
        [[ -z "$line" ]] && break

        case "$line" in
            POWER_SUPPLY_NAME=*)
                dev=${line#*=}
                ;;
            POWER_SUPPLY_STATUS=*)
                status=${line#*=}
                ;;
            POWER_SUPPLY_CAPACITY=*)
                capacity=${line#*=}
                ;;
        esac
    done

    if [[ -n "$dev" && -n "$status" ]]; then
        if [[ "${last_status[$dev]}" != "$status" || "${last_capacity[$dev]}" != "$capacity" ]]; then
            last_status["$dev"]="$status"
            last_capacity["$dev"]="$capacity"

            case "$status" in
                Charging)
                    send_notification "$dev" "Charging started"
                    ;;
                Discharging)
                    if [[ -n "$capacity" && "$capacity" -le 20 ]]; then
                        send_notification "$dev" "Low battery: ${capacity}%"
                    else
                        send_notification "$dev" "Discharging"
                    fi
                    ;;
            esac
        fi
    fi
done

