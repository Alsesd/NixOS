{
  inputs,
  config,
  pkgs,
  ...
}: {
  imports = [
    ./system_info/hardware-configuration.nix
    ./system_info/users.nix
    ./system_info/nvidia.nix
    ./system_info/wayland.nix
    ./system_info/greetd.nix
    ./system_info/xdg.nix
    ./fixes.nix # ← НОВЫЙ ФАЙЛ

    ./utility/gc.nix
    ./utility/stylix.nix
    ./utility/autoupgrade.nix
    ./utility/niri-session.nix

    ./scripts/active.nix
  ];

  programs.niri.enable = true;
  environment.systemPackages = with pkgs; [
    wget
    git
    alejandra
    nixd
    base16-schemes
    cava
    tree
    ventoy-full
    python3
    xdg-utils
    networkmanager
    usbutils
    udiskie
    pkgs.mesa
    xfce.thunar
    xfce.thunar-volman
    xfce.thunar-archive-plugin
    pkgs.set-wallpapers
  ];

  powerManagement.cpuFreqGovernor = "performance";
  security.polkit.enable = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_zen;

  networking.hostName = "nixos";

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.permittedInsecurePackages = [
    "archiver-3.5.1"
    "ventoy-1.1.07"
  ];

  nix.settings.experimental-features = ["nix-command" "flakes"];

  system.stateVersion = "25.05";
}
