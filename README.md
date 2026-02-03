<p align="center">
  <img src="assets/hyprkenso-logo.png" width="220" />
</p>

<p align="center">
  <em>Simplicity, made powerful — a clean Hyprland setup for Arch Linux</em>
</p>

<p align="center">
  Built with love ❤️ and designed to stay simple, readable, and powerful.
</p>

<p align="center">
  <a href="https://github.com/aadritobasu/HyprKenso">
    <img src="https://img.shields.io/github/stars/aadritobasu/HyprKenso?style=flat-square&color=ffd700&label=Stars" />
  </a>
  <img src="https://img.shields.io/badge/Hyprland-Rice-6b7280?style=flat-square" />
  <img src="https://img.shields.io/badge/Arch-Linux-1793d1?style=flat-square&logo=arch-linux&logoColor=white" />
  <img src="https://img.shields.io/badge/Wayland-Hyprland-111827?style=flat-square" />
  <img src="https://img.shields.io/badge/Material-You-22c55e?style=flat-square" />
  <img src="https://img.shields.io/badge/Beginner-Friendly-f97316?style=flat-square" />
</p>

<p align="center">
  <a href="#installation">Installation</a> •
  <a href="#screenshots">Screenshots</a> •
  <a href="#videos">Videos</a> •
  <a href="#credits">Credits</a>
</p>

---

## About

**HyprKenso** is a minimal yet powerful **Hyprland rice** for **Arch Linux**, focused on clarity, aesthetics, and real-world usability.

---

## Screenshots

<!-- Hero shots (large) -->
<p align="center">
  <img src="screenshots/desktop-1.png" width="90%" />
</p>
<p align="center">
  <img src="screenshots/desktop-2.png" width="90%" />
</p>
<p align="center">
  <img src="screenshots/desktop-3.png" width="90%" />
</p>
<p align="center">
  <img src="screenshots/desktop-4.png" width="90%" />
</p>

---

<!-- Gallery (small) -->
<p align="center">
  <img src="screenshots/desktop-5.png" width="45%" />
  <img src="screenshots/desktop-6.png" width="45%" />
</p>

<p align="center">
  <img src="screenshots/desktop-7.png" width="45%" />
  <img src="screenshots/desktop-8.png" width="45%" />
</p>

<p align="center">
  <img src="screenshots/desktop-9.png" width="45%" />
  <img src="screenshots/desktop-10.png" width="45%" />
</p>

<p align="center">
  <img src="screenshots/desktop-11.png" width="45%" />
  <img src="screenshots/desktop-12.png" width="45%" />
</p>

<p align="center">
  <img src="screenshots/desktop-13.png" width="45%" />
  <img src="screenshots/desktop-14.png" width="45%" />
</p>

<p align="center">
  <img src="screenshots/desktop-15.png" width="45%" />
  <img src="screenshots/desktop-16.png" width="45%" />
</p>

<p align="center">
  <img src="screenshots/desktop-17.png" width="45%" />
  <img src="screenshots/desktop-18.png" width="45%" />
</p>

<p align="center">
  <em>Minimal • Material You inspired • Workflow focused</em>
</p>

---

## Videos

Some things are better seen in motion.

You can find **HyprKenso video demos**, animations, and workflow showcases
on my Reddit profile:

👉 **https://www.reddit.com/user/SeaPhilosophy277/submitted/**

(New videos will be added as features and themes evolve.)

---

## Features

- 🪟 Hyprland (Wayland)
- 🎨 Material You colors via `matugen`
- 🧩 GTK: adw-gtk3
- 🖼️ Icons: Papirus
- 🔤 Fonts: Google Sans Flex + Apple Fonts
- 🎵 Music: mpd + rmpc
- ⚡ Clean, modular dotfiles
- 🧠 Beginner-friendly structure

---

## 📦 What’s Included

- Hyprland dotfiles
- GTK & system theming
- Workflow scripts
- One-shot installer (`installer.sh`)
- Wallpaper & theme automation

All dependencies and configs are handled **inside the installer** — no git submodules required.

---

## Requirements

- Arch Linux / Base Arch install
- git
- yay
- Chaotic-AUR enabled

---

## Installation

```bash
git clone https://github.com/aadritobasu/HyprKenso.git
cd HyprKenso
chmod +x installer.sh
./installer.sh
```

---

## Post-Install

```bash
sudo downgrade hyprland   # select 0.52.2
sudo downgrade nvim       # select 0.11.5
```

---

## 📌 Optional Apps

### Discord (BetterDiscord)

```bash
yay -S discord
curl -O https://raw.githubusercontent.com/BetterDiscord/Installer/main/install.sh
chmod +x install.sh
./install.sh
```

**Midnight theme**

```bash
mkdir -p ~/.config/BetterDiscord/themes
curl -L https://github.com/refact0r/midnight-discord/releases/latest/download/midnight.theme.css -o ~/.config/BetterDiscord/themes/midnight.theme.css
```

---

### Spotify + Spicetify

```bash
yay -S spotify
curl -fsSL https://raw.githubusercontent.com/spicetify/cli/main/install.sh | sh
```

```bash
spicetify backup enable dev-tools
spicetify config current_theme text
spicetify apply
```

---

## Credits

- Fastfetch config by **menhoudj**

---

## ❤️ Final Words

Enjoy ricing. Enjoy simplicity.

— Aadrito Basu
