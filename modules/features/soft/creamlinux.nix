# modules/nixos/creamlinux.nix
{inputs, ...}: {
  flake.nixosModules.creamlinux = {pkgs, ...}: let
    unwrapped = import inputs.creamlinux-installer {inherit pkgs;};

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
