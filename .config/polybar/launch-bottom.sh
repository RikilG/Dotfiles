#!/usr/bin/env bash

# Remove previous pid files
rm /tmp/ipc-mybar-bottom

# Launch bars
# -r to reload when config changes
polybar -r bottom &
echo $! > /tmp/ipc-mybar-bottom

echo "Bottom bar Launched..."
