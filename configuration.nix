{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./system_info/default.nix

    ./utility/stylix.nix
    ./utility/nix.nix

    ./scripts/active.nix

    ./graphics/default.nix
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

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_zen;
  boot.blacklistedKernelModules = ["psmouse"];

  networking.hostName = "nixos";

  nix.settings.experimental-features = ["nix-command" "flakes"];

  system.stateVersion = "26.05";
}
