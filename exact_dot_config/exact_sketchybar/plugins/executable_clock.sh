#!/bin/bash

source "$HOME/.config/sketchybar/colors.sh"
source "$HOME/.config/sketchybar/icons.sh"

# Format the date and time
DATE=$(date '+%a %d %b')
TIME=$(date '+%H:%M')

# Update the clock item
sketchybar --set $NAME icon="$CLOCK" \
                 label="$DATE $TIME" 