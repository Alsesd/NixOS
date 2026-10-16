{
  flake.nixosModules.fish = {
    pkgs,
    vars,
    inputs,
    ...
  }: {
    # System-level fish enabling: registers fish in /etc/shells, sets up completions
    programs.fish.enable = true;

    home-manager.users.${vars.username} = {
      imports = [
        inputs.wrapper-modules.homeModules.fish
      ];

      home.packages = with pkgs; [
        nix-your-shell
      ];

      wrappers.fish = {
        enable = true;

        plugins = with pkgs.fishPlugins; [
          tide
          autopair
          done
        ];

        shellAliases = {
          list-nixos-generations = "nixos-rebuild list-generations";
          ip-show = "curl ifconfig.me";

          my-system = "cd /home/${vars.username}/.config/nixos";
          nixos-update = "cd /home/${vars.username}/.config/nixos && nix flake update && git add -A && git commit -m \"update\" && nh os boot";

          docker-pyinstaller = "docker run -v $PWD:/src/ cdrx/pyinstaller-windows \"pyinstaller --onefile\"";
        };

        configFile.content = ''
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
