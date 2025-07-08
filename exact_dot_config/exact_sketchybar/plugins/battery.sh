#!/bin/bash

source "$HOME/.config/sketchybar/colors.sh"
source "$HOME/.config/sketchybar/icons.sh"

# Get battery info
BATTERY_INFO=$(pmset -g batt)
PERCENTAGE=$(echo "$BATTERY_INFO" | grep -Eo "\d+%" | cut -d% -f1)
CHARGING=$(echo "$BATTERY_INFO" | grep 'AC Power')

# Set battery icon based on percentage and charging status
if [[ $CHARGING != "" ]]; then
  ICON=$BATTERY_CHARGING
  COLOR=$GREEN
elif [[ $PERCENTAGE -ge 75 ]]; then
  ICON=$BATTERY_100
  COLOR=$GREEN
elif [[ $PERCENTAGE -ge 50 ]]; then
  ICON=$BATTERY_75
  COLOR=$YELLOW
elif [[ $PERCENTAGE -ge 25 ]]; then
  ICON=$BATTERY_50
  COLOR=$ORANGE
else
  ICON=$BATTERY_25
  COLOR=$RED
fi

# Update the battery item
sketchybar --set $NAME icon="$ICON" \
                 label="$PERCENTAGE%" \
                 icon.color=$COLOR 