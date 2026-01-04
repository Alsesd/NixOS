{pkgs, ...}: {
  imports = [
    ./toggle-tray.nix
    ./plug.nix
    ./wallpaper-engine.nix
  ];
}
