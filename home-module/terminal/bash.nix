{
  config,
  pkgs,
  ...
}: {
  programs.bash = {
    enable = true;
    enableCompletion = true;
    shellAliases = {
      # NixOS & Sistema
      list-nixos-generations = "nixos-rebuild list-generations";
      flake-check = "nix flake check";
      size = "du -ah --max-depth=1 | sort -h";
      ip-show = "curl ifconfig.me";

      #Main system build
      nixos-build = "sudo nixos-rebuild build --upgrade --flake ~/.config/nixos/.#myNixos";
      nixos-test = "sudo nixos-rebuild test --upgrade --flake ~/.config/nixos/.#myNixos";
      nixos-switch = "sudo nixos-rebuild switch --upgrade --flake ~/.config/nixos/.#myNixos";

      #Test system build
      test-build = "sudo nixos-rebuild build -I nixos-config=/home/alsesd/test/configuration.nixe --flake ./test/#myNixos";
      test-test = "sudo nixos-rebuild test -I nixos-config=/home/alsesd/test/configuration.nix --flake ./test/#myNixos";
      test-switch = "sudo nixos-rebuild switch -I nixos-config=/home/alsesd/test/configuration.nix --flake ./test/#myNixos";
      ngc-all = "sudo nix-collect-garbage -d";

      arena-bot = "cd /home/alsesd/GoogleBot && source ./googlebot/bin/activate && python main.py";
    };
    bashrcExtra = ''
      eval "$(starship init bash)"
      export XCURSOR_THEME=~/.icons/macOS
      export XCURSOR_SIZE=24
      export PATH="~/.scripts:$PATH"
      export PATH="~/.scripts/nixos:$PATH"
      export PATH="~/.scripts/hypr:$PATH"

    '';
  };
}
