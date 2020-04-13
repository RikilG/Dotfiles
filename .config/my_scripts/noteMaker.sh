#!/bin/bash

echo "$(xclip -out -selection primary)  " >> ~/SelectionNotes.md
if [[ $? -eq 0 ]]; then
    notify-send "selection copied" "to ~/SelectionNotes.md" -t 1000
else
    notify-send "Failed to copy selection" -t 5000
fi
