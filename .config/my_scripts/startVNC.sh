#!/bin/bash

# check if VIRTUAL1 is disconnected

if xrandr | grep -i -u "VIRTUAL1" | grep " disconnected"; then
    echo "Setting up extended Display on VIRTUAL1"

    # create a display 
    Disp=$(cvt 1920 1080 | tail -n1)
    echo "Display created: $Disp"

    # extract the string to supply to new xrandr mode
    Conf=$(echo $Disp | sed 's/^Modeline //')
    echo "Configuration: $Conf"

    # set up new xrandr mode
    echo $Conf | xargs xrandr --newmode 
    echo "New xrandr mode set up"

    DispName=$(echo $Conf | awk '{ print $1 }' | sed 's/"//g')
    echo "Name of new Display: $DispName"

    # add mode to VIRTUAL1 (set this up before)
    xrandr --addmode VIRTUAL1 $DispName
    echo "Added created mode to VIRTUAL1"

    # set output
    xrandr --output VIRTUAL1 --mode $DispName --right-of eDP1
    echo "Output of new display set to right of DP1"
fi

echo "Starting VNC server"

# start VNC
x11vnc -display :0 -clip 1920x1080+1920+0
