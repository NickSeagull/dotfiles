"""Set the Nix-owned Codex theme without replacing Codex's mutable settings."""

import os
from pathlib import Path
import sys
import tempfile

import tomlkit


def set_theme(path: Path, theme: str) -> None:
    original = path.read_text() if path.exists() else ""
    settings = tomlkit.parse(original)
    if "tui" not in settings:
        settings["tui"] = tomlkit.table()
    settings["tui"]["theme"] = theme
    updated = tomlkit.dumps(settings)
    if updated == original:
        return

    path.parent.mkdir(parents=True, exist_ok=True)
    with tempfile.NamedTemporaryFile(mode="w", dir=path.parent, delete=False) as tmp:
        temporary = Path(tmp.name)
        try:
            tmp.write(updated)
            tmp.flush()
            if (path.read_text() if path.exists() else "") != original:
                raise RuntimeError("Codex config changed during activation; retry the rebuild")
            os.replace(temporary, path)
        finally:
            temporary.unlink(missing_ok=True)


if __name__ == "__main__":
    set_theme(Path(sys.argv[1]), sys.argv[2])
