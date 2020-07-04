#!/bin/bash

if [[ -n ~/userVars/pomodoro ]]; then
    # if pomodoro timer is running pause this program
    exit
fi

notify-send "Sedentary Reminder" "Relax for a moment, get a glass of water and log your activities before continuing!" -t 10000

mpg123 /home/rikil/Music/Electrical_Sweep-Sweeper.mp3 > /dev/null 2>&1
