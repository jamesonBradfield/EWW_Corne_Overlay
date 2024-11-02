#!/bin/bash

direction=$1
current_volume=$2
step=1
if [ "$direction" == "up" ]; then
    new_volume=$((current_volume + step))
    new_volume=$((new_volume > 100 ? 100 : new_volume))
    pactl set-sink-volume @DEFAULT_SINK@ +5%
else
    new_volume=$((current_volume - step))
    new_volume=$((new_volume < 0 ? 0 : new_volume))
    pactl set-sink-volume @DEFAULT_SINK@ -5%
fi

# Update the EWW variable
eww update volume_value=$new_volume
