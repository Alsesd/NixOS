{
  flake.nixosModules.fish = {
    pkgs,
    vars,
    ...
  }: {
    # System-level fish enabling: registers fish in /etc/shells, sets up completions
    programs.fish.enable = true;

    home-manager.users.${vars.username} = {
      home.packages = with pkgs; [
        nix-your-shell
      ];

      programs.fish = {
        enable = true;

        plugins = [
          {
            name = "tide";
            src = pkgs.fishPlugins.tide.src;
          }
          {
            name = "autopair";
            src = pkgs.fishPlugins.autopair.src;
          }
          {
            name = "done";
            src = pkgs.fishPlugins.done.src;
          }
        ];

        shellAliases = {
          list-nixos-generations = "nixos-rebuild list-generations";
          ip-show = "curl ifconfig.me";

          my-system = "cd /home/${vars.username}/.config/nixos";
          nixos-update = "cd /home/${vars.username}/.config/nixos && nix flake update && git add -A && git commit -m 'update' && nh os boot";

          docker-pyinstaller = "docker run -v \$PWD:/src/ cdrx/pyinstaller-windows pyinstaller --onefile";
        };

        interactiveShellInit = ''
          # Disable default welcome greeting
          set -g fish_greeting

          # nix-your-shell integration for fish
          if command -q nix-your-shell
            nix-your-shell fish | source
          end
        '';
      };
    };
  };
}
