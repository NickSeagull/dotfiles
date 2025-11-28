#!/bin/bash

# Sync VS Code settings to code-server
# Usage: ./sync-vscode-settings.sh [--extensions]

VSCODE_DIR="$HOME/Library/Application Support/Code/User"
CODE_SERVER_DIR="$HOME/.local/share/code-server/User"

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo "========================================"
echo "  VS Code → code-server Settings Sync"
echo "========================================"
echo

# Check if VS Code settings exist
if [ ! -d "$VSCODE_DIR" ]; then
    echo -e "${RED}Error: VS Code settings not found at${NC}"
    echo "$VSCODE_DIR"
    exit 1
fi

# Create code-server directory if needed
mkdir -p "$CODE_SERVER_DIR"

# Sync settings.json
if [ -f "$VSCODE_DIR/settings.json" ]; then
    cp "$VSCODE_DIR/settings.json" "$CODE_SERVER_DIR/settings.json"
    echo -e "${GREEN}✓${NC} settings.json"
else
    echo -e "${YELLOW}⚠${NC} settings.json not found, skipping"
fi

# Sync keybindings.json
if [ -f "$VSCODE_DIR/keybindings.json" ]; then
    cp "$VSCODE_DIR/keybindings.json" "$CODE_SERVER_DIR/keybindings.json"
    echo -e "${GREEN}✓${NC} keybindings.json"
else
    echo -e "${YELLOW}⚠${NC} keybindings.json not found, skipping"
fi

# Sync snippets
if [ -d "$VSCODE_DIR/snippets" ]; then
    cp -r "$VSCODE_DIR/snippets" "$CODE_SERVER_DIR/"
    echo -e "${GREEN}✓${NC} snippets/"
else
    echo -e "${YELLOW}⚠${NC} snippets/ not found, skipping"
fi

# Sync extensions if --extensions flag is passed
if [ "$1" = "--extensions" ]; then
    echo
    echo "Installing extensions..."
    echo

    # Get list of VS Code extensions
    extensions=$(code --list-extensions 2>/dev/null)

    if [ -z "$extensions" ]; then
        echo -e "${RED}Error: Could not list VS Code extensions${NC}"
        echo "Make sure 'code' command is available in PATH"
    else
        total=$(echo "$extensions" | wc -l | tr -d ' ')
        current=0

        echo "$extensions" | while read -r ext; do
            current=$((current + 1))
            echo -n "[$current/$total] $ext ... "

            if code-server --install-extension "$ext" &>/dev/null; then
                echo -e "${GREEN}installed${NC}"
            else
                echo -e "${YELLOW}skipped${NC}"
            fi
        done
    fi
fi

echo
echo "========================================"
echo -e "${GREEN}Sync complete!${NC}"
echo "========================================"
echo
echo "Restart code-server to apply changes:"
echo "  brew services restart code-server"
echo
echo "To also sync extensions, run:"
echo "  $0 --extensions"
