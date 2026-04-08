{
  pkgs,
  # inputs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    alejandra
    statix
    deadnix
    zsh-nix-shell
    direnv
    nix-direnv
    nixd
  ];
  nix = {
    gc = {
      automatic = true;
      persistent = true;
      dates = "weekly";
      options = "--delete-generations +5";
    };
    optimise = {
      automatic = true;
      dates = "daily";
    };
    settings = {
      fallback = true;
      download-buffer-size = 134217728;
      auto-optimise-store = true;
      substituters = [
        "https://cache.nixos.org/"
        "https://cuda-maintainers.cachix.org"
        "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVwr7uESIPE="
      ];
    };
  };

  # system.autoUpgrade = {
  #   enable = true;
  #   flake = inputs.self.outPath;
  #   flags = [
  #     "--update-input"
  #     "nixpkgs"
  #     "--update-input"
  #     "home-manager"
  #     "--commit-lock-file"
  #     "-L"
  #   ];

  # dates = "02:00";
  # randomizedDelaySec = "45min";
  # };
}
