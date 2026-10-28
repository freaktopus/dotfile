#!/bin/bash
# flameshot-file-copy.sh - Saves file AND copies file reference for file manager paste

SCREENSHOT_DIR="$HOME/Pictures"
mkdir -p "$SCREENSHOT_DIR"

# Take screenshot with Flameshot (will open GUI for editing)
# -c = copy image to clipboard (for apps like Discord/GIMP)
# -p = save to directory
flameshot gui -c -p "$SCREENSHOT_DIR"

# Find the most recently created screenshot in the directory
LATEST_FILE=$(ls -t "$SCREENSHOT_DIR"/*.png 2>/dev/null | head -1)

if [[ -n "$LATEST_FILE" ]]; then
    # Copy the FILE REFERENCE (not image data) for file managers
    if [[ "$XDG_SESSION_TYPE" == "wayland" ]]; then
        echo -n "file://${LATEST_FILE}" | wl-copy --type text/uri-list
    else
        echo -n "file://${LATEST_FILE}" | xclip -selection clipboard -t text/uri-list
    fi
    echo "✅ Screenshot saved: $LATEST_FILE"
    echo "📋 Image copied to clipboard (for apps)"
    echo "📁 File reference copied - you can now Ctrl+V in file managers!"
else
    echo "❌ Screenshot cancelled or no file created"
fi
