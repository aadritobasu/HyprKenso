#!/usr/bin/env bash

# ==========================================
# Kenso Installer (FINAL CLEAN VERSION)
# ==========================================

set -euo pipefail

# -----------------------------
# Paths
# -----------------------------
BASE_DIR="$HOME/hyprkenso"
CONFIG_DIR="$HOME/.config"
BACKUP_DIR="$HOME/.config_backup_$(date +%Y%m%d%H%M)"

# -----------------------------
# Required packages (minimal)
# -----------------------------
PACKAGES=(
  tar
  7zip
  unzip
  ripgrep
  fd
  nodejs
  luarocks
  base-devel
  hererocks
  lua
  satty
  tree-sitter-cli
  lazygit
  npm
  rsync
  file-roller
  downgrade
  sddm
  qt5-3d
  qt5-base
  qt5-declarative
  qt5-gamepad
  qt5-graphicaleffects
  qt5-imageformats
  qt5-location
  qt5-multimedia
  qt5-networkauth
  qt5-quickcontrols
  qt5-quickcontrols2
  qt5-script
  qt5-sensors
  qt5-serialport
  qt5-speech
  qt5-svg
  qt5-tools
  qt5-translations
  qt5-virtualkeyboard
  qt5-wayland
  qt5-x11extras
  qt5-xmlpatterns
  qt5ct-kde
  qt6-5compat
  qt6-base
  qt6-declarative
  qt6-imageformats
  qt6-multimedia
  qt6-multimedia-ffmpeg
  qt6-networkauth
  qt6-positioning
  qt6-scxml
  qt6-shadertools
  qt6-speech
  qt6-svg
  qt6-tools
  qt6-translations
  qt6-virtualkeyboard
  qt6-wayland
  qt6-webchannel
  qt6-webengine
  qt6ct-kde
  gtk-doc
  gtk-layer-shell
  gtk-update-icon-cache
  gtk-vnc
  gtk3
  gtk4
  gtk4-layer-shell
  hyprland
  waybar
  rofi
  rofi-emoji
  btop
  neovim
  swaync
  python
  matugen
  wlogout
  swww
  swayosd
  polkit-gnome
  wl-clipboard
  wl-clip-persist
  swappy
  tmux
  thunar
  brave-bin
  zsh
  zsh-autosuggestions
  zsh-history-substring-search
  zsh-syntax-highlighting
  cava
  kitty
  yazi
  fastfetch
  rmpc-git
  quickshell-git
  mpd
  mpd-mpris
  playerctl
  brightnessctl
  visual-studio-code-insiders-bin
  nwg-look
  nwg-displays
  loupe
  feh
  mpv
  mpc
  papirus-folders
  pipewire
  pipewire-alsa
  pipewire-pulse
  pipewire-audio
  nm-connection-editor
  networkmanager
  man-db
  reflector
  jack2
  otf-font-awesome
  otf-space-grotesk
  ttf-jetbrains-mono-nerd
  ttf-material-symbols-variable-git
  ttf-readex-pro
  ttf-rubik-vf
  ttf-twemoji
  starship
  fontconfig
  adw-gtk-theme-git
  hyprlock
  hypridle
  grim
  slurp
  jq
  libnotify
  imagemagick
  tesseract
  tesseract-data-eng
  wf-recorder
  hyprpicker
  opencv
  python-opencv
  colloid-icon-theme-git
  noto-fonts-cjk
  zsh-theme-powerlevel10k-git
  fzf
  fzf-tab-git
  eza
  bat
)

# -----------------------------
# Repos
# -----------------------------
DOTS_REPO="https://github.com/aadritobasu/kenso-dots"
ICONS_REPO="https://github.com/aadritobasu/kenso-icon-themes"
FASTFETCH_REPO="https://github.com/aadritobasu/kenso-fastfetch-config"
WALLS_REPO="https://github.com/aadritobasu/wallpapers"

# -----------------------------
# Ensure yay exists
# -----------------------------
if ! command -v yay &>/dev/null; then
  echo "❌ yay not found. Install yay first."
  exit 1
fi

# -----------------------------
# Install packages
# -----------------------------
echo "📦 Installing packages..."
yay -Syu --noconfirm
yay -S --needed --noconfirm "${PACKAGES[@]}"

# -----------------------------
# Clone repos
# -----------------------------
echo "📥 Cloning repositories..."
mkdir -p "$BASE_DIR"

