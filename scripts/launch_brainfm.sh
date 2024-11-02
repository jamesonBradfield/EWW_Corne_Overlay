#!/bin/bash

# Launch Firefox with brain.fm
firefox --new-window "https://brain.fm" &
# Wait for window to appear
sleep 2
# Move to special workspace
hyprctl dispatch movetoworkspace special:brainfm
# Show the workspace
hyprctl dispatch togglespecialworkspace brainfm
