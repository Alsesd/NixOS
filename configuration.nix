{
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

    ./home-module/terminal.nix
  ];
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;
  programs.zsh.enable = true;

  environment.systemPackages = with pkgs; [
    wget
    git
    ventoy-full
    usbutils
    docker
    fuse
    fuse3
  ];

  hardware.cpu.intel.updateMicrocode = true;
  powerManagement.cpuFreqGovernor = "performance";
  xdg.autostart.enable = true;
  security.polkit.enable = true;

  virtualisation.docker.enable = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_zen;
  boot.blacklistedKernelModules = ["psmouse"];

  networking.hostName = "nixos";

  nix.settings.experimental-features = ["nix-command" "flakes"];

  system.stateVersion = "26.05";
}
