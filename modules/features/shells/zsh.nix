{
  flake.nixosModules.zsh = {
    pkgs,
    vars,
    ...
  }: {
    programs.zsh.enable = true;

    home-manager.users.${vars.username} = {
      home.packages = with pkgs; [
        zsh-nix-shell
        nix-your-shell
      ];

      programs.zsh = {
        enable = true;
        autocd = true;
        enableCompletion = true;
        autosuggestion.enable = true;
        syntaxHighlighting.enable = true;

        shellAliases = {
          list-nixos-generations = "nixos-rebuild list-generations";
          ip-show = "curl ifconfig.me";

          my-system = "cd /home/${vars.username}/.config/nixos";
          nixos-update = "cd /home/${vars.username}/.config/nixos && nix flake update && git add -A && git commit -m \"update\" && nh os boot";

          docker-pyinstaller = "docker run -v \"$(pwd):/src/\" cdrx/pyinstaller-windows \"pyinstaller --onefile\"";
          js = "just ~/.config/nixos/";
        };

        oh-my-zsh = {
          enable = true;
          plugins = [
            "git"
            "sudo"
            "command-not-found"
          ];
        };
        initContent = ''
          # 1. Load the theme from Nix Store
          nix-your-shell zsh | source /dev/stdin

          source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme

          # 2. Load your config file (created by wizard)
          [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
        '';
        history = {
          size = 10000;
          path = "$HOME/.local/share/zsh/history";
        };
      };
    };
  };
}
