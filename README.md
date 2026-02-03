<h1 align="center">HyprKenso</h1>

<p align="center">
  <em>Simplicity, made powerful — a clean Hyprland setup for Arch Linux</em>
</p>

<p align="center">
  Built with love ❤️ and designed to stay simple, readable, and powerful.
</p>

---

<!-- Screenshots -->

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

## 🎥 Videos

Some things are better seen in motion.

You can find **HyprKenso video demos**, animations, and workflow showcases
on my Reddit profile:

👉 **https://www.reddit.com/user/SeaPhilosophy277/submitted/**

(New videos will be added as features and themes evolve.)




---

## ✨ About HyprKenso

HyprKenso is a **clean, aesthetic, and beginner-friendly Hyprland rice** built on Arch Linux.

This is my **first dream project**, shaped by real daily usage — every feature included is something I personally use, and every bug I hit has been fixed or removed.

The goal is simple:
- Easy to understand
- Easy to configure
- Powerful enough for daily driving

---

## 🎨 Theming

- **Wallpaper**: HyprKenso Wallpaper Collection
  *(Collected from Google, Wallhaven, Wallflare, and similar sources)*

- **Colors**: Material You (via `matugen`)
- **GTK Theme**: `adw-gtk3`
- **Icon Theme**: `Papirus`
  *(Different Papirus variants per theme)*

---

## 🔤 Fonts

- **Google Sans Flex**
- **Apple Fonts** (SF Pro / SF Mono)

Fonts are handled automatically by the installer.

---

## 🎵 Music

- **MPD**
- **rmpc**

Lightweight, keyboard-driven, and perfectly suited for a Hyprland workflow.

---

## 📦 What’s Included

- Hyprland dotfiles
- GTK & system theming
- Workflow scripts
- One-shot installer (`installer.sh`)
- Wallpaper & theme automation

All dependencies and configs are handled **inside the installer** — no git submodules required.

---

## ⚙️ Requirements

- Arch Linux (base install)
- git
- yay
- Chaotic-AUR enabled

---

## 🚀 Installation

```bash
git clone https://github.com/aadritobasu/HyprKenso.git
cd HyprKenso
chmod +x installer.sh
./installer.sh
```

---

## ⚠️ Post-Install

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

## 🙏 Credits

- Fastfetch config by **menhoudj**

---

## ❤️ Final Words

Enjoy ricing. Enjoy simplicity.

— Aadrito Basu
