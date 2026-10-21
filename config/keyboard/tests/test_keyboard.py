"""Acceptance traces run against upstream Kanata, not a reimplemented model."""
import importlib
import json
import os
from pathlib import Path
import re
import socket
import subprocess
import sys
import tempfile
import types
import unittest
from unittest.mock import Mock, patch

SOURCE = Path(os.environ.get("KEYBOARD_SOURCE", Path(__file__).resolve().parents[1]))
sys.path.insert(0, str(SOURCE))
from generate import generate
from runner import dispatch_message
from service import State, Supervisor, peer_uid


class Dispatch(unittest.TestCase):
    def test_every_configured_named_action_uses_kanata_array_payload(self):
        layout = json.loads((SOURCE / "layout.json").read_text())
        adapter = json.loads((SOURCE / "macos.json").read_text())
        for bindings in layout["actions"].values():
            for action in bindings.values():
                with self.subTest(action=action):
                    helper = Mock()
                    dispatch_message([action], helper, adapter)
                    if action.startswith("launch."):
                        helper.call.assert_called_once_with("launch", bundle=adapter["apps"][action.split(".", 1)[1]])
                    else:
                        helper.call.assert_called_once_with(action)

    def test_malformed_and_unknown_actions_never_reach_native_helper(self):
        adapter = json.loads((SOURCE / "macos.json").read_text())
        for payload in (None, "launch.telegram", {}, [], [42], [["launch.telegram"]],
                        ["launch.telegram", "app.next"], ["launch.unknown"], ["unknown"]):
            with self.subTest(payload=payload):
                helper = Mock()
                with self.assertRaises((RuntimeError, KeyError)):
                    dispatch_message(payload, helper, adapter)
                helper.call.assert_not_called()


