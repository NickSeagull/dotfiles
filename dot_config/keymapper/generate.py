#!/usr/bin/env python3
"""
Key Mapper JSON generator for Android.

Translates kanata-style layer definitions into Key Mapper backup JSON
that can be imported on Android devices (tested with Boox Tab XC).

Usage:
    python generate.py > keymapper-backup.json
    # Then transfer the JSON file to Android and import via Key Mapper app

The layer definitions mirror the kanata config in ../kanata/kanata.kbd.tmpl
so both desktop (kanata) and Android (Key Mapper) have identical bindings.
"""

import json
import uuid
from dataclasses import dataclass
from typing import Optional

# ─── Android KeyEvent codes ────────────────────────────────────────────
# Reference: android.view.KeyEvent
KEYCODE = {
    "a": 29,
    "b": 30,
    "c": 31,
    "d": 32,
    "e": 33,
    "f": 34,
    "g": 35,
    "h": 36,
    "i": 37,
    "j": 38,
    "k": 39,
    "l": 40,
    "m": 41,
    "n": 42,
    "o": 43,
    "p": 44,
    "q": 45,
    "r": 46,
    "s": 47,
    "t": 48,
    "u": 49,
    "v": 50,
    "w": 51,
    "x": 52,
    "y": 53,
    "z": 54,
    "0": 7,
    "1": 8,
    "2": 9,
    "3": 10,
    "4": 11,
    "5": 12,
    "6": 13,
    "7": 14,
    "8": 15,
    "9": 16,
    "space": 62,
    "enter": 66,
    "escape": 111,
    "backspace": 67,
    "tab": 61,
    "caps_lock": 115,
    "=": 70,
    "-": 69,
    ";": 74,
    "ctrl_left": 113,
    "alt_left": 57,
    "shift_left": 59,
    "meta_left": 117,
}

# Meta state bit flags for modifier keys in actions
META_CTRL = 4096  # META_CTRL_ON
META_ALT = 2  # META_ALT_ON
META_SHIFT = 1  # META_SHIFT_ON

# Key Mapper constants
CLICK_SHORT = 0
CLICK_LONG = 1
TRIGGER_PARALLEL = 0
ACTION_FLAG_HOLD_DOWN = 8
DEVICE_THIS = "io.github.sds100.keymapper.THIS_DEVICE"
DB_VERSION = 10


def uid() -> str:
    return str(uuid.uuid4())


@dataclass
class Keymap:
    """A single Key Mapper keymap entry."""

    trigger_keys: list[int]
    action_type: str
    action_data: str
    action_meta: int = 0
    action_flags: int = 0
    trigger_click_type: int = CLICK_SHORT
    trigger_mode: int = TRIGGER_PARALLEL
    long_press_delay: Optional[int] = None

    def to_dict(self, keymap_id: int) -> dict:
        trigger_key_dicts = []
        for kc in self.trigger_keys:
            trigger_key_dicts.append(
                {
                    "keyCode": kc,
                    "clickType": self.trigger_click_type,
                    "deviceId": DEVICE_THIS,
                    "flags": 0,
                    "uid": uid(),
                }
            )

        trigger_extras = []
        if self.long_press_delay is not None:
            trigger_extras.append(
                {
                    "id": "extra_long_press_delay",
                    "data": str(self.long_press_delay),
                }
            )

        action_extras = []
        if self.action_meta:
            action_extras.append(
                {
                    "id": "extra_meta_state",
                    "data": str(self.action_meta),
                }
            )

        return {
            "id": keymap_id,
            "uid": uid(),
            "isEnabled": True,
            "flags": 0,
            "constraintList": [],
            "constraintMode": 1,
            "trigger": {
                "keys": trigger_key_dicts,
                "mode": self.trigger_mode,
                "extras": trigger_extras,
                "flags": 0,
            },
            "actionList": [
                {
                    "type": self.action_type,
                    "data": self.action_data,
                    "extras": action_extras,
                    "flags": self.action_flags,
                    "uid": uid(),
                }
            ],
        }


def layer_keymaps(
    hold_key: int,
    bindings: dict[int, tuple[int, int]],
    long_press_delay: int = 300,
) -> list[Keymap]:
    """
    Create keymaps for a hold-to-activate layer.

    Key Mapper doesn't have native layer support, so we simulate it with
    parallel trigger combos: hold_key + action_key pressed together.

    Args:
        hold_key: The keycode of the layer activation key (e.g., 'e', 'z')
        bindings: Mapping of {trigger_keycode: (action_keycode, meta_state)}
        long_press_delay: Long press threshold in ms
    """
    keymaps = []
    for trigger_kc, (action_kc, meta) in bindings.items():
        keymaps.append(
            Keymap(
                trigger_keys=[hold_key, trigger_kc],
                action_type="KEY_EVENT",
                action_data=str(action_kc),
                action_meta=meta,
                long_press_delay=long_press_delay,
            )
        )
    return keymaps


