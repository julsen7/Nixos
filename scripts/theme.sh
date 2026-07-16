#!/usr/bin/env bash

THEMES_DIR="$HOME/themes"

BLACKWHITE_ICON="$HOME/scripts/blackwhite.jpg"
COLOR_ICON="$HOME/scripts/colorful.jpg"

if [[ -n "$1" ]]; then
    SELECTED_THEME="$1"
else
    themes=(
        "BlackWhite\0icon\x1f${BLACKWHITE_ICON}"
        "Colorful\0icon\x1f${COLOR_ICON}"
    )
    SELECTED_THEME=$(printf "%b\n" "${themes[@]}" | rofi -dmenu -p "Theme Selector")
fi

DUNST_TARGET="$HOME/.config/dunst/dunstrc"
HYPR_LUA_TARGET="$HOME/.config/hypr/colors.lua"
HYPR_CONF_TARGET="$HOME/.config/hypr/colors.conf"
KITTY_TARGET="$HOME/.config/kitty/current-theme.conf"
ROFI_TARGET="$HOME/.config/rofi/colors.rasi"
WAYBAR_TARGET="$HOME/.config/waybar/colors.css"

if [[ -n "$SELECTED_THEME" ]]; then
    mkdir -p "$HOME/.config/dunst" "$HOME/.config/hypr" "$HOME/.config/kitty" "$HOME/.config/rofi" "$HOME/.config/waybar"

    if [[ "$SELECTED_THEME" == "BlackWhite" ]]; then
        BLACKWHITE_THEME_DIR="$HOME/themes/blackwhite"

        ln -sf "$BLACKWHITE_THEME_DIR/dunstrc" "$DUNST_TARGET"
        ln -sf "$BLACKWHITE_THEME_DIR/hypr.lua" "$HYPR_LUA_TARGET"
        ln -sf "$BLACKWHITE_THEME_DIR/hypr.conf" "$HYPR_CONF_TARGET"
        ln -sf "$BLACKWHITE_THEME_DIR/kitty.conf" "$KITTY_TARGET"
        ln -sf "$BLACKWHITE_THEME_DIR/rofi.rasi" "$ROFI_TARGET"
        ln -sf "$BLACKWHITE_THEME_DIR/waybar.css" "$WAYBAR_TARGET"

        if [[ -n "$DISPLAY" || -n "$WAYLAND_DISPLAY" ]]; then
            dunstify "Theme Selector" "$SELECTED_THEME theme selected" -i "$BLACKWHITE_ICON"
        fi

    elif [[ "$SELECTED_THEME" == "Colorful" ]]; then
        COLORFUL_THEME_DIR="$HOME/themes/colorful"

        if [[ ! -d "$COLORFUL_THEME_DIR" ]]; then
            echo "Fehler: Matugen-Cache existiert nicht. Bitte erst Wallpaper setzen!"
            exit 1
        fi

        ln -sf "$COLORFUL_THEME_DIR/dunstrc" "$DUNST_TARGET"
        ln -sf "$COLORFUL_THEME_DIR/hypr.lua" "$HYPR_LUA_TARGET"
        ln -sf "$COLORFUL_THEME_DIR/hypr.conf" "$HYPR_CONF_TARGET"
        ln -sf "$COLORFUL_THEME_DIR/kitty.conf" "$KITTY_TARGET"
        ln -sf "$COLORFUL_THEME_DIR/rofi.rasi" "$ROFI_TARGET"
        ln -sf "$COLORFUL_THEME_DIR/waybar.css" "$WAYBAR_TARGET"

        if [[ -n "$DISPLAY" || -n "$WAYLAND_DISPLAY" ]]; then
            dunstify "Theme Selector" "$SELECTED_THEME theme selected" -i "$COLOR_ICON"
        fi
    fi

    if [[ -n "$DISPLAY" || -n "$WAYLAND_DISPLAY" ]]; then
        dunstctl reload
        pkill -SIGUSR1 kitty
        spicetify watch -s 2>&1 | sed "/Reloaded Spotify/q"
        pkill -SIGUSR2 waybar
    fi
fi
