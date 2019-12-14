#!/bin/sh

# copy to /usr/local/bin

PID=`ps -ef | grep "polybar -r bottom" | grep -v grep | awk '{print $2}'`

if [[ "" != "$PID" ]]; then
	kill $PID
	echo "Closed Control center."
else
	$HOME/.config/polybar/launch-bottom.sh
	sleep 5
	PID=`ps -ef | grep "polybar -r bottom" | grep -v grep | awk '{print $2}'`
	MOUSE_Y=`xdotool getmouselocation | awk '{print $2}' | cut -d':' -f2`
	while [[ MOUSE_Y -gt 963 ]]
	do
		MOUSE_Y=`xdotool getmouselocation | awk '{print $2}' | cut -d':' -f2`
	done
	sleep 1
	kill $PID
fi
