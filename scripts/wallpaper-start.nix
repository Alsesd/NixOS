{pkgs, ...}: let
  wallpaper-start = pkgs.writeShellScriptBin "wallpaper-start" ''
        #!/usr/bin/env bash

    w_eDP="$(find /home/alsesd/.config/nixos/utility/wallpaper2.*)"
    w_HDMI="$(find /home/alsesd/.config/nixos/utility/wallpaper1.*)"
        # Function to set wallpaper using swaybg

        swaybg -o "eDP-1" -i "$w_eDP" -m fill &
        swaybg -o "HDMI-A-4" -i "$w_HDMI" -m fill
        }


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
      RestartSec = 2;
    };
  };
}
