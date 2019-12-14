#!/usr/bin/env bash

# Terminate already bar instances
killall -q polybar

# Wait until the processes have been shutdown
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Remove previous pid files
rm /tmp/ipc-mybar-top
rm /tmp/ipc-mybar-bottom

# Launch bars
# -r to reload when config changes
polybar -r top &
echo $! > /tmp/ipc-mybar-top 
polybar -r workspace &
echo $! > /tmp/ipc-mybar-workspace 
polybar -r windowtitle &
echo $! > /tmp/ipc-mybar-windowtitle 
#polybar -r bottom &
#echo $! > /tmp/ipc-mybar-bottom

echo "Bars Launched..."
