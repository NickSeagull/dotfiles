"""Generate Kanata's layout from portable actions and the macOS adapter."""
import json
from pathlib import Path

HERE = Path(__file__).parent
# All standard keyboard keys, including modifiers, function and media keys, are
# processed so they interrupt pending holds and are inert in action layers.
KEYS = ("esc f1 f2 f3 f4 f5 f6 f7 f8 f9 f10 f11 f12 f13 f14 f15 f16 f17 f18 f19 f20 f21 f22 f23 f24 "
        "grv 1 2 3 4 5 6 7 8 9 0 - = bspc tab q w e r t y u i o p [ ] \\ "
        "caps a s d f g h j k l ; ' ret lsft z x c v b n m , . / rsft "
        "lctl lmet lalt spc ralt rmet rctl fn ins del home end pgup pgdn left down up rght "
        "slck pause nlck kp/ kp* kp- kp+ kprt kp. kp0 kp1 kp2 kp3 kp4 kp5 kp6 kp7 kp8 kp9 "
        "mute vold volu prev pp next eject bldn blup").split()
MODIFIERS = "lsft rsft lctl rctl lalt ralt lmet rmet".split()


def generate(layout=None, adapter=None):
    layout = layout or json.loads((HERE / "layout.json").read_text())
    adapter = adapter or json.loads((HERE / "macos.json").read_text())
    lines = [";; Generated; edit layout.json or the platform adapter.",
             "(defcfg process-unmapped-keys yes concurrent-tap-hold yes log-layer-changes no)",
             "(defsrc " + " ".join(KEYS) + ")"]
    # Release outputs on trigger release even if a movement key remains down.
    cleanup = " ".join(f"(release-key {k})" for k in ["left", "down", "up", "rght", *MODIFIERS])
    lines += [f"(defvirtualkeys cleanup (multi {cleanup}))"]
    base = {}
    for key, mod in layout["modifiers"].items():
        base[key] = mod
    for layer, keys in layout["layers"].items():
        for key in keys:
            hold = f"(layer-while-held {layer})"
            if layer in ("text", "selection"):
                hold = f"(multi {hold} (on-release tap-vkey cleanup))"
            base[key] = hold
    entries = []
    for key in KEYS:
        hold = base.get(key)
        if hold:
            # Zero repress window: double-tapping must not bypass intentional holds.
            tap_hold = f"(tap-hold-tap-keys 0 {layout['hold_ms']} {key} {hold} ({' '.join(k for k in KEYS if k != key)}))"
            # Physical or already-active modifiers preserve existing shortcuts.
            entries.append(f"(fork {tap_hold} {key} ({' '.join(MODIFIERS)}))")
        else:
            entries.append(key)
    lines += ["(deflayer base\n " + "\n ".join(entries) + ")"]
    for layer in layout["layers"]:
        actions = {}
        if layer in ("text", "selection"):
            for key, action in layout["movement"].items():
                chord = adapter["movement"][action]
                actions[key] = ("S-" + chord) if layer == "selection" else chord
        else:
            actions = {key: f'(push-msg "{action}")' for key, action in layout["actions"][layer].items()}
        lines += [f"(deflayermap ({layer})\n " + "\n ".join(f"{key} {action}" for key, action in actions.items()) + "\n ___ XX)"]
    return "\n\n".join(lines) + "\n"


if __name__ == "__main__":
    print(generate(), end="")
