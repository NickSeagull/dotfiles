"""Root-owned fail-off supervisor and authenticated, keyboard-accessible control.

Only the configured console user (or root) may use the local control socket.
The engine's read-only TCP notification stream never reaches GUI actions as root.
"""
import argparse
import ctypes
import json
import os
from pathlib import Path
import pwd
import selectors
import signal
import socket
import subprocess
import sys
import time

SOCKET = "/var/run/org.nick.keyboard.sock"
STATE = "/var/db/org.nick.keyboard"


def packet(sock, value):
    sock.sendall((json.dumps(value, separators=(",", ":")) + "\n").encode())


def peer_uid(sock):
    uid, gid = ctypes.c_uint(), ctypes.c_uint()
    libc = ctypes.CDLL(None, use_errno=True)
    if libc.getpeereid(sock.fileno(), ctypes.byref(uid), ctypes.byref(gid)):
        raise OSError(ctypes.get_errno(), "getpeereid")
    return uid.value


def rpc(command, path=SOCKET):
    with socket.socket(socket.AF_UNIX) as conn:
        conn.settimeout(10)
        conn.connect(path)
        packet(conn, {"command": command})
        return json.loads(conn.makefile("rb").readline(65536))


class State:
    def __init__(self, path):
        self.path = Path(path)
        self.path.mkdir(mode=0o700, parents=True, exist_ok=True)
        os.chmod(self.path, 0o700)

    def read(self):
        try:
            return json.loads((self.path / "disabled.json").read_text())
        except FileNotFoundError:
            return None
        except (OSError, ValueError):
            return {"reason": "unreadable disable state"}

    def disable(self, reason):
        value = {"reason": reason, "time": int(time.time())}
        temp = self.path / "disabled.tmp"
        with temp.open("w") as out:
            os.chmod(temp, 0o600)
            json.dump(value, out)
            out.flush()
            os.fsync(out.fileno())
        temp.replace(self.path / "disabled.json")
        return value

    def enable(self):
        (self.path / "disabled.json").unlink(missing_ok=True)

    def journal(self, active):
        path = self.path / "active"
        if active:
            path.write_text("active\n")
        else:
            path.unlink(missing_ok=True)


def driver_active():
    result = subprocess.run(["/usr/bin/systemextensionsctl", "list"], capture_output=True, text=True, timeout=5)
    return any("org.pqrs.Karabiner-DriverKit-VirtualHIDDevice" in line and "[activated enabled]" in line for line in result.stdout.splitlines())


