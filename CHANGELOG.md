# Changelog

All notable changes to the Speech-to-Text Agent project will be documented in this file.

## [0.1.0] - 2025-01-15 - Initial Release

### Major Features Added

#### **Core Speech-to-Text Functionality**
- **Real-time speech recognition** using VOSK engine (offline, privacy-focused)
- **GTK3 desktop application** with native Ubuntu GNOME integration
- **Audio processing** with 16kHz mono recording and real-time transcription
- **VOSK English model** integration (small model, 40MB) for high accuracy

#### **User Interface & Experience**
- **Recording status button** with dynamic visual feedback:
  - Green when ready to record
  - Red with pulsing animation when recording
  - Smooth transitions and hover effects
- **Real-time status display** showing:
  - Current recording state
  - Partial transcription during recording
  - Error messages and setup instructions
- **Stay-on-top window** that doesn't interfere with other applications
- **Smart window positioning** at top-right corner of screen

#### **Smart Text Input System**
- **Text queuing** during recording (doesn't interrupt speech)
- **Batch typing** when recording stops for better UX
- **Focus management** that returns to previous application automatically
- **xdotool integration** for accurate keyboard simulation
- **Error handling** for missing dependencies or permission issues

#### **Installation & Setup Infrastructure**
- **Automated setup script** (`setup.sh`) that:
  - Installs all system dependencies
  - Downloads and configures VOSK model
  - Sets up Python virtual environment
  - Creates desktop entry for menu integration
- **Smart launcher script** (`launch.sh`) that:
  - Handles proper environment setup
  - Positions window automatically
  - Manages multiple instances
  - Installs xdotool if missing
- **Virtual environment support** for isolated dependencies
- **Desktop entry** for Ubuntu application menu integration

#### **Development & Documentation**
- **Comprehensive README** with installation and usage instructions
- **CHANGELOG.md** for tracking version history
- **TODO.md** for development roadmap and planned features
- **Requirements.txt** for Python dependency management
- **Test scripts** for functionality verification

### Technical Implementation

#### **Architecture**
- **Modular design** with separate concerns (UI, audio, STT, input)
- **Thread-safe implementation** for real-time audio processing
- **Event-driven GTK interface** for responsive user experience
- **Error-resilient design** with graceful degradation

#### **Dependencies & Requirements**
- **Python 3.6+** core runtime
- **GTK 3.0+** for native desktop integration
- **VOSK 0.3.45+** for offline speech recognition
- **sounddevice 0.4.4+** for audio capture
- **PyGObject** for GTK Python bindings
- **xdotool** for keyboard input simulation
- **numpy** for audio data processing

#### **Performance Optimizations**
- **Low-latency audio capture** with minimal buffering
- **Real-time transcription** with immediate visual feedback
- **Efficient memory usage** with proper cleanup
- **Smart text handling** to prevent UI freezing

### Known Issues & Limitations

#### **Platform Dependencies**
- **Global hotkey support** (Keybinder) may not be available on all Ubuntu versions
- **xdotool requirements**:
  - Needs system installation via apt
  - May require display server permissions
  - Works best with X11 (limited Wayland support)
- **Audio permissions** may need user configuration for microphone access

#### **Current Limitations**
- **Single language support** (English only, but extensible to other VOSK models)
- **Window positioning** assumes standard display resolutions
- **No configuration GUI** (all settings handled via scripts)
- **No custom hotkey support** (uses Ctrl+Alt+R when available)

### Installation & Quick Start

#### **One-Command Setup**
```bash
git clone <repository>
cd speech-to-text-agent
./setup.sh
./launch.sh
```

#### **Manual Setup Alternative**
```bash
# Install dependencies
sudo apt install python3-gi python3-gi-cairo gir1.2-gtk-3.0 xdotool

# Setup Python environment
python3 -m venv venv
source venv/bin/activate
pip install vosk sounddevice numpy PyGObject

# Download model
mkdir -p models
cd models && wget https://alphacephei.com/vosk/models/vosk-model-small-en-us-0.15.zip
unzip vosk-model-small-en-us-0.15.zip
```

### Usage Instructions

1. **Launch application** via desktop menu or `./launch.sh`
2. **Click "Start Recording"** button (or use Ctrl+Alt+R if available)
3. **Speak clearly** into your microphone
4. **Click "Stop Recording"** when finished
5. **Text automatically types** into your previous application

### Future Roadmap

See [TODO.md](TODO.md) for planned features including:
- Multi-language support
- Configuration GUI
- Better Wayland support
- Custom hotkeys
- Voice commands
- Dictation profiles

---

## Project Statistics

- **Version**: 0.1.0 Alpha
- **Development Time**: Initial development cycle
- **Lines of Code**: ~400 lines Python
- **Tested on**: Ubuntu 22.04 LTS with GNOME
- **Model Size**: 40MB VOSK English model
- **Dependencies**: 8 main packages

---

*For complete documentation, see [README.md](README.md).*

---

## Project Information

- **Version**: 0.1.0
- **Status**: Alpha / Development Release
- **License**: Open Source
- **Developer**: Speech-to-Text Agent Team
- **Last Updated**: 2025-01-15

## Future Plans

See [TODO.md](TODO.md) for planned features and upcoming improvements.

---

*For the full project documentation and installation instructions, see the [README.md](README.md).*
