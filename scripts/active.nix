{pkgs, ...}: {
  imports = [
    ./toggle-tray.nix
    ./plug.nix
    ./xdg-file-manager.nix
    ./wallpaper-engine.nix
  ];
}
