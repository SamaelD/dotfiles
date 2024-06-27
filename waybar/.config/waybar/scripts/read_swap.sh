#!/bin/sh

swap_info=$(free -m | awk '/Swap/ {print $2, $3}')

read -r swap_total swap_used <<< "$swap_info"

if [ "$swap_total" -ne 0 ]; then
    # Calculate the percentage of swap used
    swap_used_percent=$(( 100 * swap_used / swap_total ))
else
    swap_used_percent=0
fi

echo "$swap_used_percent"
