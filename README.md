# Speech-to-Text Agent

A GNOME-compatible Ubuntu application that converts speech to text and inputs it into the current application as if typed on a keyboard.

## Current Status ✅

**Version 0.1.0 - Alpha Release** - Fully functional speech-to-text application with GTK interface, real-time recognition, and smart text input.

## Features

- 🎤 **Real-time speech recognition** using VOSK (offline, privacy-focused)
- 🖱️ **GTK interface** with recording status button (green/red with animations)
- 📝 **Smart text input** - Queues speech during recording, types all at once when stopped
- 🔄 **Focus management** - Automatically returns focus to previous application
- 🖼️ **Window positioning** - Stays on top, positioned at top-right corner
- 🎨 **Visual feedback** - Color-coded status and real-time transcription display
- ⚡ **Easy launch** - Desktop integration and smart launcher script

## Quick Start

### Installation

1. Clone or download this repository
2. Run the automated setup script:
   ```bash
   ./setup.sh
   ```

### Running the Application

**Recommended** - Use the smart launcher for optimal positioning:
```bash
./launch.sh
```

Or run directly:
```bash
./main.py
```

Or find "Speech-to-Text Agent" in your application menu.

### Usage

1. **Launch the app** - It appears at top-right corner, stays on top
2. **Click "Start Recording"** (🎤 button turns red)
3. **Speak into your microphone** - Real-time transcription shown in status
4. **Click "Stop Recording"** (⏹️ button) 
5. **Text automatically types** into your previous application
6. **Focus returns** to your work application

## What's New 🚀

See the [**CHANGELOG.md**](CHANGELOG.md) for detailed version history and recent improvements.

### Latest Features (v0.1.0)
- ✅ Working VOSK speech recognition
- ✅ GTK interface with animated status button
- ✅ Smart text queuing and batch typing
- ✅ Window positioning and stay-on-top
- ✅ Desktop integration
- ✅ Automated setup script
- ✅ Focus management between applications

## Requirements

### System Requirements
- **Ubuntu 18.04+** with GNOME desktop
- **Python 3.6+** 
- **Microphone** for audio input
- **GTK 3.0+** (pre-installed on Ubuntu)

### Dependencies Included
The `setup.sh` script automatically installs:
- **vosk** - Offline speech recognition engine
- **sounddevice** - Audio capture library  
- **PyGObject** - GTK Python bindings
- **xdotool** - Text input simulation
- **VOSK Model** - English speech recognition model (40MB)

### Manual Dependencies
If setup fails, install manually:

```bash
# System packages
sudo apt install python3-gi python3-gi-cairo gir1.2-gtk-3.0 xdotool

# Python packages
pip3 install vosk sounddevice numpy PyGObject

# VOSK model
mkdir -p models && cd models
wget https://alphacephei.com/vosk/models/vosk-model-small-en-us-0.15.zip
unzip vosk-model-small-en-us-0.15.zip
```

## Installation Details

The setup script automatically:
- Installs all system dependencies via apt
- Installs Python packages via pip
- Downloads the VOSK English model (~40MB)
- Creates a desktop entry for easy access

## Manual Installation

If the setup script fails, you can install manually:

```bash
# System packages
sudo apt install python3-gi python3-gi-cairo gir1.2-gtk-3.0 \
    gir1.2-keybinder-3.0 xdotool libasound2-dev portaudio19-dev

# Python packages
pip3 install vosk sounddevice numpy PyGObject

# VOSK model
mkdir -p ~/.local/share/vosk-model
cd /tmp
wget https://alphacephei.com/vosk/models/vosk-model-small-en-us-0.15.zip
unzip vosk-model-small-en-us-0.15.zip
mv vosk-model-small-en-us-0.15 ~/.local/share/vosk-model/model
```

## Troubleshooting

### "Model not found" error
- Ensure the VOSK model was downloaded correctly
- Check that ~/.local/share/vosk-model/model exists

### "xdotool not found" error
- Install with: `sudo apt install xdotool`

### Audio recording issues
- Check microphone permissions in system settings
- Ensure audio device is working with other applications

### Global hotkey not working
- May require additional permissions on some systems
- Try restarting the application or logging out/in

## How It Works

1. **Audio Capture**: Uses sounddevice to capture microphone audio in real-time
2. **Speech Recognition**: VOSK processes audio chunks and transcribes speech
3. **Text Input**: xdotool simulates keyboard typing into the active window
4. **Global Hotkey**: Keybinder captures system-wide keypresses

## Development

### Project Structure
```
speech-to-text-agent/
├── main.py                      # Main GTK application
├── launch.sh                    # Smart launcher with positioning
├── setup.sh                     # Automated dependency installer
├── requirements.txt              # Python dependencies
├── README.md                    # This documentation
├── CHANGELOG.md                 # 📋 Version history and changes
├── TODO.md                     # Development roadmap
├── speech-to-text-agent.desktop  # Desktop entry
├── test-xdotool.sh             # xdotool functionality test
├── hotkey-listener.sh           # Alternative hotkey handling
├── venv/                       # Python virtual environment
└── models/                     # VOSK model files
    └── vosk-model-small-en-us-0.15/
```

### Running from Source
```bash
# With proper environment
./launch.sh

# Or directly
PYTHONPATH=./venv/lib/python3.13/site-packages python3 main.py
```

## Documentation

- **[📋 CHANGELOG.md](CHANGELOG.md)** - Version history, new features, and bug fixes
- **[📝 TODO.md](TODO.md)** - Development roadmap and planned features
- **[🔧 setup.sh](setup.sh)** - Automated installation script
- **[🚀 launch.sh](launch.sh)** - Smart application launcher

## Version History

See the **[CHANGELOG.md](CHANGELOG.md)** for detailed release notes, including:
- ✅ New features and improvements
- 🐛 Bug fixes and patches  
- 🔧 Technical changes and dependencies
- ⚠️ Known issues and limitations

## License

This project is open source. See LICENSE file for details.

## Contributing

Contributions welcome! Please see [TODO.md](TODO.md) for planned features and improvements.

---

## 🎉 Quick Summary

**Speech-to-Text Agent v0.1.0** is now fully functional:
- ✅ Working speech recognition with VOSK
- ✅ Beautiful GTK interface with status feedback  
- ✅ Smart text input with focus management
- ✅ Desktop integration and easy setup
- ✅ Comprehensive documentation

**Try it now:** `./setup.sh && ./launch.sh`