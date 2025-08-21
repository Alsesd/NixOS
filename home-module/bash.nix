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
      nixos-switch = "sudo nixos-rebuild switch --upgrade --flake ~/.config/nixos/.#myNixos";
      nixos-test = "sudo nixos-rebuild test --upgrade --flake ~/.config/nixos/.#myNixos";
      ngc = "nix-collect-garbage";
      # Bluetooth
      auricolari-bt = "bluetoothctl connect B8:F8:BE:60:54:BE";
      dualsense-ps5 = "bluetoothctl connect 4C:B9:9B:10:B8:F9";
      disconnetti-bt = "bluetoothctl disconnect";
      # Wifi
      mostra-connessioni = "nmcli device wifi list";
      hotspot-telefono = "nmcli device wifi connect Light3r";
    };
    bashrcExtra = ''
      eval "$(starship init bash)"
      export XCURSOR_THEME=~/.icons/macOS
      export XCURSOR_SIZE=24
      export PATH="~/.scripts:$PATH"
      export PATH="~/.scripts/nixos:$PATH"
      export PATH="~/.scripts/hypr:$PATH"
    '';
    initExtra = ''
      # Only source hm-session-vars.sh if it exists
      if [ -f "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh" ]; then
        . "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
      fi
    '';
  };
}
