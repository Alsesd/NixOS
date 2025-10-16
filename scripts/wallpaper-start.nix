{pkgs, ...}: let
  wallpaper-start = pkgs.writeShellScriptBin "wallpaper-start" ''
        #!/usr/bin/env bash

        # Function to set wallpaper using swaybg
        set_wallpaper() {
          local output=$1
          local wallpaper_path=$2
          swaybg -o "$output" -m fill -i "$wallpaper_path" &
        }

        # Get the list of connected outputs
       outputs=$(niri msg --json outputs | jq -r '.[] .name')
        # Define your wallpaper path here
        wallpaper_eDP="$HOME/.config/nixos/utility/wallpaper1.png"
    wallpaper_HDMA="$HOME/.config/nixos/utility/wallpaper2.png"


        # Set wallpaper for each connected output
        for output in $outputs; do
          set_wallpaper "$output" "$wallpaper_eDP"
        done

        wait
  '';
in {
  environment.systemPackages = [
    wallpaper-start
  ];
}
