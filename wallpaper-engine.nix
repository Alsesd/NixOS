{pkgs, ...}: let
  set-wallpapers = pkgs.writeShellScriptBin "set-wallpapers" ''
    #!/usr/bin/env bash

    ${pkgs.linux-wallpaperengine}/bin/linux-wallpaperengine --screen-root eDP-1 --bg 1959960111 --screen-root HDMI-A-4 --bg 1860216103

    wait
  '';
in {
  environment.systemPackages = [
    set-wallpapers
  ];

  systemd.user.services.wallpaper-engine = {
    description = "Wallpaper Engine Service";
    after = ["graphical-session.target"];
    partOf = ["graphical-session.target"];
    wantedBy = ["graphical-session.target"];

    serviceConfig = {
      Type = "forking";
      ExecStart = "${set-wallpapers}/bin/set-wallpapers";
      Restart = "on-failure";
      RestartSec = "10s";
    };
  };
}
