#!/usr/bin/zsh


# Check if brain.fm is already running in special workspace
if hyprctl clients | grep  "special:brainfm"; then
    hyprctl dispatch togglespecialworkspace brainfm
else
    # Launch the launcher script in the background
    ~/.config/eww/scripts/launch_brainfm.sh &
fi
