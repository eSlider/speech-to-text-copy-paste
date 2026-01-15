# Speech-to-Text Agent Project

This project will implement a GNOME-compatible Ubuntu application that converts speech to text (STT), and inputs the text into the current application as if it were typed using a keyboard.

## Project Overview
The application will:
1. Capture audio from the microphone in real time.
2. Convert speech to text using a speech recognition backend (e.g., VOSK, Mozilla Coqui STT).
3. Insert transcriptions into the currently active window using tools like `xdotool` or `autokey`.
4. Support hotkey activation/deactivation.

## Steps
### 1. Plan
- Research and decide on the best STT engine (e.g., VOSK, Coqui STT) and integration tools (e.g., Python bindings).
- Draft the architecture combining STT, key-event emulation, and hotkey binding.

### 2. Setup
- Install necessary packages and dependencies (Python, libraries, tools like `xdotool`).
- Create a shortcut key in GNOME settings.

### 3. Code Implementation
- Develop a Python script for:
  - Capturing live audio.
  - Sending transcriptions as keystrokes using `xdotool`.
  - Activating/deactivating functionality with a shortcut key.
- Optimize for low-latency and noise filtering.

### 4. Test
- Test the solution across various applications (e.g., LibreOffice, Terminal, browsers).
- Debug issues with input accuracy and performance.

### 5. Finalize
- Package the tool for easy setup on Ubuntu GNOME (e.g., `.deb` file).
- Provide clear documentation for installation and usage.

## Tools and Dependencies
- **STT Engine**: Mozilla Coqui STT or VOSK.
- **Python Libraries**: `speechrecognition`, `pyaudio`, `xdotool`, `webrtcvad`.
- **System Tools**: `xdotool`, `autokey`.

## Deliverables
- A functional Ubuntu GNOME application with speech-to-text integration.
- Shortcuts for activation/deactivation.
- Well-documented installation and usage instructions.
