#!/bin/bash

source "$HOME/.config/sketchybar/colors.sh"
source "$HOME/.config/sketchybar/icons.sh"

# Get volume info
VOLUME=$(osascript -e "output volume of (get volume settings)")
MUTED=$(osascript -e "output muted of (get volume settings)")

# Set volume icon based on volume level
if [[ $MUTED == "true" ]]; then
  ICON=$VOLUME_0
  COLOR=$RED
elif [[ $VOLUME -ge 66 ]]; then
  ICON=$VOLUME_100
  COLOR=$WHITE
elif [[ $VOLUME -ge 33 ]]; then
  ICON=$VOLUME_66
  COLOR=$WHITE
elif [[ $VOLUME -ge 10 ]]; then
  ICON=$VOLUME_33
  COLOR=$WHITE
elif [[ $VOLUME -gt 0 ]]; then
  ICON=$VOLUME_10
  COLOR=$WHITE
else
  ICON=$VOLUME_0
  COLOR=$RED
fi

# Update the volume item
sketchybar --set $NAME icon="$ICON" \
                 label="$VOLUME%" \
                 icon.color=$COLOR 