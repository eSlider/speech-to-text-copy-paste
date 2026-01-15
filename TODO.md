# Speech-to-Text Agent TODO

## Project Status

### Completed
- [x] Research and choose STT engine (VOSK vs Coqui STT)
- [x] Design GTK app architecture with recording status button
- [x] Create main application structure with GTK UI
- [x] Implement basic recording toggle functionality
- [x] Add CSS styling for recording status button
- [x] Setup global hotkey framework with Keybinder
- [x] Integrate xdotool for text input simulation

### Completed
- [x] Setup project structure and dependencies
- [x] Initialize VOSK STT model and audio capture
- [x] Test audio recording functionality
- [x] Implement real-time speech recognition
- [x] Install required system dependencies
- [x] Download and setup VOSK model
- [x] Test text input simulation with xdotool
- [x] Add error handling and status feedback
- [x] Create installation script
- [x] Add window positioning and stay-on-top functionality
- [x] Add desktop entry for easy access
- [x] Improve text queuing and delayed typing

### In Progress
- [ ] Test global hotkey functionality with alternative approach
- [ ] Test across different applications
- [ ] Fine-tune window positioning and focus management

### Pending
- [ ] Package for Ubuntu GNOME deployment
- [ ] Create system integration for global hotkeys
- [ ] Add configuration dialog for settings
- [ ] Optimize performance and reduce latency

## Next Steps

1. **Dependencies Setup**
   - Install Python packages: vosk, sounddevice, numpy, PyGObject
   - Install system packages: xdotool, libkeybinder-dev
   - Download VOSK English model

2. **Testing Phase**
   - Test audio capture from microphone
   - Test speech recognition accuracy
   - Test text input in various applications
   - Test global hotkey functionality

3. **Refinement**
   - Add visual feedback for partial recognition
   - Improve error handling and user feedback
   - Add settings/configuration dialog
   - Optimize performance and latency

## Dependencies Required

### Python Packages
```
vosk>=0.3.45
sounddevice>=0.4.4
numpy>=1.21.0
PyGObject>=3.42.0
```

### System Packages
```
sudo apt install python3-gi python3-gi-cairo gir1.2-gtk-3.0
sudo apt install xdotool
sudo apt install libkeybinder-dev python3-keybinder
sudo apt install libasound2-dev portaudio19-dev
```

### VOSK Model
```
wget https://alphacephei.com/vosk/models/vosk-model-small-en-us-0.15.zip
unzip vosk-model-small-en-us-0.15.zip -d ~/.local/share/vosk-model
```

## Known Issues

- LSP errors due to missing dependencies during development
- Need to handle cases where VOSK model is not found
- Audio device permissions may need configuration
- Global hotkey may require additional permissions on some systems