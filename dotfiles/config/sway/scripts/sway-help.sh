#!/usr/bin/sh

TERMINAL=${TERMINAL:-foot}
TERMINAL_APP_ID=${TERMINAL_APP_ID:-foot}
EDITOR_CMD=${EDITOR_CMD:-nvim}
WINDOW_TITLE=${WINDOW_TITLE:-Sway Config Editor}

# Target your main config and all files in the config.d directory.
CONFIG_FILES="$HOME/.config/sway/config $HOME/.config/sway/config.d/*"

# Parse documented keybindings into tab-separated fields:
#   category<TAB>description<TAB>display_key<TAB>search_key<TAB>file:line
MENU_ITEMS=$(awk '
    function trim(s) {
        sub(/^[ \t]+/, "", s)
        sub(/[ \t]+$/, "", s)
        return s
    }

    BEGIN { count = 0 }

    /^[ \t]*# DOC:/ {
        doc = $0
        sub(/^[ \t]*# DOC:[ \t]*/, "", doc)

        if (match(doc, /[ \t]*:[ \t]*/)) {
            pending_cat = trim(substr(doc, 1, RSTART - 1))
            pending_desc = trim(substr(doc, RSTART + RLENGTH))
        } else {
            pending_cat = "General"
            pending_desc = trim(doc)
        }

        next
    }

    /^[ \t]*(bindsym|bindcode)([ \t]|$)/ {
        if (pending_desc != "") {
            file_origin[count] = FILENAME
            line_origin[count] = FNR

            binding = $0
            sub(/^[ \t]*(bindsym|bindcode)[ \t]*/, "", binding)
            n = split(binding, key_parts, /[ \t]+/)

            key_combo = ""
            for (j = 1; j <= n; j++) {
                if (key_parts[j] !~ /^-/) {
                    key_combo = key_parts[j]
                    break
                }
            }
            if (key_combo == "") key_combo = key_parts[1]

            # Keep a word-based key field for searching, and a compact symbolic
            # key field for display.
            search_key = key_combo
            gsub(/\+/, " ", search_key)

            gsub(/\$mod/, "Mod", search_key)
            gsub(/[cC]ontrol/, "Control", search_key)
            gsub(/Mod1/, "Alt", search_key)
            gsub(/\$alt/, "Alt", search_key)

            gsub(/[rR]eturn/, "Enter", search_key)
            gsub(/[qQ]uestion/, "Question", search_key)

            gsub(/button1/, "Mouse Left Click LMB", search_key)
            gsub(/button2/, "Mouse Middle Click MMB", search_key)
            gsub(/button3/, "Mouse Right Click RMB", search_key)
            gsub(/button4/, "Mouse Scroll Up", search_key)
            gsub(/button5/, "Mouse Scroll Down", search_key)

            gsub(/XF86AudioRaiseVolume/, "Audio Volume Up", search_key)
            gsub(/XF86AudioLowerVolume/, "Audio Volume Down", search_key)
            gsub(/XF86AudioMute/, "Audio Mute", search_key)
            gsub(/XF86AudioMicMute/, "Microphone Mute", search_key)
            gsub(/XF86MonBrightnessUp/, "Brightness Up", search_key)
            gsub(/XF86MonBrightnessDown/, "Brightness Down", search_key)

            display_key = search_key
            gsub(/[mM]od/, "❖", display_key)
            gsub(/[sS]hift/, "⇧", display_key)
            gsub(/[cC]ontrol/, "⌃", display_key)
            gsub(/[cC]trl/, "⌃", display_key)
            gsub(/[aA]lt/, "⌥", display_key)
            gsub(/[eE]nter/, "↵", display_key)
            gsub(/[qQ]uestion/, "?", display_key)
            # gsub(/[dD]elete/, "Del", display_key)
            gsub(/[dD]elete/, "", display_key)
            gsub(/[sS]pace/, "␣", display_key)
            gsub(/[mM]inus/, "-", display_key)
            gsub(/[pP]lus/, "+", display_key)
            gsub(/[eE]qual/, "=", display_key)
            gsub(/[sS]emicolon/, ";", display_key)
            gsub(/[tT]ab/, "⇥", display_key)

            # gsub(/Mouse Left Click LMB/, "LMB", display_key)
            # gsub(/Mouse Middle Click MMB/, "MMB", display_key)
            # gsub(/Mouse Right Click RMB/, "RMB", display_key)
            gsub(/Mouse Left Click LMB/, "󰍽L", display_key)
            gsub(/Mouse Middle Click MMB/, "󰍽M", display_key)
            gsub(/Mouse Right Click RMB/, "󰍽R", display_key)
            gsub(/Mouse Scroll Up/, "Wheel↑", display_key)
            gsub(/Mouse Scroll Down/, "Wheel↓", display_key)

            # gsub(/Audio Volume Up/, "🔊", display_key)
            # gsub(/Audio Volume Down/, "🔉", display_key)
            # gsub(/Audio Mute/, "🔇", display_key)
            # gsub(/Microphone Mute/, "󰍭", display_key)
            # gsub(/Brightness Up/, "☀️", display_key)
            # gsub(/Brightness Down/, "🌙", display_key)
            gsub(/Audio Volume Up/, "󰕾", display_key)
            gsub(/Audio Volume Down/, "󰖀", display_key)
            gsub(/Audio Mute/, "󰖁", display_key)
            # gsub(/Audio Volume Up/, "", display_key)
            # gsub(/Audio Volume Down/, "", display_key)
            # gsub(/Audio Mute/, "", display_key)
            gsub(/Microphone Mute/, "󰍭", display_key)
            gsub(/Brightness Up/, "󰃠", display_key)
            gsub(/Brightness Down/, "󰃞", display_key)

            gsub(/Down/, "↓", display_key)
            gsub(/Up/, "↑", display_key)
            gsub(/Left/, "←", display_key)
            gsub(/Right/, "→", display_key)

            raw_cat[count] = pending_cat
            raw_desc[count] = pending_desc
            raw_key[count] = display_key
            raw_search_key[count] = search_key

            cat_len = length("[" pending_cat "]")
            if (cat_len > max_cat) max_cat = cat_len

            desc_len = length(pending_desc)
            if (desc_len > max_desc) max_desc = desc_len

            pending_cat = ""
            pending_desc = ""
            count++
        }
    }

    END {
        for (i = 0; i < count; i++) {
            cat_str = "[" raw_cat[i] "]"
            printf "%-*s\t%-*s\t%s\t%s\t%s:%s\n", \
                max_cat, cat_str, \
                max_desc, raw_desc[i], \
                raw_key[i], \
                raw_search_key[i], \
                file_origin[i], line_origin[i]
        }
    }
' $CONFIG_FILES 2>/dev/null | sort)

[ -n "$MENU_ITEMS" ] || exit 0

# Calculate dynamic width from the same visible fields shown by fuzzel.
MAX_LENGTH=$(printf '%s\n' "$MENU_ITEMS" | awk -F '\t' '
    {
        line = $1 "  " $2 "  →    " $3
        if (length(line) > max) max = length(line)
    }
    END { print max + 0 }
')
FUZZEL_WIDTH=$((MAX_LENGTH + 4))

SELECTION=$(printf '%s\n' "$MENU_ITEMS" | fuzzel --dmenu \
    --with-nth='{1}  {2}  →    {3}' \
    --match-nth='{1} {2} {3} {4}' \
    --accept-nth=5 \
    --no-run-if-empty \
    -p "Filter Shortcuts (Enter to Edit): " \
    --width "$FUZZEL_WIDTH" \
    --lines 15)

if [ -n "$SELECTION" ]; then
    FILE=${SELECTION%:*}
    LINE=${SELECTION##*:}

    case $LINE in
        ''|*[!0-9]*) exit 0 ;;
    esac
    [ -f "$FILE" ] || exit 0

    swaymsg "for_window [app_id=\"$TERMINAL_APP_ID\" title=\"$WINDOW_TITLE\"] floating enable; exec $TERMINAL --title='$WINDOW_TITLE' -e $EDITOR_CMD +$LINE '$FILE'"
fi
