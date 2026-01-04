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

    ./utility/stylix.nix
    ./utility/nix.nix
    ./scripts/active.nix
    ./desktop/default.nix
  ];
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;
  programs.zsh.enable = true;

  environment.systemPackages = with pkgs; [
    wget
    git
    ventoy-full
    usbutils
    udiskie

    direnv
    nix-direnv
    docker
    fuse
    fuse3
 # ← Manage Proton-GE versions
  ];

  
  hardware.cpu.intel.updateMicrocode = true;
  powerManagement.cpuFreqGovernor = "performance";
  xdg.autostart.enable = true;
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
