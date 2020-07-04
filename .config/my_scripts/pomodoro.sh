#!/bin/bash

# environment variables to hide qt warnings. remove these exports if you don't need them
export QT_SCALE_FACTOR=1
export QT_SCREEN_SCALE_FACTORS=1
export QT_DEVICE_PIXEL_RATIO=0
export QT_AUTO_SCREEN_SCALE_FACTOR=1

# user variables
runTime=50   # duration of a pomodoro, in minutes
pauseTime=10 # duration of small break, in minutes
breakTime=40 # duration of long break, after 3 pomodoros, in minutes
autoLock=1   # if NOT 0, the program will automatically lock you out after 3 pomodoros
programIcon=~/script_assets/timer.png
startMusic=~/Music/Electrical_Sweep-Sweeper.mp3
pauseMusic=~/Music/Electrical_Sweep-Sweeper.mp3
breakMusic=~/Music/Electrical_Sweep-Sweeper.mp3

# program variables
pomo=0
pomoDuration=$((60*runTime))
pauseDuration=$((60*pauseTime))
breakDuration=$((60*breakTime))

sigintHandler() { 
    # handle SIGINT call (CTRL-C)
    # set the pomodoro user variable to false if not required
    echo 0 > ~/userVars/pomodoro
    echo "See you later!"
    exit
}

pauseAudio() {
    /bin/bash -c "/usr/bin/amixer -q -D pulse sset Master mute; /usr/bin/killall -q -STOP 'pulseaudio'"
}

playAudio() {
    /bin/bash -c "/usr/bin/killall -q -CONT 'pulseaudio'; /usr/bin/amixer -q -D pulse sset Master unmute"
}

startPomodoro() {
    pomo=$((pomo+1))
    notify-send -i $programIcon "Pomodoro Level $pomo" "Timer for $runTime min is started" -t 5000 &
    mpg123 $startMusic > /dev/null 2>&1 &
    sleep $pomoDuration
}

pausePomodoro() {
    notify-send -i $programIcon "Pomodoro break!" "Get a break, have some water, be back in $pauseTime" -t 5000 &
    mpg123 $pauseMusic > /dev/null 2>&1 &
    if kdialog --yesno "Are you in a state of flow for the next pomodoro?"; then
        return 
    fi
    sleep $pauseDuration
    kdialog --msgbox "Click OK to start the next Pomodoro"
}

breakPomodoro() {
    mpg123 $breakMusic > /dev/null 2>&1 &
    if [[ -z $autoLock ]]; then
        kdialog --msgbox "Time for a looong break!, be back within $breakTime min" &
        sleep $breakDuration
    else
        kdialog --msgbox "Time for a looong break!, be back within $breakTime min, you will be locked out in 20 sec!" &
        sleep 20
        # send pause key to stop any playback from browser/players
        # xdotool key XF86AudioPlay &
        pauseAudio
        loginctl lock-session &
        sleep $((breakDuration - 21))
    fi
    kdialog --msgbox "Click OK to start the next Pomodoro"
}

startProgram() {
    # set the pomodoro flag in user variables
    # this is to be checked by any other script like a cron
    # job if required. Remove this echo statement if not required
    echo 1 > ~/userVars/pomodoro
    # start of program
    if kdialog --yesno "Do you want to run pomodoro timer?"; then
        echo "Let's get some serious work done!"
    else
        echo "*Sad noises..."
        exit
    fi
    while true; do
        startPomodoro # level 1
        pausePomodoro
        startPomodoro # level 2
        pausePomodoro
        startPomodoro # level 3
        breakPomodoro # long break
        pomo=0
    done
}

# setup SIGINT handler
trap sigintHandler SIGINT SIGTERM
# check if kdialog is present
if kdialog --help > /dev/null; then
    echo
else
    echo "This script uses kdialog which is not present on your system."
    exit 1
fi
# start program
startProgram

