# Koyanagi Config

Full configuration for the [koyanagi theme](https://github.com/YutaKoyanagi10/omarchy-koyanagi-theme) including custom Hyprland settings.

## What's Included

- Custom gaps, borders, and rounding
- Window shadows
- Blur effects with custom settings
- Window opacity (active: 0.75, inactive: 0.65)
- Layer rules for shell blur (bar, menu, notifications, etc.)

## Installation

1. Install the koyanagi theme first:
```bash
omarchy theme install https://github.com/YutaKoyanagi10/omarchy-koyanagi-theme.git
```

2. Clone this config repo:
```bash
git clone https://github.com/YutaKoyanagi10/koyanagi-config.git
cd koyanagi-config
```

3. Run the installer:
```bash
./install.sh
```

4. Reload Hyprland:
```bash
hyprctl reload
```

## What the Script Does

- Creates a backup of your existing `looknfeel.lua` and `rules.lua`
- Installs new `looknfeel.lua` with koyanagi appearance settings
- Installs new `rules.lua` with shell blur layer rules

## Backup Location

Backups are saved to `~/.config/hypr/backup-<timestamp>/`
