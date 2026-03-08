#!/usr/bin/env bash
# install.sh — Solesse's Latent-Dotfiles installer
set -e

DOTS="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG="$HOME/.config"

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[0;33m'
CYAN='\033[0;36m'; BOLD='\033[1m'; RESET='\033[0m'
info()  { echo -e "${CYAN}  → $*${RESET}"; }
ok()    { echo -e "${GREEN}  ✓ $*${RESET}"; }
warn()  { echo -e "${YELLOW}  ○ $*${RESET}"; }
banner() {
    echo -e "${CYAN}"
    echo "  ╔══════════════════════════════════════════════╗"
    echo "  ║       Solesse's Latent-Dotfiles installer    ║"
    echo "  ║         CachyOS · Hyprland · Wayland         ║"
    echo "  ╚══════════════════════════════════════════════╝"
    echo -e "${RESET}"
}

banner

echo -e "  This will install packages and overwrite configs in ${BOLD}~/.config${RESET}"
echo    "  Press Enter to continue or Ctrl+C to cancel."
read -r

# ── Detect AUR helper ─────────────────────────────────────────────
if command -v paru &>/dev/null; then AUR="paru"
elif command -v yay &>/dev/null; then AUR="yay"
else AUR=""; fi

# ── Pacman packages ───────────────────────────────────────────────
echo ""
info "Installing pacman packages..."

sudo pacman -S --needed --noconfirm \
    hyprland hyprlock hypridle hyprshot \
    xdg-desktop-portal-hyprland xdg-desktop-portal-gtk \
    waybar swww kitty zsh starship \
    fuzzel dunst swaync \
    nautilus brightnessctl playerctl \
    pipewire wireplumber pipewire-pulse pavucontrol \
    blueman networkmanager network-manager-applet \
    wl-clipboard cliphist polkit-gnome \
    python python-pillow btop cava fastfetch \
    grim slurp wget curl git \
    adw-gtk-theme noto-fonts \
    ttf-firacode-nerd ttf-jetbrains-mono-nerd \
    && ok "pacman packages installed" || warn "some pacman packages failed"

# ── AUR packages ──────────────────────────────────────────────────
echo ""
if [[ -n "$AUR" ]]; then
    info "Installing AUR packages (using $AUR)..."
    $AUR -S --needed --noconfirm \
        matugen-bin \
        mactahoe-cursor-theme-git \
        zen-browser-bin \
        vicinae-bin \
        && ok "AUR packages installed" || warn "some AUR packages failed — install manually if needed"
else
    warn "No AUR helper found — install paru then run:"
    warn "  paru -S matugen-bin mactahoe-cursor-theme-git zen-browser-bin vicinae-bin"
fi

# ── MacTahoe icon theme ───────────────────────────────────────────
echo ""
info "Installing MacTahoe icon theme..."
if [[ ! -d "$HOME/.local/share/icons/MacTahoe" ]]; then
    TMP=$(mktemp -d)
    git clone --depth=1 https://github.com/vinceliuice/MacTahoe-icon-theme "$TMP/icons" \
        && bash "$TMP/icons/install.sh" \
        && ok "MacTahoe icons installed" \
        || warn "MacTahoe icon install failed"
    rm -rf "$TMP"
else
    ok "MacTahoe icons already installed"
fi

# ── MacTahoe GTK theme ────────────────────────────────────────────
echo ""
info "Installing MacTahoe GTK theme..."
if [[ ! -d "$HOME/.themes/MacTahoe-Dark" ]]; then
    TMP=$(mktemp -d)
    git clone --depth=1 https://github.com/vinceliuice/MacTahoe-gtk-theme "$TMP/gtk" \
        && bash "$TMP/gtk/install.sh" \
        && ok "MacTahoe GTK theme installed" \
        || warn "MacTahoe GTK theme install failed"
    rm -rf "$TMP"
else
    ok "MacTahoe GTK theme already installed"
fi

# ── oh-my-zsh ─────────────────────────────────────────────────────
echo ""
info "Installing oh-my-zsh..."
# Check it's actually complete, not just the folder
if [[ ! -f "$HOME/.oh-my-zsh/oh-my-zsh.sh" ]]; then
    rm -rf "$HOME/.oh-my-zsh"
    ZSH= RUNZSH=no CHSH=no sh -c \
        "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" \
        && ok "oh-my-zsh installed" \
        || warn "oh-my-zsh install failed"
else
    ok "oh-my-zsh already installed"
fi

# ── zsh plugins ───────────────────────────────────────────────────
info "Installing zsh plugins..."
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

[[ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]] && \
    git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions \
    "$ZSH_CUSTOM/plugins/zsh-autosuggestions" \
    && ok "zsh-autosuggestions" || ok "zsh-autosuggestions already present"

[[ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]] && \
    git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting \
    "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" \
    && ok "zsh-syntax-highlighting" || ok "zsh-syntax-highlighting already present"

# ── Deploy configs ────────────────────────────────────────────────
echo ""
info "Deploying configs..."

deploy() {
    local src="$DOTS/$1" dst="$CONFIG/$1"
    if [[ -e "$src" ]]; then
        mkdir -p "$(dirname "$dst")"
        cp -r "$src" "$dst"
        ok "$1"
    else
        warn "$1 not found in dotfiles, skipping"
    fi
}

deploy hypr
deploy waybar
deploy kitty
deploy fish
deploy fuzzel
deploy dunst
deploy swaync
deploy matugen
deploy cava
deploy fastfetch
deploy vicinae
deploy gtk-3.0
deploy gtk-4.0

# ── .zshrc ────────────────────────────────────────────────────────
echo ""
info "Writing .zshrc..."
cat > "$HOME/.zshrc" << 'ZSHRC'
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME=""

plugins=(
    git
    zsh-autosuggestions
    zsh-syntax-highlighting
    sudo
    dirhistory
    copypath
    copyfile
)

source $ZSH/oh-my-zsh.sh

eval "$(starship init zsh)"

alias ls='ls --color=auto'
alias ll='ls -lah --color=auto'
alias grep='grep --color=auto'
alias hypr-reload='hyprctl reload'
alias waybar-reload='pkill waybar; sleep 0.3; waybar > /tmp/waybar.log 2>&1 &'
alias wp='~/.config/hypr/scripts/wallpaper.sh'
alias wpr='~/.config/hypr/scripts/wallpaper.sh --random'
ZSHRC
ok ".zshrc written"

# ── Make scripts executable ───────────────────────────────────────
chmod +x "$CONFIG/hypr/scripts/"*.sh 2>/dev/null
ok "hypr scripts marked executable"

# ── Create directories ────────────────────────────────────────────
mkdir -p "$HOME/Pictures/Wallpapers" "$HOME/Pictures/Screenshots"
ok "Pictures directories created"

# ── Apply GTK settings ────────────────────────────────────────────
echo ""
info "Applying GTK settings..."
gsettings set org.gnome.desktop.interface color-scheme      'prefer-dark'
gsettings set org.gnome.desktop.interface gtk-theme         'adw-gtk3-dark'
gsettings set org.gnome.desktop.interface icon-theme        'MacTahoe'
gsettings set org.gnome.desktop.interface cursor-theme      'MacTahoe-cursors'
gsettings set org.gnome.desktop.interface cursor-size       24
gsettings set org.gnome.desktop.interface font-name         'Noto Sans 10'
gsettings set org.gnome.desktop.interface monospace-font-name 'JetBrainsMono Nerd Font 10'
ok "GTK settings applied"

# ── Set zsh as default shell ──────────────────────────────────────
echo ""
info "Setting zsh as default shell..."
if [[ "$SHELL" != *"zsh" ]]; then
    chsh -s "$(which zsh)"
    ok "Default shell set to zsh (takes effect on next login)"
else
    ok "zsh is already the default shell"
fi

# ── Enable services ───────────────────────────────────────────────
echo ""
info "Enabling services..."
systemctl --user enable --now pipewire pipewire-pulse wireplumber 2>/dev/null \
    && ok "pipewire enabled" || warn "pipewire already running"
sudo systemctl enable --now NetworkManager 2>/dev/null \
    && ok "NetworkManager enabled" || warn "NetworkManager already running"
sudo systemctl enable --now bluetooth 2>/dev/null \
    && ok "bluetooth enabled" || warn "bluetooth not available"

# ── Run matugen ───────────────────────────────────────────────────
echo ""
info "Running matugen..."
CACHED_WP=$(cat "$HOME/.cache/current_wallpaper" 2>/dev/null)
if [[ -f "$CACHED_WP" ]]; then
    matugen image "$CACHED_WP" \
        && ok "matugen colors generated" \
        || warn "matugen failed — run manually after setting a wallpaper"
else
    warn "No cached wallpaper — press Super + ; after login to pick one"
fi

# ── Done ──────────────────────────────────────────────────────────
echo ""
echo -e "${CYAN}"
echo "  ╔══════════════════════════════════════════════╗"
echo "  ║             Install complete!                ║"
echo "  ╚══════════════════════════════════════════════╝"
echo -e "${RESET}"
echo    "  Next steps:"
echo    "  1. Log out → select Hyprland from your display manager"
echo    "  2. Press Super + ; to pick a wallpaper"
echo    "  3. Colors auto-generate across everything via matugen"
echo    ""
echo    "  Keybinds:"
echo    "  Super + Enter   → terminal (kitty)"
echo    "  Super + Space   → launcher (vicinae)"
echo    "  Super + E       → files (nautilus)"
echo    "  Super + L       → lock screen"
echo    ""
