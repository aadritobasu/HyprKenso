#!/usr/bin/env bash

# ==========================================
# Kenso Minimal Installer
# ==========================================

set -euo pipefail

# -----------------------------
# Paths
# -----------------------------
BASE_DIR="$HOME/hyprkenso"
BACKUP_DIR="$HOME/.config_backup_$(date +%Y%m%d%H%M)"

# Required packages (minimal)
PACKAGES=(
  7zip
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
)

# Dotfiles repos
REPOS=(
  "https://github.com/aadritobasu/kenso-matugen"
  "https://github.com/aadritobasu/kenso-hypr"
  "https://github.com/aadritobasu/kenso-nvim"
  "https://github.com/aadritobasu/kenso-rofi"
  "https://github.com/aadritobasu/kenso-quickshell"
  "https://github.com/aadritobasu/kenso-swaync"
  "https://github.com/aadritobasu/kenso-waybar"
  "https://github.com/aadritobasu/kenso-icon-themes"
  "https://github.com/aadritobasu/kenso-spicetify"
  "https://github.com/aadritobasu/kenso-wlogout"
  "https://github.com/aadritobasu/wallpapers"
  "https://github.com/aadritobasu/kenso-fastfetch-config"
)

# -----------------------------
# Ensure yay exists
# -----------------------------
if ! command -v yay &>/dev/null; then
  echo "❌ yay not found. Install yay first!"
  exit 1
fi

# -----------------------------
# 1️⃣ Install minimal packages
# -----------------------------
echo "📦 Installing required packages..."
yay -Syu --noconfirm

for pkg in "${PACKAGES[@]}"; do
  if yay -Q "$pkg" &>/dev/null; then
    echo "✔ $pkg already installed"
  else
    echo "📦 Installing $pkg..."
    yay -S --noconfirm --needed "$pkg"
  fi
done

FONT_DIR="$HOME/.local/share/fonts"
mkdir -p "$FONT_DIR"

echo "Installing Google Sans Flex..."

curl -L \
  https://github.com/google/fonts/raw/main/ofl/googlesansflex/GoogleSansFlex%5Bwght%5D.ttf \
  -o "$FONT_DIR/GoogleSansFlex[wght].ttf"

fc-cache -fv

FONT_DIR="$HOME/.local/share/fonts"
mkdir -p "$FONT_DIR"

echo "Installing SF Pro fonts..."

tmpdir=$(mktemp -d)
cd "$tmpdir" || exit 1

# Download from Apple
curl -L -o SF-Pro.dmg \
  https://devimages-cdn.apple.com/design/resources/download/SF-Pro.dmg

# Extract DMG
7z x SF-Pro.dmg >/dev/null

# Extract PKG
7z x *.pkg >/dev/null

# Extract payload
7z x Payload~ >/dev/null

# Move fonts
find . -type f \( -name "*.otf" -o -name "*.ttf" \) -exec mv {} "$FONT_DIR" \;

# Cleanup
rm -rf "$tmpdir"

# Refresh cache
fc-cache -fv

# -----------------------------
# 2️⃣ Clone dotfiles into ~/hyprkenso
# -----------------------------
echo "📥 Cloning dotfiles..."
mkdir -p "$BASE_DIR"

for repo in "${REPOS[@]}"; do
  name="$(basename "$repo")"
  target="$BASE_DIR/$name"

  if [[ -d "$target/.git" ]]; then
    echo "🔄 Updating $name"
    git -C "$target" pull
  else
    echo "📥 Cloning $name"
    git clone "$repo" "$target"
  fi
done

# -----------------------------
# 3️⃣ Backup and copy configs
# -----------------------------
echo "🗄 Backing up existing configs..."
mkdir -p "$BACKUP_DIR"

backup_and_copy() {
  local src="$1"
  local dest="$2"
  if [[ -d "$dest" ]]; then
    mv "$dest" "$BACKUP_DIR/"
  fi
  mkdir -p "$(dirname "$dest")"
  cp -r "$src" "$dest"
  echo "→ Copied $(basename "$src") → $dest"
}

echo "📂 Copying dotfiles to ~/.config..."
backup_and_copy "$BASE_DIR/kenso-hypr"        "$HOME/.config/hypr"
backup_and_copy "$BASE_DIR/kenso-nvim"        "$HOME/.config/nvim"
backup_and_copy "$BASE_DIR/kenso-rofi"        "$HOME/.config/rofi"
backup_and_copy "$BASE_DIR/kenso-waybar"      "$HOME/.config/waybar"
backup_and_copy "$BASE_DIR/kenso-swaync"      "$HOME/.config/swaync"
backup_and_copy "$BASE_DIR/kenso-wlogout"     "$HOME/.config/wlogout"
backup_and_copy "$BASE_DIR/kenso-quickshell"  "$HOME/.config/quickshell"
backup_and_copy "$BASE_DIR/kenso-spicetify"	  "$HOME/.config/spicetify"
backup_and_copy "$BASE_DIR/kenso-matugen"     "$HOME/.config"

# Wallpapers
mkdir -p "$HOME/Pictures"
backup_and_copy "$BASE_DIR/wallpapers" "$HOME/Pictures/wallpapers"

