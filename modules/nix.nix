{
  pkgs,
  inputs,
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
      dates = "weekly";
      options = "--delete-generations +5";
    };
    optimise = {
      automatic = true;
      dates = "daily";
    };
    timersConfig.Persistent = true;
    settings = {
      download-buffer-size = 134217728;
      auto-optimise-store = true;
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
