{pkgs, ...}: let
  wallpaper-start = pkgs.writeShellScriptBin "wallpaper-start" ''
        #!/usr/bin/env bash

    w_eDP="$HOME/.config/nixos/utility/wallpaper1.png"
    w_HDMA="$HOME/.config/nixos/utility/wallpaper2.png"

        # Function to set wallpaper using swaybg
        set_wallpaper(w_eDP, w_HDMA) {
        swaybg -o "eDP-1" -i "$w_eDP" -m fill &&
        swaybg -o "HDMI-A-1" -i "$w_HDMA" -m fill
        }

         # Initial wallpaper setup
        w_eDP="$HOME/.config/nixos/utility/wallpaper1.png"
        w_HDMA="$HOME/.config/nixos/utility/wallpaper2.png"

        wait
  '';
in {
  environment.systemPackages = [
    wallpaper-start
  ];

  #user service to set wallpaper on startup

  systemd.user.services.wallpaper-start = {
    description = "Set wallpaper on star-up";
    wantedBy = ["default.target"];
    after = ["graphical-session.target"];
    serviceConfig = {
      ExecStart = "${wallpaper-start}";
      Restart = "on-failure";
      RestartSec = 10;
    };
  };
}
