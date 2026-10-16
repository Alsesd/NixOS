{
  flake.nixosModules.system-tweaks = {vars, ...}: {
    services = {
      earlyoom = {
        enable = true;
        freeMemThreshold = 5;
        freeSwapThreshold = 5;
        enableNotifications = true;
        extraArgs = [
          "--prefer"
          "(chrome|firefox|electron|steam|java|python|node|rustc)"
          "--avoid"
          "(systemd|ssh|greetd|niri|pipewire|wireplumber)"
        ];
      };

      fstrim = {
        enable = true;
        interval = "weekly";
      };

      acpid.enable = true;
      upower.enable = true;
    };

    home-manager.users.${vars.username} = {
      programs.direnv = {
        enable = true;
        nix-direnv.enable = true;
        enableFishIntegration = true;
        config = {
          global = {
            warn_timeout = "30s";
            hide_env_diff = true;
          };
        };
      };
    };

    boot.tmp.useTmpfs = true;
    boot.tmp.tmpfsSize = "25%";
  };
}
