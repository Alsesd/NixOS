{pkgs, ...}: let
  wallpaper-start = pkgs.writeShellScriptBin "wallpaper-start" ''
    #!/usr/bin/env bash

    # Wait for outputs to be available
    sleep 2

    # Kill any existing swaybg instances
    ${pkgs.procps}/bin/pkill swaybg || true

    # Set wallpapers
    ${pkgs.swaybg}/bin/swaybg -o "eDP-1" -i "$w_eDP" -m fill &
    ${pkgs.swaybg}/bin/swaybg -o "HDMI-A-4" -i "$w_HDMI" -m fill &

    wait
  '';
in {
  environment.systemPackages = [
    wallpaper-start
  ];

  # User service to set wallpaper on startup
  systemd.user.services.wallpaper-start = {
    description = "Set wallpaper on start-up";
    wantedBy = ["graphical-session.target"];
    after = ["graphical-session.target"];

    serviceConfig = {
      Type = "simple";
      ExecStart = "${wallpaper-start}/bin/wallpaper-start";
      Restart = "on-failure";
      RestartSec = "2s";
      # Pass environment variables to the service
      Environment = [
        "w_eDP=%h/.config/nixos/utility/wallpaper2.png"
        "w_HDMI=%h/.config/nixos/utility/wallpaper1.png"
      ];
    };
  };
}
