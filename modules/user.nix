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
      extraGroups = [
        "networkmanager"
        "wheel"
        "video"
        "input"
        "plugdev"
      ];
      shell = pkgs.fish;
    };
    time.timeZone = "Europe/Kiev";

    # 2. HOME MANAGER CONFIGURATION
    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      backupFileExtension = "backup";

      users.${vars.username} = {
        home = {
          inherit (vars) username stateVersion;
          homeDirectory = "/home/${vars.username}";

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
            fuse
            fuse3
            htop
            nvtopPackages.nvidia

            anytype
            anydesk
            antigravity-cli
            nodejs_26
          ];
        };
      };
    };
  };
}
