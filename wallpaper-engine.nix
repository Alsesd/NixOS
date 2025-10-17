{pkgs, ...}: let
  set-wallpapers = pkgs.writeShellScriptBin "set-wallpapers" ''
    #!bin/usr/env bash

    exec linux-wallpaperengine --screen-root eDP-1 1959960111 &
    exec linux-wallpaperengine --screen-root HDMI-A-4 1860216103 &
  '';
in {
  systemd.service.wallpaper-engine = {
    description = "Wallpaper Engine Service using Stylix";
    after = ["network.target" "display-manager.service"];
    wantedBy = ["multi-user.target"];

    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.set-wallpapers}/bin/set-wallpaper";
      Restart = "on-failure";
      RestartSec = "10s";
    };
  };
}
