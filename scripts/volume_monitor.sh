#!/bin/bash

get_volume() {
    pactl get-sink-volume @DEFAULT_SINK@ | grep -oP '\d+(?=%)' | head -n 1
}

# Output initial volume
get_volume

# Monitor volume changes
pactl subscribe | grep --line-buffered "sink" | while read -r line; do
    get_volume
done
