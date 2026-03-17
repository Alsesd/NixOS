{pkgs, ...}: let
  ventoy-plugson = pkgs.writeShellScriptBin "ventoy-plugson" ''
    exec ${pkgs.ventoy}/share/ventoy/VentoyPlugson.sh "$@"
  '';
in {
  environment.systemPackages = [
    ventoy-plugson
  ];
}
