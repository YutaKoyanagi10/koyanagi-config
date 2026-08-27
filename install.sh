#!/usr/bin/env bash

set -euo pipefail

# Koyanagi Theme - Full Configuration Installer
# This script applies the complete koyanagi look including:
# - Hyprland gaps, borders, rounding, blur, opacity
# - Layer rules for shell blur
#
# Usage:
#   ./install.sh          # Apply koyanagi config
#   ./install.sh --revert # Revert to previous config

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Check if Omarchy is installed
if [[ ! -d "$HOME/.config/hypr" ]]; then
    echo "Error: ~/.config/hypr not found. Is Omarchy installed?"
    exit 1
fi

# Revert mode
if [[ "${1:-}" == "--revert" ]]; then
    LATEST_BACKUP=$(ls -td "$HOME/.config/hypr/backup-"* 2>/dev/null | head -1)
    if [[ -z "$LATEST_BACKUP" ]]; then
        echo "Error: No backup found in ~/.config/hypr/backup-*"
        exit 1
    fi
    echo "Restoring from: $LATEST_BACKUP"
    for file in looknfeel.lua rules.lua; do
        if [[ -f "$LATEST_BACKUP/$file" ]]; then
            cp "$LATEST_BACKUP/$file" "$HOME/.config/hypr/$file"
            echo "Restored $file"
        else
            rm -f "$HOME/.config/hypr/$file"
            echo "Removed $file (was not in backup)"
        fi
    done
    echo ""
    echo "Reverted successfully! Run: hyprctl reload"
    exit 0
fi

# Install mode
BACKUP_DIR="$HOME/.config/hypr/backup-$(date +%s)"

# Create backup directory
mkdir -p "$BACKUP_DIR"
echo "Backing up existing config to: $BACKUP_DIR"

# Backup existing files if they exist
for file in looknfeel.lua rules.lua; do
    if [[ -f "$HOME/.config/hypr/$file" ]]; then
        cp "$HOME/.config/hypr/$file" "$BACKUP_DIR/$file"
    fi
done

# Write looknfeel.lua
cat > "$HOME/.config/hypr/looknfeel.lua" << 'EOF'
-- Koyanagi Theme - Hyprland Look and Feel
-- https://wiki.hypr.land/Configuring/Basics/Variables/#general
hl.config({
  general = {
    gaps_in = 4,
    gaps_out = 6,
    border_size = 1,
    resize_on_border = true,
    extend_border_grab_area = 15,
    allow_tearing = false,
    layout = "dwindle",
  },

  decoration = {
    rounding = 10,

    shadow = {
      enabled = true,
      range = 30,
      render_power = 4,
      color = "rgba(00000055)",
      color_inactive = "rgba(00000033)",
      offset = "0 4",
    },

    blur = {
      enabled = true,
      size = 12,
      passes = 4,
      contrast = 1.2,
      brightness = 0.9,
      vibrancy = 0.4,
      vibrancy_darkness = 0.3,
      noise = 0.12,
      ignore_opacity = true,
    },

    active_opacity = 0.75,
    inactive_opacity = 0.65,
    fullscreen_opacity = 1.0,
  },
})
EOF

# Write rules.lua
cat > "$HOME/.config/hypr/rules.lua" << 'EOF'
-- Koyanagi Theme - Layer Rules for Shell Blur

local shell_layers = {
  "omarchy-bar", "omarchy-menu", "omarchy-notifications",
  "omarchy-clipboard", "omarchy-emojis", "omarchy-osd",
  "omarchy-polkit", "omarchy-image-selector", "omarchy-reminders",
  "omarchy-network-qr", "omarchy-keyboard-panel",
}

local blur_rules = {}
for _, ns in ipairs(shell_layers) do
  table.insert(blur_rules, { rule = "blur", match = { namespace = ns } })
  table.insert(blur_rules, { rule = "ignorezero", match = { namespace = ns } })
  table.insert(blur_rules, { rule = "rounding", value = 10, match = { namespace = ns } })
end

hl.config({ layerrule = blur_rules })
EOF

echo "Koyanagi configuration applied successfully!"
echo "Backup saved to: $BACKUP_DIR"
echo ""
echo "To reload Hyprland config, run:"
echo "  hyprctl reload"
echo ""
echo "To revert, run:"
echo "  ./install.sh --revert"
