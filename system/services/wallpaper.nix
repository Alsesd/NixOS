{pkgs, ...}: let
  set-wallpapers = pkgs.writeShellScriptBin "set-wallpapers" ''
    #!/usr/bin/env bash
    set -euo pipefail

    # Kill any existing swaybg instances
    ${pkgs.procps}/bin/pkill swaybg || true
    sleep 0.5

    # Wallpaper path
    WALLPAPER="$HOME/Pictures/NixWallBin.png"

    # Start single swaybg instance for all outputs
    ${pkgs.swaybg}/bin/swaybg -i "$WALLPAPER" -m fill &

    echo "Wallpaper set with swaybg"
  '';
in {
  environment.systemPackages = [
    set-wallpapers
    pkgs.swaybg
  ];
}
