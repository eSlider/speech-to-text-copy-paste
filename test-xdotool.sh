#!/bin/bash

# Test xdotool installation and functionality
echo "Testing xdotool..."

if ! command -v xdotool &> /dev/null; then
    echo "xdotool not found. Installing..."
    sudo apt update && sudo apt install -y xdotool
fi

if command -v xdotool &> /dev/null; then
    echo "✅ xdotool is installed"
    
    # Test typing
    echo "Testing xdotool typing (will type 'Hello World' in 3 seconds)..."
    sleep 3
    xdotool type "Hello World"
    echo "✅ xdotool typing test completed"
else
    echo "❌ xdotool installation failed"
fi