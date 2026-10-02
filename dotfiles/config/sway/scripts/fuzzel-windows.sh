#!/usr/bin/sh

# Check the argument passed to the script (defaults to "all" if empty)
MODE="${1:-all}"

case "$MODE" in
    all)
        # 1a. Grab ALL windows across all workspaces globally
        LIST=$(swaymsg -t get_tree | jq -r '[.. | select(.pid? and .name?)] | to_entries[] | "[\(.key + 1)] \(.value.name) [id=\(.value.id)]"')
        ACTION="focus"
        FUZZEL_FLAGS="" # No automatic exit for global search
        ;;
    scratchpad)
        # 1b. Target hidden scratchpad entries exclusively
        LIST=$(swaymsg -t get_tree | jq -r '[.. | select(.scratchpad_state? and .scratchpad_state != "none")] | to_entries[] | "[\(.key + 1)] \(.value.name) [id=\(.value.id)]"')
        ACTION="scratchpad show"
        FUZZEL_FLAGS="" # No automatic exit for scratchpad picker
        ;;
    current|*)
        # 1c. Grab windows on the CURRENT workspace only
        LIST=$(swaymsg -t get_tree | jq -r '.nodes[].nodes[] | select(.focused==true or (recurse(.nodes[]) | .focused==true)) | [recurse(.nodes[]) | select(.pid? and .name?)] | to_entries[] | "[\(.key + 1)] \(.value.name) [id=\(.value.id)]"')
        ACTION="focus"
        FUZZEL_FLAGS="--auto-select" # Instant single-digit select for active workspace
        ;;
esac

# Exit early if there are no matching windows to display
if [ -z "$LIST" ]; then
    exit 0
fi

# 2. Calculate length of longest title for dynamic sizing (fallback to 30 if tiny)
CALC_W=$(echo "$LIST" | wc -L)
WIDTH=$(( CALC_W < 20 ? 30 : CALC_W + 4 )) # +4 adds a clean buffer margin so text isn't cramped

# 3. Stream to fuzzel with conditional flags, capture the selected window ID, and run the matching Sway action
echo "$LIST" | fuzzel --dmenu $FUZZEL_FLAGS -w "$WIDTH" | sed -E 's/.*\[id=([0-9]+)\]/\1/' | xargs -I{} swaymsg "[con_id={}] $ACTION"
