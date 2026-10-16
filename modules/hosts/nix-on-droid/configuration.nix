{
  flake.nixOnDroidModules.nixOnDroidConfiguration = {
    pkgs,
    ...
  }: {
    # ============================================================================
    # NIX-ON-DROID SYSTEM CONFIGURATION
    # ============================================================================

    # Core CLI packages installed in the environment
    environment.packages = with pkgs; [
      # Core CLI & shell utilities
      vim
      git
      curl
      wget
      htop
      tmux
      ripgrep
      fd
      bat
      eza

      # Shell
      fish
    ];

    # Backup etc files instead of failing to activate generation if a file already exists in /etc
    environment.etcBackupExtension = ".bak";

    # Set default user login shell
    user.shell = "${pkgs.fish}/bin/fish";

    # Flake support in Nix-on-Droid
    nix.extraOptions = ''
      experimental-features = nix-command flakes
    '';

    # State version for Nix-on-Droid
    system.stateVersion = "24.05";

    # ============================================================================
    # HOME-MANAGER INTEGRATION
    # ============================================================================
    home-manager = {
      backupFileExtension = "hm-bak";
      useGlobalPkgs = true;

      config = {
        home.stateVersion = "24.05";

        # Fish shell configuration
        programs.fish = {
          enable = true;
          shellAliases = {
            ls = "eza";
            ll = "eza -la";
            update = "nix-on-droid switch --flake ~/.config/nixos#default";
          };
        };
      };
    };
  };
}
