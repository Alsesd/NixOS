{pkgs, ...}: {
  imports = [
    ./toggle-tray.nix
    ./xdg-file-manager.nix
    ./plug.nix
    ./wallpaper-complete.nix # Use the new complete wallpaper solution
    ./early-monitor.nix
  ];
}