def tap_hold_keymap(
    key: int,
    tap_key: int,
    hold_key: int,
    tap_meta: int = 0,
    hold_meta: int = 0,
    long_press_delay: int = 300,
) -> list[Keymap]:
    """
    Create a tap/hold dual-function key.

    Short press → tap action, long press → hold action.
    Key Mapper supports this natively via clickType.
    """
    return [

        Keymap(
            trigger_keys=[key],
            action_type="KEY_EVENT",
            action_data=str(tap_key),
            action_meta=tap_meta,
            trigger_click_type=CLICK_SHORT,
        ),

        Keymap(
            trigger_keys=[key],
            action_type="KEY_EVENT",
            action_data=str(hold_key),
            action_meta=hold_meta,
            trigger_click_type=CLICK_LONG,
            action_flags=ACTION_FLAG_HOLD_DOWN,
            long_press_delay=long_press_delay,
        ),
    ]


# ─── Layer definitions (mirrors kanata.kbd.tmpl) ───────────────────────


def define_e_mode() -> list[Keymap]:
    """
    e-mode: Hold e → Ctrl (primary modifier on Android).
    Mirrors kanata: e = lmet (macOS) / lctl (Windows/Android)

    e+c = Ctrl+C (copy)
    e+v = Ctrl+V (paste)
    e+x = Ctrl+X (cut)
    e+z = Ctrl+Z (undo)
    e+a = Ctrl+A (select all)
    e+s = Ctrl+S (save)
    e+w = Ctrl+W (close tab)
    e+t = Ctrl+T (new tab)
    e+f = Ctrl+F (find)
    e+q = Ctrl+Q (quit)
    e+n = Ctrl+N (new)
    e+p = Ctrl+P (print/palette)
    e+l = Ctrl+L (address bar)
    e+k = Ctrl+K (link/command)
    e+h = Ctrl+H (history/replace)
    e+j = Ctrl+J (downloads)
    """
    bindings = {}

    for letter in "abcdefghijklmnopqrstuvwxyz":
        if letter == "e":
            continue
        bindings[KEYCODE[letter]] = (KEYCODE[letter], META_CTRL)
    bindings[KEYCODE["="]] = (KEYCODE["="], META_CTRL)
    bindings[KEYCODE["-"]] = (KEYCODE["-"], META_CTRL)
    bindings[KEYCODE["0"]] = (KEYCODE["0"], META_CTRL)

    return layer_keymaps(
        hold_key=KEYCODE["e"],
        bindings=bindings,
    )


def define_z_mode() -> list[Keymap]:
    """
    z-mode: Hold z → Zellij navigation.
    Mirrors kanata zellij layer exactly.

    z+h = Alt+H (pane left)
    z+j = Alt+J (pane down)
    z+k = Alt+K (pane up)
    z+l = Alt+L (pane right)
    z+n = Alt+N (new pane)
    z+p = Alt+P (session manager)
    z+= = Alt+= (resize grow)
    z+- = Alt+- (resize shrink)
    z+space = Ctrl+G (Zellij command layer)
    """
    bindings = {
        KEYCODE["h"]: (KEYCODE["h"], META_ALT),
        KEYCODE["j"]: (KEYCODE["j"], META_ALT),
        KEYCODE["k"]: (KEYCODE["k"], META_ALT),
        KEYCODE["l"]: (KEYCODE["l"], META_ALT),
        KEYCODE["n"]: (KEYCODE["n"], META_ALT),
        KEYCODE["p"]: (KEYCODE["p"], META_ALT),
        KEYCODE["="]: (KEYCODE["="], META_ALT),
        KEYCODE["-"]: (KEYCODE["-"], META_ALT),
        KEYCODE["space"]: (KEYCODE["g"], META_CTRL),  # Ctrl+G for command layer
    }
    return layer_keymaps(
        hold_key=KEYCODE["z"],
        bindings=bindings,
    )


def define_caps_esc_ctrl() -> list[Keymap]:
    """
    CapsLock: tap = Escape, long press = Ctrl (held).
    Mirrors kanata: cap (tap-hold-release $tt $ht esc lctl)
    """
    return tap_hold_keymap(
        key=KEYCODE["caps_lock"],
        tap_key=KEYCODE["escape"],
        hold_key=KEYCODE["ctrl_left"],
    )


# ─── Main ──────────────────────────────────────────────────────────────


def generate_backup() -> dict:
    """Generate a complete Key Mapper backup JSON."""
    all_keymaps: list[Keymap] = []
    all_keymaps.extend(define_e_mode())
    all_keymaps.extend(define_z_mode())
    all_keymaps.extend(define_caps_esc_ctrl())
    keymap_list = []
    for i, km in enumerate(all_keymaps):
        keymap_list.append(km.to_dict(keymap_id=i))

    return {
        "device_info": [
            {
                "descriptor": DEVICE_THIS,
                "name": "Boox Keyboard",
            }
        ],
        "keymap_db_version": DB_VERSION,
        "keymap_list": keymap_list,
    }


if __name__ == "__main__":
    backup = generate_backup()
    print(json.dumps(backup, indent=2))
