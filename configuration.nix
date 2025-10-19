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
    ./system_info/wayland.nix
    ./system_info/greetd.nix
    ./system_info/xdg.nix
    ./system_info/network.nix

    ./utility/gc.nix
    ./utility/stylix.nix
    ./utility/autoupgrade.nix
    ./utility/niri-session.nix

    ./scripts/active.nix
    ./wallpaper-engine.nix
  ];

  programs.niri.enable = true;
  # Audio
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # RTKit для audio priority
  security.rtkit.enable = true;

  # Wi-Fi fixes
  hardware.firmware = [pkgs.linux-firmware];

  boot.extraModprobeConfig = ''
    # Intel Wi-Fi optimizations
    options iwlwifi power_save=0 swcrypto=1 11n_disable=8
    options iwlmvm power_scheme=1
    options r8169 aspm=0
  '';

  # NetworkManager settings
  networking.networkmanager = {
    enable = true;
    wifi.powersave = false;
  };

  # Альтернативно в kernel parameters:
  boot.kernelParams = [
    "pcie_aspm=off" # Или только для конкретного устройства
  ];

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
    linux-wallpaperengine
  ];

  powerManagement.cpuFreqGovernor = "performance";
  security.polkit.enable = true;

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "nixos";

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.permittedInsecurePackages = [
    "archiver-3.5.1"
    "ventoy-1.1.07"
  ];

  nix.settings.experimental-features = ["nix-command" "flakes"];

  system.stateVersion = "25.05";
}
