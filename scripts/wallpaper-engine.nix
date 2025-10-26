{pkgs, ...}: let
  set-wallpapers = pkgs.writeShellScriptBin "set-wallpapers" ''
    #!/usr/bin/env bash

    export MPV_NO_HWDEC=1

    ${pkgs.linux-wallpaperengine}/bin/linux-wallpaperengine --screen-root eDP-1 --bg 1959960111 --screen-root HDMI-A-4 --bg 1860216103

    wait
  '';
in {
  environment.systemPackages = [
    set-wallpapers
  ];
}
