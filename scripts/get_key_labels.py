# get_key_labels.py
import json
import socket
import os
import sys
import threading
import time
import subprocess

# Dictionary to store the state of each key
key_states = {
    "Q": False, "W": False, "E": False, "R": False, "T": False,
    "Y": False, "U": False, "I": False, "O": False, "P": False,
    "A": False, "S": False, "D": False, "F": False, "G": False,
    "H": False, "J": False, "K": False, "L": False, ";": False,
    "Z": False, "X": False, "C": False, "V": False, "B": False,
    "N": False, "M": False, ",": False, ".": False, "/": False,
    "[": False, "'": False, "-": False,
    "CTL": False, "LOW": False, "SPC": False, "RSE": False, "SFT": False, 
    "TAB": False, "ESC": False, "BSPC": False, "WIN": False, 
    "L1": False, "L2": False, "RTRN": False, "ALT": False
}

key_code_map = {
    15: "TAB", 42: "SFT", 29: "CTL",
    16: "Q", 30: "A", 44: "Z",
    17: "W", 31: "S", 45: "X",
    18: "E", 32: "D", 46: "C",
    19: "R", 33: "F", 47: "V",
    20: "T", 34: "G", 48: "B",
    21: "Y", 35: "H", 49: "N",
    22: "U", 36: "J", 50: "M",
    23: "I", 37: "K", 51: ",",
    24: "O", 38: "L", 52: ".",
    25: "P", 39: ";", 53: "/",
    14: "BSPC", 40: "'", 1: "ESC",
    125: "WIN", 100: "L1", 57: "SPC",
    28: "RTRN", 102: "L2", 56: "ALT"
}

def output_key_state():
    """Output the current key labels and states as JSON."""
    key_data = {
        "labels": [
            ["TAB", "SFT", "CTL"],
            ["Q", "A", "Z"],
            ["W", "S", "X"],
            ["E", "D", "C"],
            ["R", "F", "V"],
            ["T", "G", "B"],
            ["Y", "H", "N"],
            ["U", "J", "M"],
            ["I", "K", ","],
            ["O", "L", "."],
            ["P", ";", "/"],
            ["BSPC", "'", "ESC"],
            ["WIN", "L1", "SPC"],
            ["RTRN", "L2", "ALT"]
        ],
        "active_keys": key_states
    }
    print(json.dumps(key_data))
    sys.stdout.flush()  # Ensure immediate output

def parse_key_events(output):
    try:
        event_data = json.loads(output)
        key_code = event_data["key_code"]
        event_value = event_data["event_value"]
        key_name = key_code_map.get(key_code)
        
        if key_name:
            if event_value == 1:  # Key press
                key_states[key_name] = True
                output_key_state()  # Output immediately on key press
            elif event_value == 0:  # Key release
                key_states[key_name] = False
                output_key_state()  # Output immediately on key release
    except json.JSONDecodeError:
        print(f"Invalid JSON: {output}", file=sys.stderr)

def main():
    # Output initial state
    output_key_state()

    # Run the C script as a subprocess
    c_script_path = "/home/jamie/.config/eww/scripts/read_keypresses"
    process = subprocess.Popen(c_script_path, stdout=subprocess.PIPE, bufsize=1, universal_newlines=True)

    while True:
        output = process.stdout.readline()
        if output:
            parse_key_events(output.strip())
        else:
            break

if __name__ == "__main__":
    main()
