<div align="center">

# Latent Dotfiles

**by Solesse · CachyOS · Hyprland · Wayland · matugen**

</div>

## Install

```bash
git clone https://github.com/DyberX/Latent-Dotfiles
cd Latent-Dotfiles
bash install.sh
```

## Stack

| Role | Program |
|---|---|
| WM | Hyprland |
| Bar | Waybar |
| Terminal | Kitty |
| Shell | Zsh + oh-my-zsh + Starship |
| Launcher | Vicinae |
| Wallpaper | swww + matugen |
| Notifications | swaync + dunst |
| Lockscreen | hyprlock |
| Idle | hypridle |
| File Manager | Nautilus |
| Browser | Zen Browser |
| GTK Theme | adw-gtk3-dark + MacTahoe |
| Icons | MacTahoe |
| Cursor | MacTahoe-cursors |
| Fonts | JetBrainsMono Nerd Font, FiraCode Nerd Font |
| System monitor | btop |
| Visualizer | cava |
| Fetch | fastfetch |

## matugen

Every color across the entire setup is generated from your wallpaper via [matugen](https://github.com/InioX/matugen). Changing your wallpaper with `Super + ;` automatically recolors:

waybar · hyprlock · kitty · starship · dunst · fuzzel · swaync · cava · btop · gtk

## Keybinds

### Launchers
| Keybind | Action |
|---|---|
| `Super + Enter` | Terminal (kitty) |
| `Super + Space` | App launcher (vicinae) |
| `Super + E` | File manager (nautilus) |
| `Super + B` | Browser (zen) |

### Wallpaper
| Keybind | Action |
|---|---|
| `Super + ;` | Wallpaper picker |
| `Super + Shift + ;` | Random wallpaper |

### Utilities
| Keybind | Action |
|---|---|
| `Super + L` | Lock screen |
| `Super + Shift + N` | Notifications panel |

### Screenshots
| Keybind | Action |
|---|---|
| `Print` | Screenshot full output |
| `Shift + Print` | Screenshot region |
| `Super + Print` | Screenshot active window |

### Window Management
| Keybind | Action |
|---|---|
| `Super + W` | Close window |
| `Super + F` | Maximize |
| `Super + Shift + F` | True fullscreen |
| `Super + V` | Toggle floating |
| `Super + C` | Center window |
| `Super + P` | Pseudo-tile |
| `Super + Shift + P` | Toggle split |

### Focus
| Keybind | Action |
|---|---|
| `Super + Arrow keys` | Move focus |
| `Super + H / J / K` | Move focus left / down / up |

### Move & Resize
| Keybind | Action |
|---|---|
| `Super + Shift + Arrow keys` | Move window |
| `Super + Ctrl + Arrow keys` | Resize window |
| `Super + LMB drag` | Move window (mouse) |
| `Super + RMB drag` | Resize window (mouse) |

### Workspaces
| Keybind | Action |
|---|---|
| `Super + 1–0` | Switch to workspace 1–10 |
| `Super + Shift + 1–0` | Move window to workspace 1–10 |
| `Super + Tab` | Next workspace |
| `Super + Shift + Tab` | Previous workspace |
| `Super + Scroll` | Scroll through workspaces |

### Scratchpad
| Keybind | Action |
|---|---|
| `Super + S` | Toggle scratchpad |
| `Super + Shift + S` | Move window to scratchpad |

### Media
| Keybind | Action |
|---|---|
| `Volume Up / Down` | ±2% volume |
| `Mute` | Toggle mute |
| `Mic Mute` | Toggle mic |
| `Play / Pause / Next / Prev` | Media controls |
| `Brightness Up / Down` | ±5% brightness |

### Touchpad Gestures
| Gesture | Action |
|---|---|
| 3-finger swipe horizontal | Switch workspace |
| 3-finger swipe up | Fullscreen |
| 3-finger swipe down | Close window |
| 4-finger swipe horizontal | Move window |
| 4-finger swipe up | Scratchpad |

### Session
| Keybind | Action |
|---|---|
| `Super + Shift + Q` | Exit Hyprland |
