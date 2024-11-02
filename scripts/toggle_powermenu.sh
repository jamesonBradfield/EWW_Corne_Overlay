#!/usr/bin/zsh
# Check if argument is provided
if [ -z "$1" ]; then
    echo "Please provide a monitor number (0 or 1)"
    exit 1
fi

# Get the monitor number
monitor=$1

# Check if the specific powermenu window is currently open
if eww active-windows | grep "powermenu-$monitor"; then
    eww close "powermenu-$monitor"
else
    eww open "powermenu-$monitor"
fi

