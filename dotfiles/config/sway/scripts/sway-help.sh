#!/usr/bin/sh

# # Define your preferred terminal editor command
# # Examples: "foot -e nvim", "foot -e nano", "foot -e helix"
# EDITOR_CMD="foot -e nvim"
#
# # Target your main config and all files in the config.d directory
# CONFIG_FILES="$HOME/.config/sway/config $HOME/.config/sway/config.d/*"
#
# # Parse all detected config files dynamically
# MENU_ITEMS=$(awk '
#     BEGIN { count = 0 }
#
#     # ----------------------------------------------------
#     # PASS 1: Read files and track max column widths
#     # ----------------------------------------------------
#     /^# DOC:/ {
#         sub(/^# DOC:[ \t]*/, "");
#         split($0, parts, /[ \t]*:[ \t]*/);
#
#         raw_cat[count] = parts[1];
#         raw_desc[count] = parts[2];
#
#         cat_len = length(parts[1]) + 2;
#         if (cat_len > max_cat) max_cat = cat_len;
#
#         desc_len = length(parts[2]);
#         if (desc_len > max_desc) max_desc = desc_len;
#
#         next
#     }
#     /^bindsym/ {
#         if (raw_desc[count] != "") {
#             # Save the file name and exact line number of the bindsym instruction
#             file_origin[count] = FILENAME;
#             line_origin[count] = FNR;
#
#             sub(/^bindsym[ \t]*/, "");
#             split($0, key_parts, /[ \t]+/);
#
#             key_combo = ""
#             for (j = 1; j <= length(key_parts); j++) {
#                 if (key_parts[j] !~ /^-/) {
#                     key_combo = key_parts[j];
#                     break;
#                 }
#             }
#             if (key_combo == "") key_combo = key_parts[1];
#
#             # ----------------------------------------------------
#             # VISUAL REPLACEMENTS & PRETTIFICATION
#             # ----------------------------------------------------
#
#             # 1. Add a space before and after any remaining key binding + signs
#             gsub(/\+/, " + ", key_combo);
#
#             # 2. Standardize modifiers to visual symbols
#             # gsub(/\$mod/, "❖", key_combo);
#             # gsub(/Shift/, "⇧", key_combo);
#             # gsub(/Control/, "⎈ Ctrl", key_combo);
#             # gsub(/Mod1/, "⌥ ", key_combo);
#             # gsub(/\$alt/, "⌥ ", key_combo);
#             gsub(/\$mod/, "Mod", key_combo);
#             gsub(/Control/, "Ctrl", key_combo);
#             gsub(/Mod1/, "Alt", key_combo);
#             gsub(/\$alt/, "Alt", key_combo);
#
#             gsub(/Return/, "⏎ ", key_combo);
#             gsub(/question/, "?", key_combo);
#
#             # 3. Translate mouse buttons to human readable descriptors
#             gsub(/button1/, "Left Click🖱️", key_combo);
#             gsub(/button2/, "Middle Click🖱️", key_combo);
#             gsub(/button3/, "Right Click🖱️", key_combo);
#             gsub(/button4/, "Scroll Up▲", key_combo);
#             gsub(/button5/, "Scroll Down▼", key_combo);
#
#             # 4. Translate media controls
#             gsub(/XF86AudioRaiseVolume/, "🔊 Vol+", key_combo);
#             gsub(/XF86AudioLowerVolume/, "🔉 Vol-", key_combo);
#             gsub(/XF86AudioMute/, "🔇 Mute", key_combo);
#             gsub(/XF86MonBrightnessUp/, "☀️ Brightness+", key_combo);
#             gsub(/XF86MonBrightnessDown/, "🌙 Brightness-", key_combo);
#
#             raw_key[count] = key_combo;
#             count++;
#         }
#     }
#
#     # ----------------------------------------------------
#     # PASS 2: Print using the dynamic max widths
#     # ----------------------------------------------------
#     END {
#         for (i = 0; i < count; i++) {
#             cat_str = "[" raw_cat[i] "]";
#             format_str = "%-" max_cat "s  %-" max_desc "s  ➔   %s\n";
#             # format_str = "%-" max_cat "s  %-" max_desc "s  ➔  « %s »\n";
#
#             # printf format_str, cat_str, raw_desc[i], raw_key[i];
#
#             # Hide the file path and line number at the very end of the line using a delimiter (||)
#             # printf format_str " || %s:%s\n", cat_str, raw_desc[i], raw_key[i], file_origin[i], line_origin[i];
#
#             # Hide the file path and line number using a semicolon delimiter
#             # printf format_str ";%s:%s\n", cat_str, raw_desc[i], raw_key[i], file_origin[i], line_origin[i];
#
#             # Put the semicolon immediately after the visible brackets with no space
#             printf format_str ";%s:%s\n", cat_str, raw_desc[i], raw_key[i], file_origin[i], line_origin[i];
#         }
#     }
# ' $CONFIG_FILES 2>/dev/null | sort)
#
# # Calculate dynamic width
# MAX_LENGTH=$(echo "$MENU_ITEMS" | wc -L)
# FUZZEL_WIDTH=$((MAX_LENGTH + 4))
#
# # Pipe the list into fuzzel
# SELECTION=$(echo "$MENU_ITEMS" | fuzzel --dmenu \
#     -p "Filter Shortcuts (Enter to Edit): " \
#     --width "$FUZZEL_WIDTH" \
#     --lines 15)
#
# # If a selection was made, extract the file and line number and open the editor
# if [ -n "$SELECTION" ]; then
#     # # Extract the metadata hidden after "|| "
#     # META=$(echo "$SELECTION" | awk -F ' \|\| ' '{print $2}')
#     # FILE=$(echo "$META" | cut -d':' -f1)
#     # LINE=$(echo "$META" | cut -d':' -f2)
#
#     # # Extract the metadata hidden after the semicolon
#     # META=$(echo "$SELECTION" | cut -d';' -f2)
#     # FILE=$(echo "$META" | cut -d':' -f1)
#     # LINE=$(echo "$META" | cut -d':' -f2)
#     #
#
#     # 1. Isolate everything after the semicolon
#     # META="${SELECTION##*;}"
#     META=$(echo "$SELECTION" | sed -n 's/.*\[EDIT_METADATA->\(.*\)\]/\1/p')
#
#     # 2. Extract the file and line cleanly without whitespace pollution
#     FILE=$(echo "$META" | cut -d':' -f1)
#     LINE=$(echo "$META" | cut -d':' -f2)
#
#     # 3. Explicitly spawn foot running EDITOR targeting the line number (works natively for nvim, nano, and helix)
#     # swaymsg exec "$EDITOR_CMD +$LINE" "$FILE"
#     swaymsg "for_window [app_id=\"foot\" title=\"Sway Config Editor\"] floating enable; exec foot --title='Sway Config Editor' -e nvim +$LINE $FILE"
# fi