clone_or_update() {
  local repo="$1"
  local dest="$2"

  if [[ -d "$dest/.git" ]]; then
    git -C "$dest" pull
  else
    git clone "$repo" "$dest"
  fi
}

clone_or_update "$DOTS_REPO"      "$BASE_DIR/kenso-dots"
clone_or_update "$ICONS_REPO"     "$BASE_DIR/kenso-icon-themes"
clone_or_update "$FASTFETCH_REPO" "$BASE_DIR/kenso-fastfetch"
clone_or_update "$WALLS_REPO"     "$BASE_DIR/wallpapers"

# -----------------------------
# Backup ~/.config ONCE
# -----------------------------
echo "🗄 Backing up ~/.config → $BACKUP_DIR"
if [[ -d "$CONFIG_DIR" ]]; then
  cp -a "$CONFIG_DIR" "$BACKUP_DIR"
fi

# -----------------------------
# Copy dotfiles → ~/.config (NO .git)
# -----------------------------
echo "📂 Copying kenso-dots into ~/.config"

rsync -a \
  --exclude='.git' \
  --exclude='.gitignore' \
  "$BASE_DIR/kenso-dots"/ \
  "$CONFIG_DIR"/

# -----------------------------
# Wallpapers
# -----------------------------
echo "🖼 Installing wallpapers..."
mkdir -p "$HOME/Pictures"
rsync -a "$BASE_DIR/wallpapers"/ "$HOME/Pictures/wallpapers/"

# -----------------------------
# Icon themes
# -----------------------------
echo "🎨 Installing icon themes..."
mkdir -p "$HOME/.local/share/icons"
rsync -a "$BASE_DIR/kenso-icon-themes"/ "$HOME/.local/share/icons/"

# -----------------------------
# Fastfetch
# -----------------------------
echo "⚡ Installing fastfetch config..."
cd "$BASE_DIR/kenso-fastfetch"
chmod +x install.sh
./install.sh
cd "$HOME"

# -----------------------------
# ZSH config copy
# -----------------------------
echo "🐚 Copying ZSH configs..."

ZSH_SRC="$CONFIG_DIR/zsh"

if [[ -d "$ZSH_SRC" ]]; then
  rsync -a "$ZSH_SRC"/ "$HOME/"
fi


# -----------------------------
# Change default shell
# -----------------------------
if [[ "$(getent passwd "$USER" | cut -d: -f7)" != "$(which zsh)" ]]; then
  chsh -s "$(which zsh)"
fi

# -----------------------------
# Enable services
# -----------------------------
echo "🎵 Enabling services..."
sudo systemctl enable --now mpd
systemctl --user enable --now pipewire pipewire-pulse

# -----------------------------
# Fix hypr-lens paths
# -----------------------------
echo "🛠 Fixing hypr-lens paths..."

CFG="$CONFIG_DIR/hypr-lens/config.json"

if [[ -f "$CFG" ]]; then
  tmp="$(mktemp)"
  jq --arg home "$HOME" '
    .appearance.matugenPath = ($home + "/.config/quickshell/matugen.json")
    | .screenSnip.savePath = ($home + "/Pictures/ScreenShots")
  ' "$CFG" > "$tmp"
  mv "$tmp" "$CFG"
fi



QS_MUSIC="$HOME/.config/quickshell/music/MusicPanel.qml"

if [[ -f "$QS_MUSIC" ]]; then
    echo "Fixing matugen path in MusicPanel.qml..."

    sed -i "s|/home/[^/]*/.config/quickshell/matugen.json|$HOME/.config/quickshell/matugen.json|g" "$QS_MUSIC"

    echo "✔ Path updated"
else
    echo "⚠ MusicPanel.qml not found, skipping..."
fi

# -----------------------------
# Display manager
# -----------------------------
if ! pacman -Q gdm &>/dev/null && ! pacman -Q lightdm &>/dev/null; then
  sudo systemctl enable sddm
fi

# ==========================================
# 🚀 Run post-install script
# ==========================================

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
POST_INSTALL="$SCRIPT_DIR/post-install.sh"

if [[ -f "$POST_INSTALL" ]]; then
  echo "🔧 Running post-install script..."
  chmod +x "$POST_INSTALL"
  "$POST_INSTALL"
  echo "✔ Post-install completed"
else
  echo "⚠ post-install.sh not found, skipping"
fi



echo "✅ Kenso installation COMPLETE"
echo "🔁 Backup: $BACKUP_DIR"
echo "➡️  Reboot recommended"