# -----------------------------
# 4️⃣ Copy icon themes
# -----------------------------
echo "🎨 Copying icon themes..."
mkdir -p "$HOME/.local/share/icons"
cp -r "$BASE_DIR/kenso-icon-themes"/* "$HOME/.local/share/icons/"
echo "✔ Icons copied to ~/.local/share/icons"

# -----------------------------
# 5️⃣ Install fastfetch
# -----------------------------
echo "⚡ Installing fastfetch..."
cd "$BASE_DIR/kenso-fastfetch-config"
chmod +x install.sh
./install.sh
cd "$HOME"

# -----------------------------
# 6️⃣ Enable/start MPD
# -----------------------------
echo "🎵 Enabling and starting MPD..."
sudo systemctl enable --now mpd.service
echo "🎵 Enabling and starting pipewire and disabling pulseaudio..."
systemctl --user --now disable pulseaudio.service pulseaudio.socket
systemctl --user --now enable pipewire pipewire-pulse
echo "🎉 Kenso minimal setup complete!"
echo "📁 Dotfiles cloned to $BASE_DIR"
echo "🗄 Backup of old configs at $BACKUP_DIR"

# -----------------------------
# 7️⃣ Install Powerlevel10k
# -----------------------------
echo "🌟 Installing Powerlevel10k..."

# Zsh config directory
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

# Ensure Oh My Zsh exists
if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
    echo "❌ Oh My Zsh not found. Installing..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# Clone Powerlevel10k if missing
if [[ ! -d "$ZSH_CUSTOM/themes/powerlevel10k" ]]; then
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$ZSH_CUSTOM/themes/powerlevel10k"
    echo "✔ Powerlevel10k cloned"
else
    echo "✔ Powerlevel10k already installed"
fi

# Ensure ZSH_THEME is set in .zshrc
if ! grep -q 'ZSH_THEME="powerlevel10k/powerlevel10k"' "$HOME/.zshrc"; then
    sed -i 's/^ZSH_THEME=.*/ZSH_THEME="powerlevel10k\/powerlevel10k"/' "$HOME/.zshrc"
    echo "✔ ZSH_THEME set to Powerlevel10k in .zshrc"
fi

echo "✅ Powerlevel10k installation complete!"
# -----------------------------
# 🐚 ZSH setup (copy from ~/.config/zsh)
# -----------------------------
echo "🐚 Setting up ZSH configuration..."

ZSH_SRC="$HOME/.config/zsh"

if [[ -d "$ZSH_SRC" ]]; then
  echo "📁 Copying ZSH config files to home..."

  # Copy standard zsh dotfiles (.zshrc, .zprofile, etc.)
  cp -rf "$ZSH_SRC"/.* "$HOME/" 2>/dev/null || true

  # Copy Powerlevel10k config explicitly
  if [[ -f "$ZSH_SRC/.p10k.zsh" ]]; then
    cp -f "$ZSH_SRC/.p10k.zsh" "$HOME/.p10k.zsh"
  fi

  # Copy zcompdump files if present
  if ls "$ZSH_SRC"/.zcompdump* &>/dev/null; then
    cp -f "$ZSH_SRC"/.zcompdump* "$HOME/"
    echo "✔ zcompdump files copied"
  fi

  echo "✔ ZSH configs copied"
else
  echo "⚠ ~/.config/zsh not found, skipping ZSH config copy"
fi


# -----------------------------
# 8️⃣ Change default shell to zsh
# -----------------------------
echo "🌀 Changing default shell to zsh..."

# Check current shell
CURRENT_SHELL=$(getent passwd $USER | cut -d: -f7)

if [[ "$CURRENT_SHELL" != "$(which zsh)" ]]; then
    echo "🔄 Changing shell from $CURRENT_SHELL to $(which zsh)"
    chsh -s "$(which zsh)"
    echo "✔ Default shell changed to zsh"
else
    echo "✔ Default shell is already zsh"
fi
# -----------------------------
# Force downgrade Hyprland to 0.52.2
# -----------------------------
echo "⬇ Forcing Hyprland downgrade to 0.52.2"

# Ensure downgrade tool exists
if ! command -v downgrade &>/dev/null; then
  echo "📦 Installing downgrade tool..."
  yay -S --noconfirm downgrade
fi

# Downgrade Hyprland non-interactively
sudo downgrade hyprland --version 0.52.2 --yes

# Lock Hyprland to prevent upgrades
PACMAN_CONF="/etc/pacman.conf"
if ! grep -q "^IgnorePkg.*hyprland" "$PACMAN_CONF"; then
  echo "🔒 Locking Hyprland version in pacman.conf"
  sudo sed -i '/^\[options\]/a IgnorePkg = hyprland' "$PACMAN_CONF"
fi

echo "✔ Hyprland locked at 0.52.2"
# -----------------------------
# 🔧 Fix hypr-lens paths (username-safe)
# -----------------------------
echo "🛠 Fixing hypr-lens config paths..."

HYPR_LENS_CFG="$HOME/.config/hypr-lens/config.json"
USER_HOME="/home/$USER"

if [[ -f "$HYPR_LENS_CFG" ]]; then
  # Ensure jq exists
  if ! command -v jq &>/dev/null; then
    echo "📦 Installing jq..."
    yay -S --noconfirm jq
  fi

  tmpfile="$(mktemp)"

  jq \
    --arg home "$USER_HOME" \
    '
    .appearance.matugenPath = ($home + "/.config/quickshell/matugen.json")
    | .screenSnip.savePath = ($home + "/Pictures/ScreenShots")
    ' \
    "$HYPR_LENS_CFG" > "$tmpfile"

  mv "$tmpfile" "$HYPR_LENS_CFG"

  echo "✔ hypr-lens paths updated for user: $USER"
else
  echo "⚠ hypr-lens config.json not found, skipping"
fi
echo "Checking display manager..."

if pacman -Q gdm &>/dev/null || pacman -Q lightdm &>/dev/null; then
    echo "GDM or LightDM detected — leaving display manager untouched."
else
    echo "No GDM or LightDM detected — enabling SDDM..."
    sudo systemctl enable sddm
fi
