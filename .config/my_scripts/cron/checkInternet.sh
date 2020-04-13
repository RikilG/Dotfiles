#!/bin/bash

/usr/bin/wget -q --tries=10 --timeout=10 --spider http://google.com
if [[ $? -eq 0 ]]; then
    /usr/bin/notify-send "Online" "This piece of plastic is online"
else
    /home/rikil/.config/my_scripts/sophosLogin.py
    if [[ $? -eq 0 ]]; then
        /usr/bin/notify-send "Logged into Sophos" "Sophos is watching you now!"
        # echo "Connected to sophos at $(/usr/bin/date)" >> /home/rikil/crontest.txt
    else
        /usr/bin/notify-send "Offline" "I'll be of less use offline"
    fi
fi
