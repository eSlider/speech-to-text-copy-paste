#!/bin/bash

# Speech-to-Text Agent Setup Script
# This script installs all required dependencies for the speech-to-text agent

echo "🎤 Setting up Speech-to-Text Agent..."

# Update package list
echo "📦 Updating package list..."
sudo apt update

# Install system dependencies
echo "🔧 Installing system dependencies..."
sudo apt install -y \
    python3 \
    python3-pip \
    python3-gi \
    python3-gi-cairo \
    gir1.2-gtk-3.0 \
    gir1.2-keybinder-3.0 \
    xdotool \
    libasound2-dev \
    portaudio19-dev \
    python3-dev \
    build-essential

# Install Python dependencies
echo "🐍 Installing Python dependencies..."
pip3 install -r requirements.txt

# Create model directory
echo "📁 Creating model directory..."
mkdir -p ~/.local/share/vosk-model

# Download VOSK model if not exists
if [ ! -d ~/.local/share/vosk-model/model ]; then
    echo "⬇️  Downloading VOSK English model (this may take a while)..."
    cd /tmp
    wget -q https://alphacephei.com/vosk/models/vosk-model-small-en-us-0.15.zip
    unzip -q vosk-model-small-en-us-0.15.zip
    mv vosk-model-small-en-us-0.15 ~/.local/share/vosk-model/model
    rm vosk-model-small-en-us-0.15.zip
    echo "✅ VOSK model installed"
else
    echo "✅ VOSK model already exists"
fi

# Make main script executable
chmod +x main.py

# Create desktop entry
echo "🖥️  Creating desktop entry..."
cat > ~/.local/share/applications/speech-to-text-agent.desktop << EOF
[Desktop Entry]
Name=Speech-to-Text Agent
Comment=Speech-to-text agent for Ubuntu GNOME
Exec=$(pwd)/main.py
Icon=audio-input-microphone
Terminal=false
Type=Application
Categories=Utility;Audio;
EOF

echo "✅ Setup complete!"
echo ""
echo "🚀 To run the application:"
echo "   ./main.py"
echo ""
echo "📝 Or use the application menu to find 'Speech-to-Text Agent'"
echo ""
echo "⌨️  Global hotkey: Ctrl+Alt+R"
echo "🎤 Click the button or use hotkey to start recording"