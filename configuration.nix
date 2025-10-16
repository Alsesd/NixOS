# Add these lines to your configuration.nix
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
    ./system_info/genv.nix

    ./utility/gc.nix
    ./utility/xwayland.nix
    ./utility/stylix.nix
    ./utility/autoupgrade.nix

    ./scripts/active.nix
  ];

  programs.niri.enable = true;

  # Create a wrapper script for xdg-open to handle directories
  environment.systemPackages = with pkgs; [
    wget
    git
    alejandra # Nix formatter
    nixd # Nix language server
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
  ];

  powerManagement.cpuFreqGovernor = "performance";
  security.polkit.enable = true;
  services.displayManager.ly.enable = true;

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.permittedInsecurePackages = [
    "archiver-3.5.1"
    "ventoy-1.1.07"
  ];

  nix.settings.experimental-features = ["nix-command" "flakes"];

  system.stateVersion = "25.05";
}
