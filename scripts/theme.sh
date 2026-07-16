#!/usr/bin/env bash

THEMES_DIR="$HOME/themes"

BLACKWHITE_ICON="$HOME/scripts/blackwhite.jpg"
COLOR_ICON="$HOME/scripts/colorful.jpg"

themes=(
    "BlackWhite\0icon\x1f${$BLACKWHITE_ICON}"
    "Colorful\0icon\x1f${COLOR_ICON}"
)

SELECTED_THEME=$(printf "%b\n" "${themes[@]}" | rofi -dmenu -p "Theme Selector")

if [[ -n "$SELECTED_THEME" ]]; then
    
    if [[ "$SELECTED_THEME" == "BlackWhite" ]]; then
        BLACKWHITE_THEME_DIR="$HOME/themes/blackwhite"

        ln -sf "$BLACKWHITE_THEME_DIR/dunstrc" "$HOME/.config/dunst/dunstrc"
        ln -sf "$BLACKWHITE_THEME_DIR/hypr.lua" "$HOME/.config/hypr/colors.lua"
        ln -sf "$BLACKWHITE_THEME_DIR/hypr.conf" "$HOME/.config/hypr/colors.conf"
        ln -sf "$BLACKWHITE_THEME_DIR/kitty.conf" "$HOME/.config/kitty/current-theme.conf"
        sed -i 's/Theme=com.obsproject.colorful/Theme=com.obsproject.Yami.Acri/g' "$HOME/.config/obs-studio/user.ini"
        ln -sf "$BLACKWHITE_THEME_DIR/rofi.rasi" "$HOME/.config/rofi/colors.rasi"
        ln -sf "$BLACKWHITE_THEME_DIR/waybar.css" "$HOME/.config/waybar/colors.css"

        dunstify "Theme Selector" "$SELECTED_THEME theme selected" -i "$BLACKWHITE_ICON"
    elif [[ "$SELECTED_THEME" == "Colorful" ]]; then
        COLORFUL_THEME_DIR="$HOME/themes/colorful"

        ln -sf "$COLORFUL_THEME_DIR/dunstrc" "$HOME/.config/dunst/dunstrc"
        ln -sf "$COLORFUL_THEME_DIR/hypr.lua" "$HOME/.config/hypr/colors.lua"
        ln -sf "$COLORFUL_THEME_DIR/hypr.conf" "$HOME/.config/hypr/colors.conf"
        ln -sf "$COLORFUL_THEME_DIR/kitty.conf" "$HOME/.config/kitty/current-theme.conf"
        sed -i 's/Theme=com.obsproject.Yami.Acri/Theme=com.obsproject.colorful/g' "$HOME/.config/obs-studio/user.ini"
        ln -sf "$COLORFUL_THEME_DIR/rofi.rasi" "$HOME/.config/rofi/colors.rasi"
        ln -sf "$COLORFUL_THEME_DIR/waybar.css" "$HOME/.config/waybar/colors.css"

        dunstify "Theme Selector" "$SELECTED_THEME theme selected" -i "$COLOR_ICON"
    fi

    dunstctl reload
    kitty +kitten themes --reload-in=all
    # killall -SIGUSR1 kitty 2>/dev/null
    spicetify watch -s 2>&1 | sed "/Reloaded Spotify/q"
    pkill -SIGUSR2 waybar
fi
