#!/usr/bin/sh

# Accept a 1-indexed tab number from Sway (1, 2, 3, etc.)
INPUT_INDEX=$1

# Convert 1-indexed input to 0-indexed for jq array mapping
TARGET_INDEX=$(( INPUT_INDEX - 1 ))

# Find the current focused workspace and isolate the unique window ID at that index
TARGET_ID=$(swaymsg -t get_tree | jq -r --argjson idx "$TARGET_INDEX" '
  .nodes[].nodes[] 

  | select(.focused==true or (recurse(.nodes[]) | .focused==true)) 
  | [recurse(.nodes[]) | select(.pid? and .name?)] 
  | .[$idx].id
')

# If a valid container ID was found at that index, instantly focus it
if [ "$TARGET_ID" != "null" ] && [ -n "$TARGET_ID" ]; then
    swaymsg "[con_id=$TARGET_ID] focus"
fi
