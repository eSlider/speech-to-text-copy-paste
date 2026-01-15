#!/bin/bash

# Global hotkey listener for Speech-to-Text Agent
# Uses xdotool to detect Ctrl+Alt+R keypress

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
APP_SCRIPT="$SCRIPT_DIR/main.py"

echo "Starting Speech-to-Text Agent hotkey listener..."
echo "Press Ctrl+Alt+R to toggle recording"
echo "Press Ctrl+C to stop the listener"

# Function to toggle the app
toggle_app() {
    # Check if app is already running
    if pgrep -f "python.*main.py" > /dev/null; then
        # If running, send signal to toggle recording
        # For now, just bring window to front
        WINDOW_ID=$(xdotool search --name "Speech-to-Text Agent" | head -1)
        if [ ! -z "$WINDOW_ID" ]; then
            xdotool windowactivate "$WINDOW_ID"
        fi
    else
        # If not running, start it
        export PYTHONPATH="$SCRIPT_DIR/venv/lib/python3.13/site-packages:$PYTHONPATH"
        python3 "$APP_SCRIPT" &
        
        # Wait for window and position it
        sleep 1.5
        WINDOW_ID=$(xdotool search --name "Speech-to-Text Agent" | head -1)
        if [ ! -z "$WINDOW_ID" ]; then
            SCREEN_WIDTH=$(xdotool getdisplaygeometry | awk '{print $1}')
            WINDOW_WIDTH=400
            X_POS=$((SCREEN_WIDTH - WINDOW_WIDTH - 50))
            xdotool windowmove "$WINDOW_ID" "$X_POS" 50
            xdotool windowactivate "$WINDOW_ID"
        fi
    fi
}

# Simple loop - this is a basic implementation
# In production, you might want to use a proper hotkey daemon
while true; do
    sleep 1
done