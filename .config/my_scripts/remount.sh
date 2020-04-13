#!/bin/bash

echo "Run with sudo"
sudo mount -o remount,exec /dev/sda5 /mnt/STASH
sudo mount -o remount,exec /dev/sda4 /mnt/DC
sudo mount -o remount,exec /dev/sda3 /mnt/Win10
