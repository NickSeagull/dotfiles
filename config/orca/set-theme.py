"""Reconcile Orca appearance without replacing sessions or credentials."""

import argparse
import hashlib
import json
import os
from pathlib import Path
import sqlite3
import subprocess
import sys
import tempfile
import time


class OrcaRunningError(RuntimeError):
    pass


def require_stopped():
    result = subprocess.run(
        ["/usr/bin/pgrep", "-f", "/Orca.app/Contents/MacOS/"],
        capture_output=True,
        check=False,
    )
    if result.returncode == 0:
        raise OrcaRunningError("Orca must be closed before changing its saved appearance")
    if result.returncode != 1:
        raise RuntimeError("Could not determine whether Orca is running")


def update_json(path, preferences):
    original = path.read_text() if path.exists() else "{}"
    state = json.loads(original)
    settings = state.setdefault("settings", {})
    if all(settings.get(key) == value for key, value in preferences.items()):
        return
    require_stopped()
    settings.update(preferences)
    path.parent.mkdir(parents=True, exist_ok=True)
    temporary = None
    try:
        with tempfile.NamedTemporaryFile(mode="w", dir=path.parent, delete=False) as handle:
            temporary = Path(handle.name)
            json.dump(state, handle, indent=2)
            handle.write("\n")
        if (path.read_text() if path.exists() else "{}") != original:
            raise RuntimeError("Orca state changed during activation; retry")
        os.replace(temporary, path)
    finally:
        if temporary:
            temporary.unlink(missing_ok=True)


def update_database(path, preferences):
    # Match Orca's schema-3 settings-domain write, including hashes/revisions.
    # Refuse future schemas rather than guessing how to migrate application state.
    with sqlite3.connect(f"file:{path}?mode=rw", uri=True) as database:
        if database.execute("PRAGMA user_version").fetchone()[0] != 3:
            raise RuntimeError(f"Unsupported Orca state schema: {path}")
        row = database.execute(
            "SELECT payload, content_hash FROM profile_state_documents WHERE domain = 'settings'"
        ).fetchone()
        if row is None or hashlib.sha256(row[0].encode()).hexdigest() != row[1]:
            raise RuntimeError(f"Invalid Orca settings domain: {path}")
        settings = json.loads(row[0])
        if all(settings.get(key) == value for key, value in preferences.items()):
            return
        require_stopped()
        # Preserve a local recovery copy, including WAL contents, before changing settings.
        with tempfile.NamedTemporaryFile(
            prefix=path.name + ".before-nix-theme-", dir=path.parent, delete=False
        ) as recovery:
            recovery_path = recovery.name
        with sqlite3.connect(recovery_path) as backup:
            database.backup(backup)
        database.execute("BEGIN IMMEDIATE")
        current = database.execute(
            "SELECT payload FROM profile_state_documents WHERE domain = 'settings'"
        ).fetchone()[0]
        if current != row[0]:
            raise RuntimeError("Orca settings changed during activation; retry")
        require_stopped()
        settings.update(preferences)
        payload = json.dumps(settings, separators=(",", ":"), ensure_ascii=False)
        revision = int(database.execute(
            "SELECT value FROM profile_state_meta WHERE key = 'revision'"
        ).fetchone()[0]) + 1
        database.execute(
            "UPDATE profile_state_documents SET payload = ?, revision = ?, "
            "updated_at = ?, content_hash = ? WHERE domain = 'settings'",
            (payload, revision, int(time.time() * 1000), hashlib.sha256(payload.encode()).hexdigest()),
        )
        database.execute(
            "UPDATE profile_state_meta SET value = ? WHERE key = 'revision'", (str(revision),)
        )


def set_theme(root, preferences):
    profiles = list((root / "profiles").glob("*/orca-data.json"))
    databases = list((root / "profiles").glob("*/profile-state.db"))
    for path in databases:
        update_database(path, preferences)
    for path in profiles:
        if not (path.parent / "profile-state.db").exists():
            update_json(path, preferences)
    # Seed the legacy first-launch import only before profiles have been created.
    if not profiles and not databases:
        update_json(root / "orca-data.json", preferences)


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("root", type=Path)
    parser.add_argument("preferences", type=Path)
    parser.add_argument("--defer-if-running", action="store_true")
    args = parser.parse_args()
    try:
        set_theme(args.root, json.loads(args.preferences.read_text()))
    except OrcaRunningError:
        if not args.defer_if_running:
            raise
        print("Orca appearance deferred: app is open; close it before the next activation.", file=sys.stderr)
