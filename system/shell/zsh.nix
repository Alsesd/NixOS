{
  config,
  pkgs,
  vars,
  ...
}: let
  colors = config.lib.stylix.colors;
in {
  home-manager.users.${vars.username} = {
    programs.zsh = {
      enable = true;
      autocd = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;

      shellAliases = {
        list-nixos-generations = "nixos-rebuild list-generations";
        ip-show = "curl ifconfig.me";

        my-system = "cd /home/alsesd/.config/nixos";

        nixos-switch = "sudo nixos-rebuild switch --flake ~/.config/nixos#myNixos";
        nixos-test = "sudo nixos-rebuild test --flake ~/.config/nixos#myNixos";

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
}