class Supervisor:
    def __init__(self, args):
        self.args = args
        self.uid = pwd.getpwnam(args.user).pw_uid
        self.state = State(args.state)
        # A prior supervisor died without clearing its journal. Never auto-resume.
        if (self.state.path / "active").exists():
            self.state.disable("supervisor interrupted while input capture was active")
        self.state.journal(False)
        self.engine = self.runner = self.tcp = None
        self.reader = None
        self.buffer = b""
        self.pending_since = None
        self.runner_seen = time.monotonic()
        self.stopping = False
        self.starting = None
        self.last_ping = time.monotonic()
        self.selector = selectors.DefaultSelector()

    def status(self):
        disabled = self.state.read()
        return {"disabled": disabled, "engine_pid": self.engine.pid if self.engine else None,
                "runner": self.runner is not None, "accessibility": getattr(self, "runner_permissions", False), "state": "disabled" if disabled else ("running" if self.tcp else ("starting" if self.engine else "waiting-for-runner"))}

    def drop_tcp(self):
        if self.tcp:
            self.selector.unregister(self.tcp)
            self.tcp.close()
            self.tcp = None
        self.buffer = b""
        self.pending_since = None

    def stop_engine(self):
        self.drop_tcp()
        if self.engine:
            if self.engine.poll() is None:
                self.engine.terminate()
                try:
                    self.engine.wait(timeout=3)
                except subprocess.TimeoutExpired:
                    self.engine.kill()
                    self.engine.wait(timeout=2)
            self.engine = None
        self.starting = None
        self.state.journal(False)

    def fail(self, reason):
        first = self.state.read() is None
        # Durable disable precedes stopping or notification.
        self.state.disable(reason)
        self.stop_engine()
        if first:
            # Enter the GUI bootstrap namespace as root, then drop privileges in
            # the short-lived notification helper before invoking AppleScript.
            subprocess.Popen(["/bin/launchctl", "asuser", str(self.uid), sys.executable,
                              __file__, "notify", "--user", self.args.user],
                             stdin=subprocess.DEVNULL, stdout=subprocess.DEVNULL,
                             stderr=subprocess.DEVNULL)
        print(json.dumps({"disabled": reason}), flush=True)

    def start(self):
        if self.engine or self.state.read():
            return
        if not self.runner:
            return
        if os.stat("/dev/console").st_uid != self.uid:
            return
        if not driver_active():
            self.fail("Karabiner 6.2.0 driver requires macOS approval")
            return
        if not self.runner_permissions:
            self.fail("keyboard action runner requires Accessibility permission")
            return
        # Choose a loopback port; the engine rejects all mutating TCP commands.
        with socket.socket() as port_socket:
            port_socket.bind(("127.0.0.1", 0))
            self.port = port_socket.getsockname()[1]
        self.state.journal(True)
        self.engine = subprocess.Popen([self.args.engine, "--cfg", self.args.config,
                                        "--port", f"127.0.0.1:{self.port}", "--no-wait"],
                                       stdin=subprocess.DEVNULL)
        self.starting = time.monotonic()

    def accept(self, server):
        conn, _ = server.accept()
        conn.settimeout(2)
        try:
            if peer_uid(conn) not in (0, self.uid):
                raise PermissionError("control socket peer")
            # Read exactly one bounded line without retaining a buffered reader.
            line = bytearray()
            while not line.endswith(b"\n") and len(line) < 4096:
                data = conn.recv(1)
                if not data:
                    raise ValueError("incomplete request")
                line.extend(data)
            request = json.loads(line)
            command = request.get("command")
            if command == "register":
                if peer_uid(conn) != self.uid or self.runner:
                    raise PermissionError("runner already registered or wrong user")
                self.runner_permissions = request.get("accessibility") is True
                packet(conn, {"registered": True})
                self.runner = conn
                self.runner_buffer = b""
                self.runner_seen = time.monotonic()
                conn.settimeout(None)
                self.selector.register(conn, selectors.EVENT_READ, "runner")
                conn = None
                self.start()
                return
            if command == "disable":
                self.fail("disabled explicitly")
            elif command == "enable":
                if not self.runner:
                    packet(conn, {"error": "action runner is not connected", **self.status()})
                    return
                if not driver_active():
                    packet(conn, {"error": "approve Karabiner 6.2.0 in System Settings > Privacy & Security", **self.status()})
                    return
                if not self.runner_permissions:
                    packet(conn, {"error": "grant Accessibility to the keyboard action helper, then restart the runner", **self.status()})
                    return
                self.state.enable()
                self.start()
            elif command == "permissions":
                if self.runner:
                    packet(self.runner, {"permissions_prompt": True})
            elif command != "status":
                raise ValueError("unknown command")
            packet(conn, self.status())
        except (OSError, ValueError) as error:
            try:
                packet(conn, {"error": str(error)})
            except OSError:
                pass
        finally:
            if conn:
                conn.close()

    def drop_runner(self):
        if self.runner:
            self.selector.unregister(self.runner)
            self.runner.close()
            self.runner = None
        if os.stat("/dev/console").st_uid == self.uid:
            self.fail("action runner disconnected")
        else:
            self.stop_engine()

    def runner_read(self):
        try:
            data = self.runner.recv(4096)
        except OSError:
            data = b""
        if not data:
            self.drop_runner()
            return
        self.runner_buffer += data
        while b"\n" in self.runner_buffer:
            line, self.runner_buffer = self.runner_buffer.split(b"\n", 1)
            try:
                message = json.loads(line)
            except ValueError:
                self.drop_runner()
                return
            if message.get("failure"):
                self.fail("action runner: " + str(message["failure"])[:200])
            if "accessibility" in message:
                self.runner_permissions = message["accessibility"] is True
            self.runner_seen = time.monotonic()
            self.pending_since = None

    def engine_read(self):
        try:
            data = self.tcp.recv(16384)
        except OSError:
            data = b""
        if not data:
            self.fail("engine notification stream closed")
            return
        self.buffer += data
        if len(self.buffer) > 65536:
            self.fail("invalid engine notification stream")
            return
        while b"\n" in self.buffer:
            line, self.buffer = self.buffer.split(b"\n", 1)
            message = json.loads(line)
            if self.runner:
                try:
                    packet(self.runner, {"event": message})
                except OSError:
                    self.drop_runner()
                    return
                if self.pending_since is None:
                    self.pending_since = time.monotonic()

    def run(self):
        path = Path(self.args.socket)
        path.unlink(missing_ok=True)
        server = socket.socket(socket.AF_UNIX)
        server.bind(str(path))
        os.chown(path, self.uid, pwd.getpwnam(self.args.user).pw_gid)
        os.chmod(path, 0o600)
        server.listen(8)
        self.selector.register(server, selectors.EVENT_READ, "server")
        self.runner_buffer = b""
        signal.signal(signal.SIGTERM, lambda *_: setattr(self, "stopping", True))
        signal.signal(signal.SIGINT, lambda *_: setattr(self, "stopping", True))
        try:
            while not self.stopping:
                for key, _ in self.selector.select(0.1):
                    if key.data == "server":
                        self.accept(server)
                    elif key.data == "runner":
                        self.runner_read()
                    elif key.data == "engine" and self.tcp:
                        self.engine_read()
                if self.engine and self.engine.poll() is not None:
                    self.fail(f"engine exited (status {self.engine.returncode}; emergency exit also returns 0)")
                if self.engine and not self.tcp:
                    try:
                        self.tcp = socket.create_connection(("127.0.0.1", self.port), timeout=0.1)
                        self.tcp.settimeout(1)
                        self.selector.register(self.tcp, selectors.EVENT_READ, "engine")
                    except OSError:
                        self.tcp = None
                        if time.monotonic() - self.starting > 8:
                            self.fail("engine did not become ready")
                if self.runner and time.monotonic() - self.last_ping > 1:
                    try:
                        packet(self.runner, {"ping": True})
                    except OSError:
                        self.drop_runner()
                    self.last_ping = time.monotonic()
                if self.engine and (time.monotonic() - self.runner_seen > 4 or
                                    (self.pending_since and time.monotonic() - self.pending_since > 4)):
                    self.fail("action runner stopped acknowledging messages")
        except BaseException:
            self.fail("supervisor failure")
            raise
        finally:
            self.stop_engine()
            server.close()
            path.unlink(missing_ok=True)


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("command", choices=["status", "enable", "disable", "permissions", "supervise", "notify"])
    parser.add_argument("--socket", default=SOCKET)
    parser.add_argument("--state", default=STATE)
    parser.add_argument("--user", default="nick")
    parser.add_argument("--engine")
    parser.add_argument("--config")
    args = parser.parse_args()
    if args.command == "notify":
        account = pwd.getpwnam(args.user)
        os.initgroups(args.user, account.pw_gid)
        os.setgid(account.pw_gid)
        os.setuid(account.pw_uid)
        os.execv("/usr/bin/osascript", ["osascript", "-e", 'display notification "Ordinary typing restored. Run keyboard status for details; keyboard enable explicitly resumes layers." with title "Keyboard layers disabled"'])
    if args.command == "supervise":
        Supervisor(args).run()
    else:
        try:
            if args.command == "enable":
                # Supervisor crashes keep their active journal. Its next startup
                # latches disabled before accepting this explicit enable request.
                try:
                    rpc("status", args.socket)
                except (OSError, ValueError):
                    subprocess.run(["/usr/bin/osascript", "-e", 'do shell script "/bin/launchctl kickstart -k system/org.nick.keyboard" with administrator privileges'], check=True)
                status = rpc("status", args.socket)
                if not status.get("runner"):
                    subprocess.run(["/bin/launchctl", "kickstart", f"gui/{os.getuid()}/org.nick.keyboard-actions"], check=True)
                    deadline = time.monotonic() + 5
                    while time.monotonic() < deadline:
                        status = rpc("status", args.socket)
                        if status.get("runner"):
                            break
                        time.sleep(.1)
            result = rpc(args.command, args.socket)
            if args.command == "enable" and not result.get("error"):
                deadline = time.monotonic() + 10
                while result["state"] == "starting" and time.monotonic() < deadline:
                    time.sleep(.1)
                    result = rpc("status", args.socket)
                if result["state"] != "running":
                    result["error"] = "engine did not reach running state; inspect disabled reason"
            print(json.dumps(result, indent=2))
            return 1 if result.get("error") else 0
        except (OSError, ValueError) as error:
            print(f"keyboard supervisor unavailable: {error}", file=sys.stderr)
            return 1
    return 0


if __name__ == "__main__":
    sys.exit(main())
