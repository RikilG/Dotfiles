#!/bin/bash

echo "Searching for $1"
youtube-dl "ytsearch:$1" -f bestaudio -x --audio-quality 0 --audio-format mp3 --embed-thumbnail --external-downloader aria2c --external-downloader-args '-c -j 3 -x 3 -s 3 -k 1M' -o "/mnt/STASH/@RIKIL/my-music/%(title)s.%(ext)s"

# -x: extract audio only