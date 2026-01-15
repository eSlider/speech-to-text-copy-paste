#!/usr/bin/env python3
"""
Speech-to-Text Agent for Ubuntu GNOME
- Captures audio from microphone
- Converts speech to text using VOSK
- Inserts text into active application using xdotool
- Supports global hotkey activation
"""

import gi

gi.require_version("Gtk", "3.0")
gi.require_version("Gdk", "3.0")

import sys
import os
import threading
import subprocess
import json
import queue
import time

import gi
from gi.repository import Gtk, Gdk, GLib, GObject

# Try to import keybinder, but make it optional
try:
    gi.require_version("Keybinder", "3.0")
    from gi.repository import Keybinder

    HAS_KEYBINDER = True
except (ValueError, ImportError):
    HAS_KEYBINDER = False
    print("Keybinder not available - global hotkeys disabled")

try:
    import sounddevice as sd
    import vosk
    import numpy as np
except ImportError as e:
    print(f"Missing dependency: {e}")
    print("Install with: pip install vosk sounddevice numpy")
    sys.exit(1)


class SpeechToTextApp(Gtk.Window):
    def __init__(self):
        super().__init__(title="Speech-to-Text Agent")
        self.set_default_size(350, 150)
        self.set_resizable(False)
        self.set_keep_above(True)
        self.set_decorated(True)
        self.stick()  # Show on all workspaces

        # Recording state
        self.is_recording = False
        self.recording_thread = None
        self.audio_queue = queue.Queue()
        self.pending_text = []
        self.last_active_window = None

        # STT setup
        self.model = None
        self.recognizer = None
        self.sample_rate = 16000

        # UI setup
        self.setup_ui()

        # Global hotkey setup
        self.setup_hotkey()

        # Initialize STT model
        self.init_stt_model()

    def setup_ui(self):
        """Setup the GTK user interface"""
        vbox = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=10)
        vbox.set_border_width(20)
        self.add(vbox)

        # Status label
        self.status_label = Gtk.Label(label="Ready")
        self.status_label.get_style_context().add_class("status-label")
        vbox.pack_start(self.status_label, False, False, 0)

        # Record/Pause button
        self.record_button = Gtk.Button(label="🎤 Start Recording")
        self.record_button.set_size_request(200, 50)
        self.record_button.connect("clicked", self.toggle_recording)
        self.record_button.get_style_context().add_class("record-button")
        vbox.pack_start(self.record_button, False, False, 0)

        # Instructions label
        if HAS_KEYBINDER:
            instructions = Gtk.Label(
                label="Press Ctrl+Alt+R or click button\nto start recording"
            )
        else:
            instructions = Gtk.Label(
                label="Click button to start recording\n(Global hotkey not available)"
            )
        instructions.get_style_context().add_class("instructions")
        vbox.pack_start(instructions, False, False, 0)

        # Apply CSS styling
        self.apply_css()

    def apply_css(self):
        """Apply CSS styling to the UI"""
        css_provider = Gtk.CssProvider()
        css = """
        .record-button {
            font-size: 14px;
            font-weight: bold;
            border-radius: 25px;
            background-color: #4CAF50;
            color: white;
            border: none;
            box-shadow: 0 2px 5px rgba(0,0,0,0.2);
        }
        .record-button:hover {
            background-color: #45a049;
        }
        .record-button.recording {
            background-color: #f44336;
            animation: pulse 1.5s infinite;
        }
        .record-button.recording:hover {
            background-color: #da190b;
        }
        .status-label {
            font-size: 16px;
            font-weight: bold;
        }
        .instructions {
            font-size: 12px;
            color: #666;
        }
        @keyframes pulse {
            0% { opacity: 1; }
            50% { opacity: 0.7; }
            100% { opacity: 1; }
        }
        """
        css_provider.load_from_data(css.encode())

        style_context = self.get_style_context()
        style_context.add_provider(
            css_provider, Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION
        )

    def setup_hotkey(self):
        """Setup global hotkey for recording"""
        if HAS_KEYBINDER:
            try:
                Keybinder.init()
                # Bind Ctrl+Alt+R for toggle recording
                Keybinder.bind("<Ctrl><Alt>R", self.hotkey_toggle_recording)
                print("Global hotkey Ctrl+Alt+R registered")
            except Exception as e:
                print(f"Failed to setup global hotkey: {e}")
        else:
            print("Global hotkey support not available - use button instead")

    def hotkey_toggle_recording(self, keystring, user_data):
        """Handle global hotkey press"""
        GLib.idle_add(self.toggle_recording)

    def init_stt_model(self):
        """Initialize VOSK STT model"""
        try:
            # Try to find a model in common locations
            model_paths = [
                "./models/vosk-model-small-en-us-0.15",
                os.path.expanduser("~/.local/share/vosk-model"),
                "./vosk-model",
                "/usr/share/vosk-model",
            ]

            model_path = None
            for path in model_paths:
                if os.path.exists(path):
                    model_path = path
                    break

            if not model_path:
                self.status_label.set_text("Model not found")
                print("VOSK model not found. Please download a model:")
                print(
                    "wget https://alphacephei.com/vosk/models/vosk-model-small-en-us-0.15.zip"
                )
                print("unzip vosk-model-small-en-us-0.15.zip -d ./models/")
                return

            self.model = vosk.Model(model_path)
            self.recognizer = vosk.KaldiRecognizer(self.model, self.sample_rate)
            self.status_label.set_text("Ready")
            print(f"VOSK model loaded from: {model_path}")

        except Exception as e:
            self.status_label.set_text("STT Error")
            print(f"Failed to initialize STT model: {e}")

    def toggle_recording(self, button=None):
        """Toggle recording state"""
        if self.is_recording:
            self.stop_recording()
        else:
            self.start_recording()

    def save_active_window(self):
        """Save the currently active window"""
        try:
            result = subprocess.run(
                ["xdotool", "getactivewindow"], capture_output=True, text=True
            )
            if result.returncode == 0:
                self.last_active_window = result.stdout.strip()
        except Exception:
            self.last_active_window = None

    def start_recording(self):
        """Start recording audio"""
        if not self.model:
            self.status_label.set_text("No Model")
            return

        # Save current active window
        self.save_active_window()

        self.is_recording = True
        self.record_button.set_label("⏹️ Stop Recording")
        self.record_button.get_style_context().add_class("recording")
        self.status_label.set_text("Recording...")
        self.pending_text = []  # Clear pending text

        # Start recording thread
        self.recording_thread = threading.Thread(target=self.record_audio)
        self.recording_thread.daemon = True
        self.recording_thread.start()

    def stop_recording(self):
        """Stop recording audio"""
        self.is_recording = False
        self.record_button.set_label("🎤 Start Recording")
        self.record_button.get_style_context().remove_class("recording")
        self.status_label.set_text("Processing...")

        # Type all pending text after a short delay
        if self.pending_text:
            threading.Timer(0.5, self.type_all_pending_text).start()

    def record_audio(self):
        """Record audio and perform speech recognition"""

        def audio_callback(indata, frames, time, status):
            """Callback for audio stream"""
            if status:
                print(f"Audio callback error: {status}")
            self.audio_queue.put(bytes(indata))

        try:
            with sd.RawInputStream(
                samplerate=self.sample_rate,
                blocksize=8000,
                dtype="int16",
                channels=1,
                callback=audio_callback,
            ):
                print("Recording started...")
                while self.is_recording:
                    data = self.audio_queue.get()
                    if self.recognizer.AcceptWaveform(data):
                        result = json.loads(self.recognizer.Result())
                        text = result.get("text", "").strip()
                        if text:
                            print(f"Recognized: {text}")
                            self.type_text(text)
                    else:
                        # Partial result (optional: show real-time feedback)
                        partial = json.loads(self.recognizer.PartialResult())
                        partial_text = partial.get("partial", "").strip()
                        if partial_text:
                            GLib.idle_add(
                                lambda: self.status_label.set_text(
                                    f"Recording: {partial_text[:30]}..."
                                )
                            )

                # Get final result when stopping
                final_result = json.loads(self.recognizer.FinalResult())
                final_text = final_result.get("text", "").strip()
                if final_text:
                    print(f"Final: {final_text}")
                    self.type_text(final_text)

        except Exception as e:
            print(f"Audio recording error: {e}")
            GLib.idle_add(lambda: self.status_label.set_text("Audio Error"))

    def type_text(self, text):
        """Type text into active window using xdotool"""
        try:
            # Store text for later typing when recording stops
            self.pending_text.append(text)
            print(f"Queued: {text}")
        except Exception as e:
            print(f"Failed to queue text: {e}")

    def type_all_pending_text(self):
        """Type all pending text and return focus to previous window"""
        if not self.pending_text:
            return

        try:
            # Restore focus to previous window if available
            if self.last_active_window:
                subprocess.run(
                    ["xdotool", "windowactivate", self.last_active_window],
                    check=True,
                    capture_output=True,
                )
                time.sleep(0.2)  # Brief pause for window activation

            # Type all accumulated text
            full_text = " ".join(self.pending_text).strip()
            if full_text:
                subprocess.run(["xdotool", "type", full_text], check=True)
                print(f"Typed: {full_text}")

            # Update status
            GLib.idle_add(lambda: self.status_label.set_text("Ready"))

        except subprocess.CalledProcessError as e:
            print(f"Failed to type text: {e}")
            GLib.idle_add(lambda: self.status_label.set_text("Type Error"))
        except FileNotFoundError:
            print("xdotool not found. Install with: sudo apt install xdotool")
            GLib.idle_add(lambda: self.status_label.set_text("xdotool Missing"))

    def on_destroy(self, widget):
        """Handle window destroy event"""
        self.stop_recording()
        Gtk.main_quit()


def main():
    app = SpeechToTextApp()
    app.connect("destroy", app.on_destroy)
    app.show_all()
    Gtk.main()


if __name__ == "__main__":
    main()
