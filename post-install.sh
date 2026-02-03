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

# ==========================================
# Fonts (Apple + Google Sans Flex)
# Source: HyprKenso/fonts/*
# Target: ~/.local/share/fonts/HyprKenso
# ==========================================

echo "🔤 Installing fonts..."

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FONT_SRC="$SCRIPT_DIR/fonts"
FONT_DST="$HOME/.local/share/fonts/HyprKenso"

if [[ ! -d "$FONT_SRC" ]]; then
  echo "⚠ fonts directory not found, skipping fonts"
else
  mkdir -p "$FONT_DST"

  rsync -a \
    --exclude='.git*' \
    --exclude='README*' \
    "$FONT_SRC/" \
    "$FONT_DST/"
fi

echo "🔄 Refreshing font cache..."
fc-cache -fv >/dev/null

echo "✔ Fonts installed"

fc-list | grep -i "Google Sans"
fc-list | grep -i "SF Pro"
