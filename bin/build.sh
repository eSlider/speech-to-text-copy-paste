#!/bin/bash

# Speech-to-Text Agent AppImage Builder
# This script creates an AppImage package for easy distribution

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration
APP_NAME="Speech-to-Text-Agent"
APP_VERSION="0.1.0"
APP_DIR="Speech-to-Text-Agent.AppDir"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

echo -e "${GREEN}Building Speech-to-Text Agent AppImage${NC}"
echo "Version: $APP_VERSION"
echo "Project Root: $PROJECT_ROOT"
echo

# Create build directory
BUILD_DIR="$PROJECT_ROOT/build"
rm -rf "$BUILD_DIR"
mkdir -p "$BUILD_DIR"

# Create AppDir structure
APPDIR_PATH="$BUILD_DIR/$APP_DIR"
mkdir -p "$APPDIR_PATH"{usr/bin,usr/share/applications,usr/share/icons/hicolor/256x256/apps,usr/lib}

echo -e "${GREEN}[1/6] Copying application files...${NC}"

# Copy main application files
cp "$PROJECT_ROOT/main.py" "$APPDIR_PATH/usr/bin/"
cp "$PROJECT_ROOT/launch.sh" "$APPDIR_PATH/usr/bin/"
cp "$PROJECT_ROOT/hotkey-listener.sh" "$APPDIR_PATH/usr/bin/"
cp "$PROJECT_ROOT/test-xdotool.sh" "$APPDIR_PATH/usr/bin/"

# Copy desktop file
cp "$PROJECT_ROOT/speech-to-text-agent.desktop" "$APPDIR_PATH/usr/share/applications/"

# Copy requirements and setup scripts
cp "$PROJECT_ROOT/requirements.txt" "$APPDIR_PATH/usr/bin/"
cp "$PROJECT_ROOT/setup.sh" "$APPDIR_PATH/usr/bin/"

# Make scripts executable
chmod +x "$APPDIR_PATH/usr/bin/"*.sh

echo -e "${GREEN}[2/6] Creating AppRun script...${NC}"

# Create AppRun script
cat > "$APPDIR_PATH/AppRun" << 'EOF'
#!/bin/bash
# AppRun script for Speech-to-Text Agent

HERE="$(dirname "$(readlink -f "${0}")")"
export PATH="${HERE}/usr/bin:${PATH}"
export PYTHONPATH="${HERE}/usr/lib/python3/site-packages:${PYTHONPATH}"

# Check if virtual environment exists, if not create it
if [ ! -d "$HOME/.local/share/speech-to-text-agent/venv" ]; then
    echo "Setting up virtual environment..."
    mkdir -p "$HOME/.local/share/speech-to-text-agent"
    python3 -m venv "$HOME/.local/share/speech-to-text-agent/venv"
    
    # Activate and install dependencies
    source "$HOME/.local/share/speech-to-text-agent/venv/bin/activate"
    pip install --upgrade pip
    pip install -r "${HERE}/usr/bin/requirements.txt"
fi

# Activate virtual environment
source "$HOME/.local/share/speech-to-text-agent/venv/bin/activate"

# Check if VOSK model exists, if not download it
MODEL_DIR="$HOME/.local/share/vosk-model/model"
if [ ! -d "$MODEL_DIR" ]; then
    echo "Downloading VOSK model (this may take a while)..."
    mkdir -p "$HOME/.local/share/vosk-model"
    cd "$HOME/.local/share/vosk-model"
    wget -q --show-progress https://alphacephei.com/vosk/models/vosk-model-small-en-us-0.15.zip
    unzip -q vosk-model-small-en-us-0.15.zip
    mv vosk-model-small-en-us-0.15 model
    rm vosk-model-small-en-us-0.15.zip
fi

# Set VOSK model path
export VOSK_MODEL_PATH="$MODEL_DIR"

# Check if xdotool is available
if ! command -v xdotool &> /dev/null; then
    echo "Warning: xdotool not found. Text input may not work properly."
    echo "Install with: sudo apt install xdotool"
fi

# Run the application
cd "${HERE}/usr/bin"
exec python3 main.py "$@"
EOF

chmod +x "$APPDIR_PATH/AppRun"

echo -e "${GREEN}[3/6] Creating desktop integration...${NC}"

# Create desktop file for AppImage
cat > "$APPDIR_PATH/speech-to-text-agent.desktop" << EOF
[Desktop Entry]
Type=Application
Name=Speech-to-Text Agent
Comment=Convert speech to text and input into applications
Exec=AppRun
Icon=speech-to-text-agent
Categories=Utility;Accessibility;
Terminal=false
StartupNotify=true
EOF

# Copy desktop file to proper location
cp "$APPDIR_PATH/speech-to-text-agent.desktop" "$APPDIR_PATH/usr/share/applications/"

echo -e "${GREEN}[4/6] Creating application icon...${NC}"

# Create a simple icon (you can replace this with your actual icon)
cat > "$APPDIR_PATH/usr/share/icons/hicolor/256x256/apps/speech-to-text-agent.svg" << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<svg width="256" height="256" viewBox="0 0 256 256" xmlns="http://www.w3.org/2000/svg">
  <rect width="256" height="256" fill="#2E3440" rx="32"/>
  <circle cx="128" cy="90" r="24" fill="#88C0D0"/>
  <rect x="116" y="110" width="24" height="60" fill="#88C0D0"/>
  <rect x="104" y="170" width="48" height="8" rx="4" fill="#88C0D0"/>
  <rect x="80" y="190" width="96" height="12" rx="6" fill="#5E81AC"/>
  <text x="128" y="230" text-anchor="middle" fill="#ECEFF4" font-family="sans-serif" font-size="14" font-weight="bold">STT</text>
</svg>
EOF

echo -e "${GREEN}[5/6] Downloading AppImageTool...${NC}"

# Download appimagetool if not exists
APPIMAGETOOL="$BUILD_DIR/appimagetool-x86_64.AppImage"
if [ ! -f "$APPIMAGETOOL" ]; then
    wget -O "$APPIMAGETOOL" \
        "https://github.com/AppImage/AppImageKit/releases/download/continuous/appimagetool-x86_64.AppImage"
    chmod +x "$APPIMAGETOOL"
fi

echo -e "${GREEN}[6/6] Creating AppImage...${NC}"

# Create the AppImage
cd "$BUILD_DIR"
APPIMAGE="$PROJECT_ROOT/Speech-to-Text-Agent-${APP_VERSION}-x86_64.AppImage"

"$APPIMAGETOOL" --appimage-extract-and-run "$APP_DIR" "$APPIMAGE"

echo
echo -e "${GREEN}✅ AppImage created successfully!${NC}"
echo -e "Location: ${YELLOW}$APPIMAGE${NC}"
echo
echo -e "${GREEN}To run the application:${NC}"
echo "  $APPIMAGE"
echo
echo -e "${GREEN}To install system-wide:${NC}"
echo "  sudo cp '$APPIMAGE' /usr/local/bin/"
echo

# Clean up build directory
rm -rf "$BUILD_DIR"

echo -e "${GREEN}Build completed!${NC}"