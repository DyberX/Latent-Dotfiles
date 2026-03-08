#!/usr/bin/env bash
# wallpaper.sh — set wallpaper on all monitors + run matugen

WALLPAPER_DIR="$HOME/Pictures/Wallpapers"
CACHE_FILE="$HOME/.cache/current_wallpaper"

mkdir -p "$WALLPAPER_DIR"

# ── Pick wallpaper ────────────────────────────────────────────────
if [[ "$1" == "--random" ]]; then
    WALLPAPER=$(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.jpeg" -o -iname "*.webp" \) | shuf -n1)
elif [[ -n "$1" && -f "$1" ]]; then
    WALLPAPER="$1"
else
    WALLPAPER=$(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.jpeg" -o -iname "*.webp" \) \
        | sort \
        | sed "s|$HOME/||" \
        | fuzzel --dmenu --prompt "  wallpaper: " --width 70 --lines 15 \
        | sed "s|^|$HOME/|")
fi

[[ -z "$WALLPAPER" ]] && exit 0
[[ ! -f "$WALLPAPER" ]] && { notify-send "Wallpaper" "File not found: $WALLPAPER" -i dialog-error; exit 1; }

# ── Set on ALL monitors (wait for each to finish) ─────────────────
mapfile -t MONITORS < <(hyprctl monitors -j | python3 -c "import json,sys; [print(m['name']) for m in json.load(sys.stdin)]")

for monitor in "${MONITORS[@]}"; do
    swww img "$WALLPAPER" \
        --outputs "$monitor" \
        --transition-type fade \
        --transition-duration 1.0 \
        --transition-fps 60
    sleep 0.1
done

echo "$WALLPAPER" > "$CACHE_FILE"

# ── Regenerate all colors ─────────────────────────────────────────
matugen image "$WALLPAPER"

# ── Reload everything ─────────────────────────────────────────────
pkill waybar; sleep 0.3; waybar > /tmp/waybar.log 2>&1 &
pkill dunst  && dunst &
pkill swaync && sleep 0.2 && swaync &
hyprctl reload
kill -SIGUSR1 "$(pidof kitty 2>/dev/null)" 2>/dev/null || true
pkill cava || true

notify-send "Wallpaper" "$(basename "$WALLPAPER")" -t 2000
