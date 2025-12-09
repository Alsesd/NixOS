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
    # ./steam-gaming.nix # ← NEW: Gaming configuration

    ./utility/gc.nix
    ./utility/stylix.nix
    ./utility/autoupgrade.nix
    ./utility/niri-session.nix

    ./scripts/active.nix
    ./ds.nix
  ];

  programs.niri.enable = true;
  programs.zsh.enable = true;
  users.users.alsesd = {
    shell = pkgs.zsh;
  };
  environment.systemPackages = with pkgs; [
    wget
    git
    base16-schemes
    cava
    ventoy-full
    xdg-utils
    networkmanager
    usbutils
    udiskie
    pkgs.mesa
    xfce.thunar
    xfce.thunar-volman
    xfce.thunar-archive-plugin
    direnv
    nix-direnv
    docker
    libGL
    libGLU
    mesa
    vulkan-loader
    libglvnd
    fuse
    fuse3
    gamescope
    ayugram-desktop

    # Gaming utilities
    protonup-qt # ← Manage Proton-GE versions
    mangohud
  ];

  services.tailscale.enable = true;

  powerManagement.cpuFreqGovernor = "performance";

  security.polkit.enable = true;

  virtualisation.docker.enable = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_zen; # Zen kernel is good for gaming

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.permittedInsecurePackages = [
    "archiver-3.5.1"
    "ventoy-1.1.07"
  ];
  networking.hostName = "nixos";
  nix.settings = {
    download-buffer-size = 134217728; # 128 MB
    # Additional Nix optimization for gaming
    auto-optimise-store = true;
  };

  nix.settings.experimental-features = ["nix-command" "flakes"];

  system.stateVersion = "25.05";
}
