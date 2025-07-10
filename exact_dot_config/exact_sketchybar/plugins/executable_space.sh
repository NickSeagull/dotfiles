#!/bin/bash

source "$HOME/.config/sketchybar/colors.sh"
source "$HOME/.config/sketchybar/icons.sh"

SPACE_SIDS=(1 2 3 4 5 6 7 8 9 10)

if [ "$SENDER" = "space_change" ]; then
  # Get the current focused space from yabai
  FOCUSED_WORKSPACE=$(yabai -m query --spaces --space | jq -r '.index')
  
  # Update all spaces
  for sid in "${SPACE_SIDS[@]}"
  do
    if [ "$sid" = "$FOCUSED_WORKSPACE" ]; then
      sketchybar --set space.$sid background.drawing=on \
                              background.color=$ACCENT_COLOR \
                              label.color=$BLACK \
                              icon.color=$BLACK
    else
      sketchybar --set space.$sid background.drawing=off \
                              label.color=$WHITE \
                              icon.color=$WHITE
    fi
  done
else
  # Initial setup or regular update
  if [ "$SELECTED" = "true" ]; then
    sketchybar --set $NAME background.drawing=on \
                     background.color=$ACCENT_COLOR \
                     label.color=$BLACK \
                     icon.color=$BLACK
  else
    sketchybar --set $NAME background.drawing=off \
                     label.color=$WHITE \
                     icon.color=$WHITE
  fi
fi 