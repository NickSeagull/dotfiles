"""User-session action consumer. Any failed dispatch disables input remapping."""
import argparse
import json
import os
from pathlib import Path
import selectors
import signal
import socket
import subprocess
import sys
import time
from service import SOCKET, packet


def dispatch_message(payload, actions, adapter):
    # Kanata serializes push-msg's arguments as a JSON array, even for the
    # single named action emitted by our generator. Reject other shapes before
    # invoking the native helper; never flatten or execute multiple arguments.
    if not isinstance(payload, list) or len(payload) != 1 or not isinstance(payload[0], str):
        raise RuntimeError("invalid named action payload: expected one string in an array")
    action = payload[0]
    if action.startswith("launch."):
        actions.call("launch", bundle=adapter["apps"][action.split(".", 1)[1]])
    elif action in ("app.next", "app.previous", "window.next", "window.previous"):
        actions.call(action)
    else:
        raise RuntimeError("unknown named action")


class Actions:
    def __init__(self, executable):
        self.process = subprocess.Popen([executable], stdin=subprocess.PIPE, stdout=subprocess.PIPE)
        self.selector = selectors.DefaultSelector()
        self.selector.register(self.process.stdout, selectors.EVENT_READ)
        self.buffer = b""

    def call(self, command, **kwargs):
        if self.process.poll() is not None:
            raise RuntimeError("native action helper exited")
        self.process.stdin.write((json.dumps({"command": command, **kwargs}) + "\n").encode())
        self.process.stdin.flush()
        deadline = time.monotonic() + 3.5
        while b"\n" not in self.buffer:
            if not self.selector.select(max(0, deadline - time.monotonic())):
                raise RuntimeError("native action helper timed out")
            data = os.read(self.process.stdout.fileno(), 65536)
            if not data:
                raise RuntimeError("native action helper disconnected")
            self.buffer += data
        line, self.buffer = self.buffer.split(b"\n", 1)
        result = json.loads(line)
        if result.get("error"):
            raise RuntimeError(result["error"])
        return result

    def close(self):
        self.process.terminate()
        try:
            self.process.wait(timeout=2)
        except subprocess.TimeoutExpired:
            self.process.kill()
            self.process.wait()


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--helper", required=True)
    parser.add_argument("--adapter", required=True)
    parser.add_argument("--socket", default=SOCKET)
    args = parser.parse_args()
    adapter = json.loads(Path(args.adapter).read_text())
    actions = Actions(args.helper)
    stopping = False

    def stop(*_):
        nonlocal stopping
        stopping = True
    signal.signal(signal.SIGTERM, stop)
    signal.signal(signal.SIGINT, stop)
    try:
        while not stopping:
            with socket.socket(socket.AF_UNIX) as conn:
                conn.settimeout(2)
                try:
                    conn.connect(args.socket)
                except (FileNotFoundError, ConnectionRefusedError):
                    time.sleep(0.5)
                    continue
                packet(conn, {"command": "register", **actions.call("permissions")})
                buffer = b""
                window_session = False
                while not stopping:
                    try:
                        data = conn.recv(16384)
                    except socket.timeout:
                        continue
                    if not data:
                        break
                    buffer += data
                    if len(buffer) > 65536:
                        raise RuntimeError("oversized supervisor message")
                    while b"\n" in buffer:
                        line, buffer = buffer.split(b"\n", 1)
                        message = json.loads(line)
                        if message.get("error"):
                            raise RuntimeError(message["error"])
                        if message.get("permissions_prompt"):
                            packet(conn, actions.call("request-permissions"))
                        if message.get("ping"):
                            packet(conn, {"ack": True, **actions.call("permissions")})
                        if message.get("permissions"):
                            packet(conn, actions.call("permissions"))
                        event = message.get("event", {})
                        if "LayerChange" in event:
                            is_windows = event["LayerChange"]["new"] == "windows"
                            if is_windows != window_session:
                                actions.call("begin" if is_windows else "end")
                                window_session = is_windows
                        if "MessagePush" in event:
                            try:
                                dispatch_message(event["MessagePush"]["message"], actions, adapter)
                            except (RuntimeError, KeyError) as error:
                                packet(conn, {"failure": str(error)})
                        packet(conn, {"ack": True})
    finally:
        actions.close()


if __name__ == "__main__":
    main()
