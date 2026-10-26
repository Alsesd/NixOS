# modules/nixos/creamlinux.nix
{...}: {
  flake.nixosModules.creamlinux = {pkgs, ...}: let
    unwrapped = import (pkgs.fetchFromGitHub {
      owner = "Novattz";
      repo = "creamlinux-installer";
      rev = "main"; # replace with commit hash to pin
      hash = "sha256-E8oJ073yhtFiCMVuixPvQbdYJNSTxu7ICTGMuq+jce8="; # paste hash from rebuild error
    }) {inherit pkgs;};

    creamlinux = pkgs.symlinkJoin {
      name = "creamlinux-installer";
      paths = [unwrapped];
      nativeBuildInputs = [pkgs.makeWrapper];
      postBuild = ''
        for bin in $out/bin/*; do
          wrapProgram "$bin" --set WEBKIT_DISABLE_DMABUF_RENDERER 1
        done
      '';
    };
  in {
    environment.systemPackages = [creamlinux];
  };
}
