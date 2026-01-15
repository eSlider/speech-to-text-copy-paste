#!/bin/bash

# Speech-to-Text Launcher Script
# This script handles starting the app with proper positioning and shortcuts

# Get the directory of this script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
APP_SCRIPT="$SCRIPT_DIR/main.py"

# Check if xdotool is installed
if ! command -v xdotool &> /dev/null; then
    echo "Installing xdotool..."
    sudo apt install -y xdotool
fi

# Kill any existing instance
pkill -f "python.*main.py" 2>/dev/null

# Set environment variables
export PYTHONPATH="$SCRIPT_DIR/venv/lib/python3.13/site-packages:$PYTHONPATH"

# Start the application in background
python3 "$APP_SCRIPT" &
APP_PID=$!

# Wait a moment for the window to appear
sleep 1.5

# Bring window to front and position it
if command -v xdotool &> /dev/null; then
    # Find our window
    WINDOW_ID=$(xdotool search --name "Speech-to-Text Agent" | head -1)
    
    if [ ! -z "$WINDOW_ID" ]; then
        # Position window at top-right corner
        SCREEN_WIDTH=$(xdotool getdisplaygeometry | awk '{print $1}')
        WINDOW_WIDTH=400
        X_POS=$((SCREEN_WIDTH - WINDOW_WIDTH - 50))
        
        xdotool windowmove "$WINDOW_ID" "$X_POS" 50
        xdotool windowactivate "$WINDOW_ID"
        
        # Keep window always on top (optional)
        xdotool windowraise "$WINDOW_ID"
    fi
fi

echo "Speech-to-Text Agent started!"
echo "Use Ctrl+Alt+R to toggle recording (if available)"
echo "Or click the button to start/stop recording"