# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running 'nixos-help').
{
  inputs,
  config,
  pkgs,
  ...
}: {
  imports = [
    ./modules/hardware-configuration.nix
    ./modules/users.nix
    ./modules/nvidia.nix
    ./modules/gc.nix
    ./modules/sddm.nix
    ./modules/xwayland.nix
    ./modules/stylix.nix
    ./modules/autoupgrade.nix
  ];
  services.gvfs.enable = true;
  programs.xfconf.enable = true;
  programs.thunar.enable = true;
  xdg.mime.defaultApplications = {
    "inode/directory" = ["thunar.desktop"];
  };
  programs.nix-ld.enable = true;
  programs.nix-ld.package = pkgs.nix-ld-rs; # or pkgs.nix-ld
  powerManagement.cpuFreqGovernor = "performance";
  security.polkit.enable = true;
  programs.niri.enable = true;
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-hyprland
    ];
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelPackages = pkgs.linuxPackages_zen; # preferred shorthand

  networking.hostName = "nixos";

  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Kyiv";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "uk_UA.UTF-8";
    LC_IDENTIFICATION = "uk_UA.UTF-8";
    LC_MEASUREMENT = "uk_UA.UTF-8";
    LC_MONETARY = "uk_UA.UTF-8";
    LC_NAME = "uk_UA.UTF-8";
    LC_NUMERIC = "uk_UA.UTF-8";
    LC_PAPER = "uk_UA.UTF-8";
    LC_TELEPHONE = "uk_UA.UTF-8";
    LC_TIME = "uk_UA.UTF-8";
  };
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.permittedInsecurePackages = [
    "archiver-3.5.1"
    "ventoy-1.1.07"
  ];
  nix.settings.experimental-features = ["nix-command" "flakes"];

  environment.systemPackages = with pkgs; [
    wget
    git
    file-roller
    alejandra # Nix formatter
    nixd # Nix language server
    base16-schemes
    cava
    tree
    niri
    xwayland-satellite
    fuzzel
    xfce.thunar
    ventoy-full
    python3
    slack
    xdg-utils
    vscode
  ];
  system.stateVersion = "25.05"; # Did you read the comment?
  environment.variables = {
    GDK_BACKEND = "wayland,x11,*";
    QT_QPA_PLATFORM = "wayland;xcb";
    CLUTTER_BACKEND = "wayland";
    XDG_CURRENT_DESKTOP = "niri";
    XDG_SESSION_DESKTOP = "niri";
    XDG_SESSION_TYPE = "wayland";
    LIBVA_DRIVER_NAME = "nvidia";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    NVD_BACKEND = "direct";
    GSK_RENDERER = "ngl";
    GBM_BACKEND = "nvidia-drm";
  };
}
