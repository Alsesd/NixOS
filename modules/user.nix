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
    home-manager = {
      useGlobalPkgs = true;

      users.${vars.username} = {
        home = {
          inherit (vars) username;
          homeDirectory = "/home/${vars.username}";
          stateVersion = "26.05";
          pointerCursor.enable = true;

          packages = with pkgs; [
            discord
            qbittorrent
            vlc
            protonup-qt
            inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.twilight
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

            anytype
            anydesk

            nh
            antigravity-cli
          ];
        };

        gtk = {
          enable = true;
          gtk4.extraConfig = {
            gtk-application-prefer-dark-theme = 1;
          };
        };

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
  };
}
