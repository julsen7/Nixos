#!/usr/bin/env bash

WALLPAPER_DIR="$HOME/wallpaper"

if [[ ! -d "$WALLPAPER_DIR" ]]; then
    dunstify "Wallpaper Error" "Folder $WALLPAPER_DIR does not exist!" -u critical
    exit 1
fi

shopt -s nullglob
WALLPAPERS=( "$WALLPAPER_DIR"/*.{png,jpg,jpeg,webp} )
shopt -u nullglob

if (( ${#WALLPAPERS[@]} == 0 )); then
    dunstify "Wallpaper Error" "Folder $WALLPAPER_DIR does not contain any images!" -u critical
    exit 1
fi

menu_items=""
for full_path in "${WALLPAPERS[@]}"; do
    basename=$(basename "$full_path")
    menu_items+="${basename}\0icon\x1f${full_path}\n"
done

SELECTED_NAME=$(echo -e "$menu_items" | rofi -dmenu)

if [[ -n "$SELECTED_NAME" ]]; then
    WALLPAPER_PATH="$WALLPAPER_DIR/$SELECTED_NAME"
    
    cp "$WALLPAPER_PATH" "$HOME/.config/hypr/current_wallpaper"

    matugen image "$WALLPAPER_PATH" --source-color-index 0 >/dev/null 2>&1

    COLORFUL_THEME_DIR="$HOME/themes/colorful"

    cp -f "$COLORFUL_THEME_DIR/dunstrc" "$HOME/.config/dunst/dunstrc"
    cp -f "$COLORFUL_THEME_DIR/hypr.lua" "$HOME/.config/hypr/colors.lua"
    cp -f "$COLORFUL_THEME_DIR/hypr.conf" "$HOME/.config/hypr/colors.conf"
    cp -f "$COLORFUL_THEME_DIR/kitty.conf" "$HOME/.config/kitty/current-theme.conf"
    sed -i 's/Theme=com.obsproject.Yami.Acri/Theme=com.obsproject.colorful/g' "$HOME/.config/obs-studio/user.ini"
    cp -f "$COLORFUL_THEME_DIR/rofi.rasi" "$HOME/.config/rofi/colors.rasi"
    cp -f "$COLORFUL_THEME_DIR/waybar.css" "$HOME/.config/waybar/colors.css"

    chmod +w "$HOME/.config/dunst/dunstrc" \
             "$HOME/.config/hypr/colors.lua" \
             "$HOME/.config/hypr/colors.conf" \
             "$HOME/.config/kitty/current-theme.conf" \
             "$HOME/.config/rofi/colors.rasi" \
             "$HOME/.config/waybar/colors.css"

    dunstctl reload
    kitty +kitten themes --reload-in=all
    # killall -SIGUSR1 kitty 2>/dev/null
    spicetify watch -s 2>&1 | sed "/Reloaded Spotify/q"
    pkill -SIGUSR2 waybar

    dunstify "Wallpaper" "Set $SELECTED_NAME as wallpaper" -i "$WALLPAPER_PATH"
fi
