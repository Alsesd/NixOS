{pkgs, ...}: let
  set-wallpapers = pkgs.writeShellScriptBin "set-wallpapers" ''
    #!bin/usr/env bash

    exec linux-wallpaperengine --screen-root eDP-1 1959960111 &
    exec linux-wallpaperengine --screen-root HDMI-A-4 1860216103 &
  '';
in {
  environment.systemPackages = [
    set-wallpapers
  ];

  systemd.user.services.wallpaper-engine = {
    description = "Wallpaper Engine Service using Stylix";
    after = ["display-manager.service"];
    wantedBy = ["graphical-session.target"];

    serviceConfig = {
      Type = "simple";
      ExecStart = "set-wallpapers";
      Restart = "on-failure";
      RestartSec = "10s";
    };
  };
}
