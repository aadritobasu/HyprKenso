#!/usr/bin/env bash

# ==========================================
# Kenso Post-Install Cleanup + Font Install
# ==========================================

set -euo pipefail

# -----------------------------
# Paths to clean
# -----------------------------
CLEAN_TARGETS=(
  "$HOME/.config"
  "$HOME/Pictures/wallpapers"
  "$HOME/.local/share/icons"
)

# -----------------------------
# Google Sans Flex
# -----------------------------
FONT_FILE="GoogleSansFlex-VariableFont_GRAD,ROND,opsz,slnt,wdth,wght.ttf"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FONT_SRC="$SCRIPT_DIR/$FONT_FILE"
FONT_DIR="$HOME/.local/share/fonts/GoogleSansFlex"

# ==================================================
# 1️⃣ Remove stray .git directories
# ==================================================
echo "🧹 Cleaning stray .git directories..."

for dir in "${CLEAN_TARGETS[@]}"; do
  if [[ ! -d "$dir" ]]; then
    echo "⚠ Skipping missing directory: $dir"
    continue
  fi

  echo "🔍 Scanning: $dir"
  find "$dir" -type d -name ".git" 2>/dev/null | while read -r gitdir; do
    echo "🗑 Removing: $gitdir"
    rm -rf "$gitdir"
  done
done

echo "✔ Git cleanup complete"

# ==================================================
# 2️⃣ Install Google Sans Flex font
# ==================================================
echo "🔤 Installing Google Sans Flex..."

if [[ ! -f "$FONT_SRC" ]]; then
  echo "⚠ Font file not found, skipping:"
  echo "   $FONT_SRC"
else
  mkdir -p "$FONT_DIR"
  cp -f "$FONT_SRC" "$FONT_DIR/"

  echo "🔄 Updating font cache..."
  fc-cache -fv >/dev/null

  if fc-list | grep -qi "Google Sans"; then
    echo "✔ Google Sans Flex installed successfully"
  else
    echo "⚠ Font copied but not detected yet (logout/reboot may be needed)"
  fi
fi

echo "✅ Post-install tasks complete"