# Target your main config and all files in the config.d directory
CONFIG_FILES="$HOME/.config/sway/config $HOME/.config/sway/config.d/*"

# Parse all detected config files dynamically
MENU_ITEMS=$(awk '
    BEGIN { count = 0 }

    /^# DOC:/ { 
        sub(/^# DOC:[ \t]*/, ""); 
        split($0, parts, /[ \t]*:[ \t]*/);

        raw_cat[count] = parts[1];
        raw_desc[count] = parts[2];

        cat_len = length(parts[1]) + 2;
        if (cat_len > max_cat) max_cat = cat_len;

        desc_len = length(parts[2]);
        if (desc_len > max_desc) max_desc = desc_len;

        next 
    }
    /^bindsym/ { 
        if (raw_desc[count] != "") {
            file_origin[count] = FILENAME;
            line_origin[count] = FNR;

            sub(/^bindsym[ \t]*/, ""); 
            split($0, key_parts, /[ \t]+/);

            key_combo = ""
            for (j = 1; j <= length(key_parts); j++) {
                if (key_parts[j] !~ /^-/) {
                    key_combo = key_parts[j];
                    break;
                }
            }
            if (key_combo == "") key_combo = key_parts[1];


            # ----------------------------------------------------
            # VISUAL REPLACEMENTS & PRETTIFICATION
            # ----------------------------------------------------

            # 1. Add a space before and after any remaining key binding + signs
            gsub(/\+/, " + ", key_combo);

            # 2. Standardize modifiers to visual symbols
            # gsub(/\$mod/, "❖", key_combo);
            # gsub(/Shift/, "⇧", key_combo);
            # gsub(/Control/, "⎈ Ctrl", key_combo);
            # gsub(/Mod1/, "⌥ ", key_combo);
            # gsub(/\$alt/, "⌥ ", key_combo);
            gsub(/\$mod/, "Mod", key_combo);
            gsub(/Control/, "Ctrl", key_combo);
            gsub(/Mod1/, "Alt", key_combo);
            gsub(/\$alt/, "Alt", key_combo);

            gsub(/Return/, "⏎ ", key_combo);
            gsub(/question/, "?", key_combo);

            # 3. Translate mouse buttons to human readable descriptors
            gsub(/button1/, "Left Click🖱️", key_combo);
            gsub(/button2/, "Middle Click🖱️", key_combo);
            gsub(/button3/, "Right Click🖱️", key_combo);
            gsub(/button4/, "Scroll Up▲", key_combo);
            gsub(/button5/, "Scroll Down▼", key_combo);

            # 4. Translate media controls
            gsub(/XF86AudioRaiseVolume/, "🔊 Vol+", key_combo);
            gsub(/XF86AudioLowerVolume/, "🔉 Vol-", key_combo);
            gsub(/XF86AudioMute/, "🔇 Mute", key_combo);
            gsub(/XF86MonBrightnessUp/, "☀️ Brightness+", key_combo);
            gsub(/XF86MonBrightnessDown/, "🌙 Brightness-", key_combo);

            raw_key[count] = key_combo;
            count++;
        }
    }

    END {
        for (i = 0; i < count; i++) {
            cat_str = "[" raw_cat[i] "]";
            format_str = "%%-%ds  %%-%ds  ➔    %%s"
            final_fmt = sprintf(format_str, max_cat, max_desc)

            # Print visible text first, then hidden metadata as a second tab-separated field.
            # Fuzzel displays only field 1 and returns only field 2 via --with-nth/--accept-nth.
            printf final_fmt, cat_str, raw_desc[i], raw_key[i]
            printf "\t%s:%s\n", file_origin[i], line_origin[i]
        }
    }
' $CONFIG_FILES 2>/dev/null | sort)

# Calculate dynamic width from the visible field only
MAX_LENGTH=$(printf '%s\n' "$MENU_ITEMS" | cut -f1 | wc -L)
FUZZEL_WIDTH=$((MAX_LENGTH + 4))

# # Pipe the list into fuzzel
SELECTION=$(printf '%s\n' "$MENU_ITEMS" | fuzzel --dmenu \
    --with-nth=1 \
    --accept-nth=2 \
    -p "Filter Shortcuts (Enter to Edit): " \
    --width "$FUZZEL_WIDTH" \
    --lines 15)

# If a selection was made, extract coordinates cleanly
if [ -n "$SELECTION" ]; then
    FILE=${SELECTION%:*}
    LINE=${SELECTION##*:}

    # Spawn terminal into floating mode focusing precisely on the file and line
    swaymsg "for_window [app_id=\"foot\" title=\"Sway Config Editor\"] floating enable; exec foot --title='Sway Config Editor' -e nvim +$LINE $FILE"
fi