class Traces(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.simulator = os.environ.get("KANATA_SIMULATOR")
        if not cls.simulator:
            raise unittest.SkipTest("set KANATA_SIMULATOR to the pinned upstream simulator")
        cls.directory = tempfile.TemporaryDirectory()
        cls.config = Path(cls.directory.name) / "kanata.kbd"
        cls.config.write_text(generate())

    @classmethod
    def tearDownClass(cls):
        cls.directory.cleanup()

    def trace(self, sequence):
        path = Path(self.directory.name) / "trace.txt"
        path.write_text(sequence + "\n")
        result = subprocess.run([self.simulator, "-c", str(self.config), "-s", str(path)], capture_output=True, text=True, timeout=10)
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        outputs = re.findall(r"out:([↓↑][A-Za-z0-9]+)", result.stdout)
        return outputs, result.stdout + result.stderr

    def test_200ms_boundary_and_no_solo_repeat(self):
        for delay in (1, 100, 198):
            out, _ = self.trace(f"↓z 🕐{delay} ↑z 🕐10")
            self.assertEqual(out, ["↓Z", "↑Z"], delay)
        out, _ = self.trace("↓z 🕐201 ↑z 🕐20")
        self.assertEqual(out, [])
        out, _ = self.trace("↓a 🕐201 ↑a 🕐20")
        self.assertEqual(out, ["↓LShift", "↑LShift"])

    def test_interruption_cancels_until_release(self):
        out, _ = self.trace("↓z 🕐40 ↓q 🕐20 ↑q 🕐300 ↑z 🕐20")
        self.assertEqual(out, ["↓Z", "↓Q", "↑Q", "↑Z"])
        out, _ = self.trace("↓a 🕐40 ↓q 🕐20 ↑q 🕐300 ↑a 🕐20")
        self.assertEqual(out, ["↓A", "↓Q", "↑Q", "↑A"])
        # An interruption 1 ms before threshold must not turn into a layer.
        out, _ = self.trace("↓z 🕐198 ↓q 🕐30 ↑q ↑z 🕐20")
        self.assertEqual(out, ["↓Z", "↓Q", "↑Q", "↑Z"])

    def test_fast_rolling_typing_and_punctuation(self):
        out, _ = self.trace("↓f 🕐30 ↓a 🕐20 ↑f 🕐20 ↓s 🕐20 ↑a 🕐20 ↓t 🕐20 ↑s 🕐20 ↑t 🕐20 ↓, 🕐20 ↓. 🕐20 ↑, 🕐20 ↑. 🕐20")
        self.assertEqual([k for k in out if k.startswith("↓")], ["↓F", "↓A", "↓S", "↓T", "↓Comma", "↓Dot"])
        self.assertFalse(any("Shift" in k or "Ctrl" in k or "Gui" in k for k in out))

    def test_physical_modifiers_preserve_shortcuts(self):
        for key in ("c", "e", "o", "z", "j", "spc"):
            out, _ = self.trace(f"↓lmet 🕐5 ↓{key} 🕐250 ↑{key} 🕐5 ↑lmet 🕐20")
            self.assertEqual(len(out), 4, (key, out))
            self.assertEqual(out[0], "↓LGui")
            self.assertEqual(out[-1], "↑LGui")
            self.assertNotIn("↓RGui", out)
        # Every physical modifier bypasses home-row hold roles, even across
        # overlapping physical modifiers and releases of their separate markers.
        for modifier in ("lsft", "rsft", "lctl", "rctl", "lalt", "ralt", "lmet", "rmet"):
            for key in ("a", "s", "d", "f", "j", "k", "l", ";"):
                out, _ = self.trace(f"↓{modifier} 🕐5 ↓{key} 🕐250 ↑{key} ↑{modifier} 🕐20")
                self.assertEqual(len(out), 4, (modifier, key, out))
                self.assertEqual(out[1], "↓SColon" if key == ";" else f"↓{key.upper()}")
        out, _ = self.trace("↓lmet ↓lalt 🕐5 ↑lmet 🕐5 ↓j 🕐250 ↑j ↑lalt 🕐20")
        self.assertEqual(out, ["↓LGui", "↓LAlt", "↑LGui", "↓J", "↑J", "↑LAlt"])

    def test_home_row_modifiers_stack_in_either_order_and_release_independently(self):
        for first, second, first_mod, second_mod in (
            ("j", "k", "RGui", "RAlt"), ("k", "j", "RAlt", "RGui"),
            ("f", "d", "LGui", "LAlt"), ("d", "f", "LAlt", "LGui"),
            ("j", "d", "RGui", "LAlt"), ("a", "l", "LShift", "RCtrl"),
        ):
            for delay in (0, 30, 210):
                for released_first in (first, second):
                    remaining = second if released_first == first else first
                    released_mod = first_mod if released_first == first else second_mod
                    remaining_mod = second_mod if released_first == first else first_mod
                    out, _ = self.trace(
                        f"↓{first} 🕐{delay} ↓{second} 🕐210 ↓p 🕐20 ↑p "
                        f"↑{released_first} 🕐20 ↓q 🕐20 ↑q ↑{remaining} 🕐20")
                    self.assertEqual(out, [f"↓{first_mod}", f"↓{second_mod}",
                        "↓P", "↑P", f"↑{released_mod}", "↓Q", "↑Q", f"↑{remaining_mod}"],
                        (first, second, delay, released_first))

    def test_simultaneous_modifier_taps_and_early_shortcuts_remain_letters(self):
        out, _ = self.trace("↓j 🕐30 ↓k 🕐30 ↑j 🕐20 ↑k 🕐20")
        self.assertEqual(out, ["↓J", "↓K", "↑J", "↑K"])
        out, _ = self.trace("↓j 🕐30 ↓k 🕐30 ↓p 🕐250 ↑p ↑k ↑j 🕐20")
        self.assertFalse(any("Gui" in k or "Alt" in k for k in out), out)
        out, _ = self.trace("↓j 🕐210 ↓k 🕐30 ↓p 🕐250 ↑p ↑k ↑j 🕐20")
        self.assertEqual(out, ["↓RGui", "↓K", "↓P", "↑P", "↑K", "↑RGui"])

    def test_four_modifiers_stack_without_entering_layers(self):
        out, log = self.trace("↓j ↓k ↓l ↓; 🕐210 ↓p 🕐20 ↑p ↑; ↑l ↑k ↑j 🕐20")
        self.assertEqual(out, ["↓RGui", "↓RAlt", "↓RCtrl", "↓RShift", "↓P", "↑P",
                               "↑RShift", "↑RCtrl", "↑RAlt", "↑RGui"])
        out, log = self.trace("↓j 🕐210 ↓c 🕐250 ↑c ↑j 🕐20")
        self.assertEqual(out, ["↓RGui", "↓C", "↑C", "↑RGui"])
        self.assertNotIn("SIM_MESSAGE", log)

    def test_mirrored_navigation_and_trigger_release_cleanup(self):
        for trigger in ("z", "/"):
            out, _ = self.trace(f"↓{trigger} 🕐210 ↓j 🕐50 ↑{trigger} 🕐50 ↑j 🕐20")
            self.assertEqual(out, ["↓Down", "↑Down"])
        out, _ = self.trace("↓z 🕐210 ↓q 🕐30 ↑q ↑z 🕐20")
        self.assertEqual(out, [])

    def test_selection_cleanup_before_action_key_release(self):
        for trigger in ("g", "h"):
            out, _ = self.trace(f"↓{trigger} 🕐210 ↓w 🕐50 ↑{trigger} 🕐50 ↑w 🕐20")
            self.assertEqual(set(out), {"↓LShift", "↓LAlt", "↓Right", "↑LShift", "↑LAlt", "↑Right"})
            self.assertEqual(len(out), 6)
        out, _ = self.trace("↓g 🕐210 ↓j 🕐50 ↑g 🕐30 ↓q 🕐20 ↑j ↑q 🕐20")
        self.assertIn("↓Q", out)
        self.assertLess(out.index("↑LShift"), out.index("↓Q"))

    def test_repeat_stops_with_trigger_and_unassigned_extended_keys_are_inert(self):
        out, _ = self.trace("↓z 🕐210 ↓j 🕐20 r:j 🕐20 ↑z 🕐20 r:j 🕐20 ↑j 🕐20")
        self.assertEqual(out, ["↓Down", "↓Down", "↑Down"])
        self.assertNotIn("↓RGui", out)
        self.assertNotIn("↓J", out)
        # 102d is deliberately absent from defsrc: the layer wildcard must
        # suppress it rather than fall back to ordinary typing.
        out, _ = self.trace("↓z 🕐210 ↓102d 🕐20 ↑102d ↑z 🕐20")
        self.assertEqual(out, [])

    def test_word_aliases_line_bounds_and_modifiers(self):
        for key in ("w", "e"):
            out, _ = self.trace(f"↓/ 🕐210 ↓{key} 🕐30 ↑{key} ↑/ 🕐20")
            self.assertEqual(out, ["↓LAlt", "↓Right", "↑LAlt", "↑Right"])
        for trigger, key, arrow in (("z", "0", "Left"), ("/", "4", "Right")):
            out, _ = self.trace(f"↓{trigger} 🕐210 ↓{key} 🕐30 ↑{key} ↑{trigger} 🕐20")
            self.assertEqual(set(out), {"↓LGui", f"↓{arrow}", "↑LGui", f"↑{arrow}"})
        for trigger, output in (("s", "LCtrl"), ("l", "RCtrl"), ("d", "LAlt"), ("k", "RAlt"), ("f", "LGui"), ("j", "RGui"), (";", "RShift")):
            out, _ = self.trace(f"↓{trigger} 🕐210 ↑{trigger} 🕐20")
            self.assertEqual(out, [f"↓{output}", f"↑{output}"])

    def test_app_precedence_mirroring_and_once_per_press(self):
        for trigger in ("b", "n"):
            out, log = self.trace(f"↓{trigger} 🕐210 ↓o 🕐700 ↑o 🕐20 ↓o 🕐20 ↑o ↑{trigger} 🕐20")
            self.assertEqual(out, [])
            self.assertEqual(log.count("SIM_MESSAGE"), 2, log)
            self.assertIn("launch.obsidian", log)
        out, log = self.trace("↓b 🕐210 ↓n 🕐600 ↑n ↑b 🕐20")
        self.assertEqual(out, [])
        self.assertEqual(log.count("SIM_MESSAGE"), 1)
        self.assertIn("launch.notion", log)
        for trigger in ("x", "."):
            out, log = self.trace(f"↓{trigger} 🕐210 ↓j 🕐600 ↑j ↑{trigger} 🕐20")
            self.assertEqual(out, [])
            self.assertEqual(log.count("SIM_MESSAGE"), 1)
            self.assertIn("window.next", log)


class FailOff(unittest.TestCase):
    def test_persistent_disable_is_not_cleared_by_initialization(self):
        with tempfile.TemporaryDirectory() as directory:
            state = State(directory)
            state.disable("emergency exit status 0")
            self.assertEqual(State(directory).read()["reason"], "emergency exit status 0")
            self.assertEqual((Path(directory).stat().st_mode & 0o777), 0o700)
            self.assertEqual(((Path(directory)/"disabled.json").stat().st_mode & 0o777), 0o600)
            state.enable()
            self.assertIsNone(State(directory).read())

    def test_supervisor_crash_journal_prevents_restart(self):
        with tempfile.TemporaryDirectory() as directory:
            State(directory).journal(True)
            supervisor = Supervisor(types.SimpleNamespace(user=__import__('pwd').getpwuid(os.getuid()).pw_name, state=directory))
            self.assertIn("supervisor interrupted", supervisor.state.read()["reason"])
            self.assertFalse((Path(directory)/"active").exists())
            supervisor.selector.close()

    def test_engine_exit_zero_and_runner_failure_stop_capture(self):
        with tempfile.TemporaryDirectory() as directory:
            supervisor = Supervisor(types.SimpleNamespace(user=__import__('pwd').getpwuid(os.getuid()).pw_name, state=directory))
            engine = Mock()
            engine.poll.return_value = None
            supervisor.engine = engine
            supervisor.state.journal(True)
            with patch("service.subprocess.Popen"):
                supervisor.fail("engine exited (status 0)")
            engine.terminate.assert_called_once()
            engine.wait.assert_called_once()
            self.assertIsNone(supervisor.engine)
            supervisor.start()  # State must prevent a new engine, even after restart.
            self.assertEqual(supervisor.status()["state"], "disabled")
            self.assertFalse((Path(directory)/"active").exists())
            supervisor.selector.close()

    @unittest.skipUnless(sys.platform == "darwin", "Darwin peer credentials")
    def test_control_peer_comes_from_kernel(self):
        left, right = socket.socketpair()
        try:
            self.assertEqual(peer_uid(left), os.getuid())
        finally:
            left.close()
            right.close()
