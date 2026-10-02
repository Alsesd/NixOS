{ inputs, ... }: {
  flake.nixosModules.antigravity = { pkgs, ... }: {
    environment.systemPackages = [
      (inputs.antigravity-nix.packages.${pkgs.stdenv.hostPlatform.system}.google-antigravity-ide-no-fhs.override {
        browserPkg = pkgs.chromium;
        useUserProfile = false;
      })
    ];
  };
}
