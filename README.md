<p align="center">
  <img src="https://raw.githubusercontent.com/adi1090x/files/master/dynamic-wallpaper/logo.png">
</p>
<p align="center">
  <img src="https://img.shields.io/badge/Maintained%3F-Yes-green?style=for-the-badge">
  <img src="https://img.shields.io/github/license/Philippien-AT99/dynamic-wallpaper?style=for-the-badge">
  <img src="https://img.shields.io/github/stars/Philippien-AT99/dynamic-wallpaper?style=for-the-badge">
</p>
<p align="center">A simple <code>bash</code> script to set wallpapers according to current time, optimized for <b>Hyprland & Wayland</b>.</p>

> [!NOTE]
> Note: Matugen support is experimental as I don't use it personally. Feel free to open an issue if it behaves unexpectedly!

![gif](https://raw.githubusercontent.com/adi1090x/files/master/dynamic-wallpaper/main.gif) 

### Overview
- **Hyprland Native**: Uses `swww` for smooth, high-performance transitions.
- **Dynamic Theming**: Automatically generates color schemes using **Matugen** (preferred) or **Pywal**.
- **Format Support**: Automatically detects `.jpg`, `.png`, `.webp`, and `.gif`.
- **Systemd Optimized**: Replaces old Cron jobs with modern Systemd Timers.

### Dependencies
Install these programs before using `dwall`:
- **`swww`**: Required for Wayland/Hyprland wallpaper rendering.
- **`systemd`**: Recommended for the hourly timer.
- **`matugen`**: (Optional) For modern Material You dynamic colors.
- **`pywal`**: Optional, for dynamic color schemes.
```bash
# On Arch Linux
$ yay -S sww matugen-bin
# or
$ yay -S swww pywal
```

**Integration with Hyprland & Matugen**
To make your window borders and UI match the wallpaper automatically with **Matugen**:

1. **Update your Hyprland config**: Add this line to your `~/.config/hypr/hyprland.conf`:
```ini
source = ~/.config/hypr/colors.conf
```

2. **Configure Matugen output**: Create `~/.config/matugen/config.toml`:
```ini
[config.outputs.hyprland]
path = "~/.config/hypr/colors.conf"
template = "hyprland.desktop"
```

3. **Use the variables:**
```ini
general {
    col.active_border = $primary
    col.inactive_border = $surface_variant
}
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

### How to add own wallpapers

+ Download a wallpaper set you like.
+ Rename the wallpapers (must be **jpg/png**) to `0-23`. If you don't have enough images, symlink them.
+ Make a directory in `/usr/share/dynamic-wallpaper/images` and copy your wallpapers in that. 
+ Run the program, select the style and apply it.

**`Tips`**
- You can use `dwall` to change between your favorite wallpapers every hour.
- You can use `dwall` as picture slide, which can set your favorite photos as wallpaper every hour or every 15 minutes. Just create an appropriate timer.

### Use HEIC Images

You may also want to use wallpapers from [Dynamic Wallpaper Club](https://dynamicwallpaper.club/). To do so, you need to convert `.heic` image file to either png or jpg format. Download a `.heic` wallpaper file you like and follow the steps below to convert images.

- First install `heif-convert` on your system - 
```bash
# On Archlinux
$ sudo pacman -S libheif
# or
$ yay -S libheif
```

- Move your `.heic` file in a directory and run following command to convert images - 
```bash
# change to directory
$ cd Downloads/heic_images

# convert to jpg images
$ for file in *.heic; do heif-convert $file ${file/%.heic/.jpg}; done
```

- Now, you have the images, just follow the [above](https://github.com/adi1090x/dynamic-wallpaper#How-to-add-own-wallpapers) steps to use these wallpapers with `dwall`.

**More Wallpapers :** I've also created a few more wallpaper sets, which are not added to this repository because of their big size. You can download these wallpapers set from here - 
<p align="center">
  <a href="https://github.com/adi1090x/files/tree/master/dynamic-wallpaper/wallpapers"><img alt="undefined" src="https://img.shields.io/badge/Download-Here-blue?style=for-the-badge&logo=github"></a>
</p>

**`Available Sets`** : `Catalina`, `London`, `Maldives`, `Mojave HD`, `Mount Fuji`, `Seoul`, and more...

### Previews

|Aurora|Beach|Bitday|Chihuahuan|
|--|--|--|--|
|![gif](https://raw.githubusercontent.com/adi1090x/files/master/dynamic-wallpaper/aurora.gif)|![gif](https://raw.githubusercontent.com/adi1090x/files/master/dynamic-wallpaper/beach.gif)|![gif](https://raw.githubusercontent.com/adi1090x/files/master/dynamic-wallpaper/bitday.gif)|![gif](https://raw.githubusercontent.com/adi1090x/files/master/dynamic-wallpaper/chihuahuan.gif)|

|Cliffs|Colony|Desert|Earth|
|--|--|--|--|
|![gif](https://raw.githubusercontent.com/adi1090x/files/master/dynamic-wallpaper/cliffs.gif)|![gif](https://raw.githubusercontent.com/adi1090x/files/master/dynamic-wallpaper/colony.gif)|![gif](https://raw.githubusercontent.com/adi1090x/files/master/dynamic-wallpaper/desert.gif)|![gif](https://raw.githubusercontent.com/adi1090x/files/master/dynamic-wallpaper/earth.gif)|

|Exodus|Factory|Forest|Gradient|
|--|--|--|--|
|![gif](https://raw.githubusercontent.com/adi1090x/files/master/dynamic-wallpaper/exodus.gif)|![gif](https://raw.githubusercontent.com/adi1090x/files/master/dynamic-wallpaper/factory.gif)|![gif](https://raw.githubusercontent.com/adi1090x/files/master/dynamic-wallpaper/forest.gif)|![gif](https://raw.githubusercontent.com/adi1090x/files/master/dynamic-wallpaper/gradient.gif)|

|Home|Island|Lake|Lakeside|
|--|--|--|--|
|![gif](https://raw.githubusercontent.com/adi1090x/files/master/dynamic-wallpaper/home.gif)|![gif](https://raw.githubusercontent.com/adi1090x/files/master/dynamic-wallpaper/island.gif)|![gif](https://raw.githubusercontent.com/adi1090x/files/master/dynamic-wallpaper/lake.gif)|![gif](https://raw.githubusercontent.com/adi1090x/files/master/dynamic-wallpaper/lakeside.gif)|

|Market|Mojave|Moon|Mountains|
|--|--|--|--|
|![gif](https://raw.githubusercontent.com/adi1090x/files/master/dynamic-wallpaper/market.gif)|![gif](https://raw.githubusercontent.com/adi1090x/files/master/dynamic-wallpaper/mojave.gif)|![gif](https://raw.githubusercontent.com/adi1090x/files/master/dynamic-wallpaper/moon.gif)|![gif](https://raw.githubusercontent.com/adi1090x/files/master/dynamic-wallpaper/mountains.gif)|

|Room|Sahara|Street|Tokyo|
|--|--|--|--|
|![gif](https://raw.githubusercontent.com/adi1090x/files/master/dynamic-wallpaper/room.gif)|![gif](https://raw.githubusercontent.com/adi1090x/files/master/dynamic-wallpaper/sahara.gif)|![gif](https://raw.githubusercontent.com/adi1090x/files/master/dynamic-wallpaper/street.gif)|![gif](https://raw.githubusercontent.com/adi1090x/files/master/dynamic-wallpaper/tokyo.gif)|

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
- **Optimization**: Forked for modern Hyprland/Wayland sessions by [Aina KANTY (Philippien-AT99)](https://github.com/Philippien-AT99).
- **License**: Distributed under the **GPL-3.0 License**.