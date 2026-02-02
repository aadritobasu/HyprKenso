#!/usr/bin/env bash
set -euo pipefail

# ==========================================
# Kenso Fresh Minimal Installer (Fixed)
# ==========================================

BASE_DIR="$HOME/hyprkenso"
CONFIG_DIR="$HOME/.config"
BACKUP_DIR="$HOME/.config_backup_$(date +%Y%m%d%H%M)"

# -----------------------------
# Required minimal packages
# -----------------------------
PACKAGES=(
  hyprland waybar rofi swaync wlogout
  neovim kitty thunar
  zsh zsh-autosuggestions zsh-syntax-highlighting
  mpd mpc playerctl
  pipewire pipewire-pulse
  wl-clipboard grim slurp jq
  matugen swww polkit-gnome
  quickshell-git
  fastfetch
  downgrade
)

# -----------------------------
# Dotfile repos
# -----------------------------
REPOS=(
  https://github.com/aadritobasu/kenso-matugen
  https://github.com/aadritobasu/kenso-hypr
  https://github.com/aadritobasu/kenso-nvim
  https://github.com/aadritobasu/kenso-rofi
  https://github.com/aadritobasu/kenso-quickshell
  https://github.com/aadritobasu/kenso-swaync
  https://github.com/aadritobasu/kenso-waybar
  https://github.com/aadritobasu/kenso-icon-themes
  https://github.com/aadritobasu/kenso-spicetify
  https://github.com/aadritobasu/kenso-wlogout
  https://github.com/aadritobasu/wallpapers
  https://github.com/aadritobasu/kenso-fastfetch-config
)

# -----------------------------
# Ensure yay
# -----------------------------
command -v yay >/dev/null || {
  echo "❌ yay not installed"
  exit 1
}

# -----------------------------
# Install packages
# -----------------------------
echo "📦 Installing packages..."
yay -Syu --noconfirm
yay -S --needed --noconfirm "${PACKAGES[@]}"

# -----------------------------
# Clone repos
# -----------------------------
echo "📥 Cloning dotfiles into $BASE_DIR"
mkdir -p "$BASE_DIR"

for repo in "${REPOS[@]}"; do
  name="$(basename "$repo")"
  target="$BASE_DIR/$name"

  [[ -d "$target/.git" ]] && git -C "$target" pull || git clone "$repo" "$target"
done

# -----------------------------
# Backup entire ~/.config ONCE
# -----------------------------
echo "🗄 Backing up ~/.config → $BACKUP_DIR"
if [[ -d "$CONFIG_DIR" ]]; then
  cp -a "$CONFIG_DIR" "$BACKUP_DIR"
fi

# -----------------------------
# Copy dotfiles (skip .git)
# -----------------------------
echo "📂 Copying configs..."

copy_cfg() {
  rsync -a --delete \
    --exclude='.git' \
    "$1"/ "$2"/
}

mkdir -p "$CONFIG_DIR"

copy_cfg "$BASE_DIR/kenso-hypr"        "$CONFIG_DIR/hypr"
copy_cfg "$BASE_DIR/kenso-nvim"        "$CONFIG_DIR/nvim"
copy_cfg "$BASE_DIR/kenso-rofi"        "$CONFIG_DIR/rofi"
copy_cfg "$BASE_DIR/kenso-waybar"      "$CONFIG_DIR/waybar"
copy_cfg "$BASE_DIR/kenso-swaync"      "$CONFIG_DIR/swaync"
copy_cfg "$BASE_DIR/kenso-wlogout"     "$CONFIG_DIR/wlogout"
copy_cfg "$BASE_DIR/kenso-quickshell"  "$CONFIG_DIR/quickshell"
copy_cfg "$BASE_DIR/kenso-spicetify"   "$CONFIG_DIR/spicetify"
copy_cfg "$BASE_DIR/kenso-matugen"     "$CONFIG_DIR"

# Wallpapers
mkdir -p "$HOME/Pictures"
copy_cfg "$BASE_DIR/wallpapers" "$HOME/Pictures/wallpapers"

# -----------------------------
# Icon themes
# -----------------------------
echo "🎨 Installing icon themes..."
mkdir -p "$HOME/.local/share/icons"
copy_cfg "$BASE_DIR/kenso-icon-themes" "$HOME/.local/share/icons"

# -----------------------------
# Fastfetch install (script only)
# -----------------------------
echo "⚡ Installing fastfetch config..."
cd "$BASE_DIR/kenso-fastfetch-config"
chmod +x install.sh
./install.sh
cd "$HOME"

# -----------------------------
# ZSH config copy (from ~/.config/zsh)
# -----------------------------
echo "🐚 Copying ZSH configs..."
ZSH_SRC="$CONFIG_DIR/zsh"

if [[ -d "$ZSH_SRC" ]]; then
  cp -f "$ZSH_SRC"/.zshrc "$HOME/" 2>/dev/null || true
  cp -f "$ZSH_SRC"/.p10k.zsh "$HOME/" 2>/dev/null || true
  cp -f "$ZSH_SRC"/.zcompdump* "$HOME/" 2>/dev/null || true
fi

# -----------------------------
# Powerlevel10k
# -----------------------------
echo "🌟 Installing Powerlevel10k..."
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

[[ -d "$HOME/.oh-my-zsh" ]] || \
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

[[ -d "$ZSH_CUSTOM/themes/powerlevel10k" ]] || \
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$ZSH_CUSTOM/themes/powerlevel10k"

sed -i 's/^ZSH_THEME=.*/ZSH_THEME="powerlevel10k\/powerlevel10k"/' "$HOME/.zshrc"

# -----------------------------
# Change shell
# -----------------------------
echo "🌀 Changing default shell to zsh..."
chsh -s "$(which zsh)"

# -----------------------------
# MPD + PipeWire
# -----------------------------
echo "🎵 Enabling MPD..."
sudo systemctl enable --now mpd.service
systemctl --user enable --now pipewire pipewire-pulse

# -----------------------------
# Force Hyprland downgrade
# -----------------------------
echo "⬇ Downgrading Hyprland → 0.52.2"
sudo downgrade hyprland --version 0.52.2 --yes

sudo sed -i '/^\[options\]/a IgnorePkg = hyprland' /etc/pacman.conf

# -----------------------------
# Fix hypr-lens paths
# -----------------------------
echo "🛠 Fixing hypr-lens paths..."
CFG="$CONFIG_DIR/hypr-lens/config.json"

if [[ -f "$CFG" ]]; then
  jq \
    --arg home "/home/$USER" \
    '
    .appearance.matugenPath = ($home + "/.config/quickshell/matugen.json")
    | .screenSnip.savePath = ($home + "/Pictures/ScreenShots")
    ' "$CFG" > "$CFG.tmp" && mv "$CFG.tmp" "$CFG"
fi

echo "✅ Kenso install complete"
echo "📁 Cloned at: $BASE_DIR"
echo "🗄 Config backup: $BACKUP_DIR"
