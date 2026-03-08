#!/usr/bin/env fish
# ~/.config/fish/conf.d/hyprland.fish
# Hyprland helpers for Fish shell — source this or drop in conf.d/

# ── Wallpaper shortcuts ────────────────────────────────────────────
function wp
    ~/.config/hypr/scripts/wallpaper.sh $argv
end

function wpr
    ~/.config/hypr/scripts/wallpaper.sh --random
    echo "🎲 Random wallpaper set!"
end

# ── Reload waybar ──────────────────────────────────────────────────
function reload-waybar
    pkill waybar
    sleep 0.3
    waybar > /tmp/waybar.log 2>&1 &
    echo "✓ Waybar reloaded"
end

# ── Reload hyprland config ────────────────────────────────────────
function reload-hypr
    hyprctl reload
    echo "✓ Hyprland config reloaded"
end

# ── Quick screenshot helpers ──────────────────────────────────────
function ss
    hyprshot -m region -o ~/Pictures/Screenshots
end

function ssw
    hyprshot -m window -o ~/Pictures/Screenshots
end

function sss
    hyprshot -m output -o ~/Pictures/Screenshots
end

# ── Workspace info ────────────────────────────────────────────────
function winfo
    hyprctl workspaces -j | python3 -c "
import json, sys
ws = json.load(sys.stdin)
for w in sorted(ws, key=lambda x: x['id']):
    print(f\"  WS {w['id']:2}  windows: {w['windows']:2}  monitor: {w['monitor']}\")"
end

# ── Show current window info ───────────────────────────────────────
function wininfo
    hyprctl activewindow -j | python3 -c "
import json, sys
w = json.load(sys.stdin)
print(f\"Class:  {w.get('class','')}\" )
print(f\"Title:  {w.get('title','')}\" )
print(f\"Size:   {w.get('size',[])}\"  )
print(f\"Pos:    {w.get('at',[])}\"    )
print(f\"Float:  {w.get('floating',False)}\")"
end
