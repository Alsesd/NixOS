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

    ./utility/gc.nix
    ./utility/stylix.nix
    ./utility/autoupgrade.nix
    ./utility/niri-session.nix

    ./scripts/active.nix
    ./fixes.nix
  ];
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;
  programs.niri.enable = true;
  programs.zsh.enable = true;

  environment.systemPackages = with pkgs; [
    wget
    git
    base16-schemes
    ventoy-full
    usbutils
    udiskie
    xfce.thunar
    xfce.thunar-volman
    xfce.thunar-archive-plugin
    direnv
    nix-direnv
    docker
    fuse
    fuse3
    gamescope
    ayugram-desktop
    pkgs.easyeffects

    # Gaming utilities
    protonup-qt # ← Manage Proton-GE versions
  ];

  

  powerManagement.cpuFreqGovernor = "performance";

  security.polkit.enable = true;

  virtualisation.docker.enable = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_zen; 

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.permittedInsecurePackages = [
    "archiver-3.5.1"
    "ventoy-1.1.07"
  ];
  


  nix.settings.experimental-features = ["nix-command" "flakes"];

  system.stateVersion = "25.05";
}
