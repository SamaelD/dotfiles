#!/bin/sh

ENABLED=$(nmcli radio wifi)

if [ "$ENABLED" = "enabled" ]; then
    nmcli radio wifi off
else
    nmcli radio wifi on
fi
