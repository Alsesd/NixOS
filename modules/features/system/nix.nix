_: {
  flake.nixosModules.nix = {pkgs, ...}: {
    nix = {
      optimise = {
        automatic = true;
        dates = "daily";
      };
      settings = {
        experimental-features = [
          "nix-command"
          "flakes"
        ];
        fallback = true;
        download-buffer-size = 134217728;
        auto-optimise-store = true;
        substituters = [
          "https://cache.nixos.org/"
          "https://nix-community.cachix.org"
          "https://cache.nixos-cuda.org"
        ];
        trusted-public-keys = [
          "cache.nixos-org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
          "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M="
        ];
      };
    };

    environment.systemPackages = with pkgs; [
      alejandra
      statix
      deadnix
      nix-update
      nixd
      nil
    ];
  };
}
