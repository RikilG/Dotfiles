#!/bin/bash

xcape -e 'Super_L=Control_L|Shift_L|Alt_L|Super_L|D'

if [[ -z $? ]]; then
    notify-send "ReBindKeys" "Super key rebind failed"
fi

xcape -t 300 -e 'Mode_switch=Escape'

if [[ -z $? ]]; then
    notify-send "ReBindKeys" "Caps-Lock to Esc rebind failed"
else
    notify-send "ReBindKeys" "Rebinded keys successfully!"
fi