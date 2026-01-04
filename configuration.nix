{
  inputs,
  config,
  pkgs,
  ...
}: {
  imports = [
    ./system_info/hardware-configuration.nix
    ./system_info/users.nix
    ./system_info/gpu-wayland-env.nix
    ./system_info/network.nix
    ./system_info/greetd.nix

    ./utility/stylix.nix
    ./utility/nix.nix

    ./utility/niri-session.nix

    ./scripts/active.nix
  ];
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;
  
  programs.zsh.enable = true;

  environment.systemPackages = with pkgs; [
    wget
    git
    base16-schemes
    ventoy-full
    usbutils
    udiskie

    direnv
    nix-direnv
    docker
    fuse
    fuse3
    gamescope
    ayugram-desktop
    easyeffects
    nixd

    protonup-qt # ← Manage Proton-GE versions
  ];

  
  hardware.cpu.intel.updateMicrocode = true;
  powerManagement.cpuFreqGovernor = "performance";

  security.polkit.enable = true;

  virtualisation.docker.enable = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_zen; 
  boot.blacklistedKernelModules = [ "psmouse" ];
  
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.permittedInsecurePackages = [
    "archiver-3.5.1"
    "ventoy-1.1.07"
  ];
  
  networking.hostName = "nixos";

  nix.settings.experimental-features = ["nix-command" "flakes"];

  system.stateVersion = "25.05";
}
