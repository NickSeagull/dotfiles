#!/bin/bash

source "$HOME/.config/sketchybar/colors.sh"
source "$HOME/.config/sketchybar/icons.sh"

# Get the window title from yabai
WINDOW_TITLE=$(yabai -m query --windows --window | jq -r '.title')

if [ -z "$WINDOW_TITLE" ] || [ "$WINDOW_TITLE" = "null" ]; then
  WINDOW_TITLE="Desktop"
fi

# Truncate title if too long
if [ ${#WINDOW_TITLE} -gt 50 ]; then
  WINDOW_TITLE="${WINDOW_TITLE:0:47}..."
fi

# Update the window title item
sketchybar --set $NAME label="$WINDOW_TITLE" 