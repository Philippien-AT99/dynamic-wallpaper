<p align="center">
  <img src="https://raw.githubusercontent.com/adi1090x/files/master/dynamic-wallpaper/logo.png">
</p>
<p align="center">
  <img src="https://img.shields.io/badge/Maintained%3F-Yes-green?style=for-the-badge">
  <img src="https://img.shields.io/github/license/adi1090x/dynamic-wallpaper?style=for-the-badge">
  <img src="https://img.shields.io/github/stars/adi1090x/dynamic-wallpaper?style=for-the-badge">
</p>
<p align="center">A simple <code>bash</code> script to set wallpapers according to current time, optimized for <b>Hyprland & Wayland</b>.</p>

![gif](https://raw.githubusercontent.com/adi1090x/files/master/dynamic-wallpaper/main.gif) 

### Overview
* **Hyprland Native**: Uses `swww` for smooth, high-performance transitions.
- **No Octal Bug**: Fixed the "08/09 hour" error for seamless daily operation.
- **Format Support**: Automatically detects `.jpg`, `.png`, `.webp`, and `.gif`.
- **Systemd Optimized**: Replaces old Cron jobs with modern Systemd Timers.

### Dependencies
Install these programs before using `dwall`:
- **`swww`**: Required for Wayland/Hyprland wallpaper rendering.
- **`systemd`**: Recommended for the hourly timer.
- **`pywal`**: Optional, for dynamic color schemes.
```bash
# On Arch Linux
$ yay -S swww pywal
```

### Installation
1. **Clone and install**:
```bash
$ git clone https://github.com/Philippien-AT99/dynamic-wallpaper.git
$ cd dynamic-wallpaper
$ chmod +x install.sh
$ ./install.sh
```

### Automation (Systemd Timer)
This version uses **Systemd Timers** for better integration with Wayland.

1. **Create the service** (`~/.config/systemd/user/dwall.service`):
```ini
[Service]
ExecStart=/usr/bin/dwall -s beach
```

2. **Create the timer** (`~/.config/systemd/user/dwall.timer`):
```ini
[Timer]
OnCalendar=hourly
Persistent=true

[Install]
WantedBy=timers.target
```

3. **Enable**: `systemctl --user enable --now dwall.timer`

#### Autostart on Hyprland
Add this to your `hyprland.conf`:
```bash
exec-once = dwall -s beach
```

#### Roadmap (TODO)
**Wayland (Priority)**
- [x] **Hyprland**
- [ ] **Sway**
- [ ] **Cosmic Desktop**
- [ ] **River / Wayfire**

**X11/Mixed**
- [ ] **XFCE**
- [ ] **KDE Plasma**
- [ ] **GNOME**
- [ ] **LXQt / Cinnamon**

### Credits
- **Original Author**: [Aditya Shakya (@adi1090x)](https://github.com/adi1090x).
- **Optimization**: Forked for modern Hyprland/Wayland sessions.
- **License**: Distributed under the **GPL-3.0 License**.