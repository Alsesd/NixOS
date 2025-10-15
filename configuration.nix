# Add these lines to your configuration.nix
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
  programs.niri.enable = true;
  # File manager configuration
  xdg.mime.defaultApplications = {
    "inode/directory" = ["thunar.desktop"];
  };

  environment.sessionVariables = {
    DEFAULT_FILE_MANAGER = "thunar";
    FILE_MANAGER = "thunar";
  };

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
    (pkgs.writeShellScriptBin "xdg-file-manager" ''
      exec ${pkgs.xfce.thunar}/bin/thunar "$@"
    '')
  ];

  programs.nix-ld.enable = true;
  programs.nix-ld.package = pkgs.nix-ld-rs;

  powerManagement.cpuFreqGovernor = "performance";
  security.polkit.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
    ];
    config.common.default = "*";
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;

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

  system.stateVersion = "25.05";

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
