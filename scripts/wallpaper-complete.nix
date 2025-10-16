{pkgs, ...}: let
  # Create the wallpaper script
  set-wallpapers = pkgs.writeShellScriptBin "set-wallpapers" ''
        #!/usr/bin/env bash

        # Kill any existing swaybg instances
        ${pkgs.procps}/bin/pkill -9 swaybg || true

        # Check if outputs exist
        if ! ${pkgs.niri}/bin/niri msg outputs &>/dev/null; then
            echo "Niri not ready, waiting..."
            sleep 2
        fi

        # Set wallpapers for both monitors
    ${pkgs.swaybg}/bin/swaybg -o "eDP-1" -i "/home/alsesd/.config/nixos/utility/wallpaper2.png" -m fill &
        ${pkgs.swaybg}/bin/swaybg -o "HDMI-A-4" -i "/home/alsesd/.config/nixos/utility/wallpaper1.png" -m fill &


  '';
in {
  # Add packages
  environment.systemPackages = [
    set-wallpapers
    pkgs.swaybg
  ];

  # User service for wallpapers (runs after login)
  systemd.user.services.wallpaper-session = {
    Unit = {
      Description = "Set wallpapers for Niri session";
      After = ["graphical-session.target" "niri.service"];
      PartOf = ["graphical-session.target"];
    };

    Service = {
      Type = "forking";
      ExecStart = "${set-wallpapers}/bin/set-wallpapers";
      Restart = "on-failure";
      RestartSec = 3;
    };

    Install = {
      WantedBy = ["graphical-session.target"];
    };
  };

  # Also add to Niri autostart as backup
  # This will be configured in niri.nix
}
