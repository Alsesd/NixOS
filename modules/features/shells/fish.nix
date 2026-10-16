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
          nixos-update = "cd /home/${vars.username}/.config/nixos && nix flake update && git add -A && git commit -m 'update' && nh os boot";

          docker-pyinstaller = "docker run -v \$PWD:/src/ cdrx/pyinstaller-windows pyinstaller --onefile";
        };

        configFile.content = ''
          # Disable default welcome greeting
          set -g fish_greeting

          # Ensure plugin vendor paths are in autoload paths for subshells/prompts
          for p in ${pkgs.fishPlugins.tide} ${pkgs.fishPlugins.autopair} ${pkgs.fishPlugins.done}
            if test -d $p/share/fish/vendor_functions.d
              set -p fish_function_path $p/share/fish/vendor_functions.d
            end
            if test -d $p/share/fish/vendor_completions.d
              set -p fish_complete_path $p/share/fish/vendor_completions.d
            end
          end

          # nix-your-shell integration for fish
          if command -q nix-your-shell
            nix-your-shell fish | source
          end
        '';
      };
    };
  };
}
