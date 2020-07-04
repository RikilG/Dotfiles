#!/bin/bash

if [[ $1 == "--help" || $1 == "-help" ]]; then
    echo "syntax: kdeconnect-notify.sh message [device-specifier]"
    echo 
    echo "If no specifier is provided and only 1 device is connected, it is selected automatically"
    echo "To list connected devices, run 'kdeconnect-cli -l'"
    exit 0
fi

Devices=$(kdeconnect-cli -l | grep -i "reachable")

if [[ -n $2 ]]; then
    Devices=$(echo $Devices | grep -i "$2")
fi

if [[ -z $Devices ]]; then
    echo "No reachable devices with the given specifier"
    exit 1
fi

if [[ $(echo "$Devices" | wc -l) != "1" ]]; then
    echo "Multiple devices found with the given specifier, please be more specific"
    exit 1
fi

DeviceID=$(echo "$Devices" | cut -d ":" -f 2 | cut -d " " -f 2)

kdeconnect-cli -d $DeviceID --ping-msg "$1"

exit $?