{pkgs, ...}: let
  xdg-file-manager = pkgs.writeShellScriptBin "xdg-file-manager" ''
    exec ${pkgs.thunar}/bin/thunar "$@"
  '';
in {
  environment.systemPackages = [
    xdg-file-manager
  ];
}
