#!/bin/bash

ErrCount=0

echo "Run with sudo"
sudo mount -o remount,exec /dev/sda5 /mnt/STASH
ErrCount=$((ErrCount+$?))
sudo mount -o remount,exec /dev/sda4 /mnt/DC
ErrCount=$((ErrCount+$?))
sudo mount -o remount,exec /dev/sda3 /mnt/Win10
ErrCount=$((ErrCount+$?))

if [[ -z ErrCount ]]; then
    notify-send "Remount" "remount failed! Code: $ErrCount"
    echo "Error $ErrCount"
else
    notify-send "Remount" "Remounted all drives successfully!"
fi