# modules/user.nix
{
  flake.nixosModules.user = {
    pkgs,
    vars,
    inputs,
    ...
  }: {
    # 1. SYSTEM USER CREATION
    users.users.${vars.username} = {
      isNormalUser = true;
      description = "My User";
      extraGroups = ["networkmanager" "wheel" "video" "docker"];
      shell = pkgs.zsh;
    };
    time.timeZone = "Europe/Kiev";

    # 2. HOME MANAGER CONFIGURATION (Everything hidden right here!)
    home-manager.users.${vars.username} = {
      home.username = vars.username;
      home.homeDirectory = "/home/${vars.username}";
      home.stateVersion = "26.05";
      home.pointerCursor.enable = true;

      gtk = {
        enable = true;
        gtk4.extraConfig = {
          gtk-application-prefer-dark-theme = 1;
        };
      };

      home.packages = with pkgs; [
        discord
        qbittorrent
        vlc
        slack
        ayugram-desktop
        easyeffects
        protonup-qt
        inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.twilight
        inputs.freesmlauncher.packages.${system}.freesmlauncher
        gamemode
        wget
        git
        usbutils
        docker
        fuse
        fuse3
        htop
        nvtopPackages.nvidia
        alejandra
        statix
        deadnix
        zsh-nix-shell
        nixd
      ];

      programs.yazi = {
        enable = true;
        shellWrapperName = "y";
        enableZshIntegration = true;
        settings = {
          manager = {
            show_hidden = true;
            sort_by = "mtime";
          };
        };
      };
    };
  };
}
