{pkgs, ...}: {
  home.packages = [pkgs.pay-respects];
  programs.zsh = {
    enable = true;
    autocd = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      # NixOS & Sistema
      list-nixos-generations = "nixos-rebuild list-generations";
      ip-show = "curl ifconfig.me";

      #Main system build
      nixos-build = "sudo nixos-rebuild build --upgrade --flake ~/.config/nixos/.#myNixos";
      nixos-test = "sudo nixos-rebuild test --upgrade --flake ~/.config/nixos/.#myNixos";
      nixos-switch = "sudo nixos-rebuild switch --upgrade --flake ~/.config/nixos/.#myNixos";

      #Test system build
      test-build = "sudo nixos-rebuild build -I nixos-config=/home/alsesd/test/configuration.nix --flake ./test/#myNixos";
      test-test = "sudo nixos-rebuild test -I nixos-config=/home/alsesd/test/configuration.nix --flake ./test/#myNixos";
      test-switch = "sudo nixos-rebuild switch -I nixos-config=/home/alsesd/test/configuration.nix --flake ./test/#myNixos";
      ngc-all = "sudo nix-collect-garbage -d";

      #Shells
      my-system = "cd /home/alsesd/.config/nixos";
      python-shell = "nix develop /home/alsesd/.config/nixos#python";
      jupyter-shell = "nix develop /home/alsesd/.config/nixos#jupyter";
      docker-pyinstaller = "docker run -v \"$(pwd):/src/\" cdrx/pyinstaller-windows \"pyinstaller --onefile\"";
    };
    oh-my-zsh = {
      # "ohMyZsh" without Home Manager
      enable = true;
      plugins = ["git"];
      theme = "robbyrussell";
    };
    history.size = 10000;
  };
}
