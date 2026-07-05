{ config, pkgs, ... }:

{
  # Benutzer- und Verzeichnis-Details
  home.username = "julsen";
  home.homeDirectory = "/home/julsen";

  # Pakete, die NUR für deinen User installiert werden (keine System-Tools)
  home.packages = with pkgs; [
    fastfetch
    kitty       # Dein Terminal-Emulator
    rofi        # Ein App-Launcher für Hyprland
    waybar      # Die Statusleiste für Hyprland
    git         # Versionsverwaltung
  ];

  # Programme, die eigene tiefergehende Konfigurationen über Nix erlauben
  programs.git = {
    enable = true;
    userName = "julsen7";
    userEmail = "deine-email@beispiel.de";
  };

  # Home-Manager soll sich selbst verwalten
  programs.home-manager.enable = true;

  # WICHTIG: Die Version, bei der du das System aufgesetzt hast.
  # Ändere diese Zahl nicht, es sei denn, das Home-Manager-Handbuch sagt es dir.
  home.stateVersion = "24.11"; 
}
