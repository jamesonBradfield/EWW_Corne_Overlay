#!/bin/bash

# Path to the script
SCRIPT_DIR="$(dirname "$(realpath "$0")")"

# File to store the current rotation state
ROTATION_FILE="$SCRIPT_DIR/rotation_state.txt"

# Read the current rotation state
if [ -f "$ROTATION_FILE" ]; then
    CURRENT_ROTATION=$(cat "$ROTATION_FILE")
else
    CURRENT_ROTATION="normal"
fi

# Toggle between normal and 90
if [ "$CURRENT_ROTATION" = "normal" ]; then
    niri msg output eDP-1 transform 90
    echo "90" > "$ROTATION_FILE"
else
    niri msg output eDP-1 transform normal
    echo "normal" > "$ROTATION_FILE"
fi

# Update the eww button state
eww update rotation_state=$(cat "$ROTATION_FILE")
