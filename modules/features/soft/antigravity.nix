{ inputs, ... }: {
  flake.nixosModules.antigravity = { pkgs, ... }:
    let
      system = pkgs.stdenv.hostPlatform.system;
      agpkgs = inputs.antigravity-nix.packages.${system};
    in
    {
      environment.systemPackages = [
        # CLI binary (no overrides needed)
        agpkgs.google-antigravity-cli

        # Main app with overrides
        (agpkgs.default.override {
          useFHS = false;
          useUserProfile = false;
          browserPkg = pkgs.chromium;
        })
      ];
    };
}
