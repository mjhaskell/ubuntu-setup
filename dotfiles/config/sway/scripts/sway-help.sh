#!/usr/bin/sh

TERMINAL=${TERMINAL:-foot}
TERMINAL_APP_ID=${TERMINAL_APP_ID:-foot}
EDITOR_CMD=${EDITOR_CMD:-nvim}
WINDOW_TITLE=${WINDOW_TITLE:-Sway Config Editor}

# Target your main config and all files in the config.d directory.
CONFIG_FILES="$HOME/.config/sway/config $HOME/.config/sway/config.d/*"

# Parse documented keybindings into tab-separated fields:
#   category<TAB>description<TAB>key<TAB>file:line
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

            # Visual replacements and prettification.
            gsub(/\+/, " + ", key_combo)

            gsub(/\$mod/, "Mod", key_combo)
            gsub(/Control/, "Ctrl", key_combo)
            gsub(/Mod1/, "Alt", key_combo)
            gsub(/\$alt/, "Alt", key_combo)

            gsub(/Return/, "⏎ ", key_combo)
            gsub(/question/, "?", key_combo)

            gsub(/button1/, "🖱️LMB", key_combo)
            gsub(/button2/, "🖱️MMC", key_combo)
            gsub(/button3/, "🖱️RMB", key_combo)
            gsub(/button4/, "Scroll▲", key_combo)
            gsub(/button5/, "Scroll▼", key_combo)

            gsub(/XF86AudioRaiseVolume/, "🔊 Vol+", key_combo)
            gsub(/XF86AudioLowerVolume/, "🔉 Vol-", key_combo)
            gsub(/XF86AudioMute/, "🔇 Mute", key_combo)
            gsub(/XF86MonBrightnessUp/, "☀️ Bright+", key_combo)
            gsub(/XF86MonBrightnessDown/, "🌙 Bright-", key_combo)

            raw_cat[count] = pending_cat
            raw_desc[count] = pending_desc
            raw_key[count] = key_combo

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
            printf "%-*s\t%-*s\t%s\t%s:%s\n", \
                max_cat, cat_str, \
                max_desc, raw_desc[i], \
                raw_key[i], \
                file_origin[i], line_origin[i]
        }
    }
' $CONFIG_FILES 2>/dev/null | sort)

[ -n "$MENU_ITEMS" ] || exit 0

# Calculate dynamic width from the same visible fields shown by fuzzel.
MAX_LENGTH=$(printf '%s\n' "$MENU_ITEMS" | awk -F '\t' '
    {
        line = $1 "  " $2 "  →  " $3
        if (length(line) > max) max = length(line)
    }
    END { print max + 0 }
')
FUZZEL_WIDTH=$((MAX_LENGTH + 4))

SELECTION=$(printf '%s\n' "$MENU_ITEMS" | fuzzel --dmenu \
    --with-nth='{1}  {2}  →  {3}' \
    --match-nth='{1} {2} {3}' \
    --accept-nth=4 \
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
