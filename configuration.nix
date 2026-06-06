{pkgs, ...}: {
  imports = [
    ./system/hardware/default.nix
    ./system/network/default.nix
    ./system/desktop/default.nix
    ./system/shell/default.nix
    ./system/terminal/kitty.nix
    ./system/performance.nix
    ./system/fixes.nix
    ./system/services/default.nix
    ./modules/default.nix
    ./test.nix
  ];

  programs.zsh.enable = true;

  environment.systemPackages = with pkgs; [
    wget
    git
    usbutils
    docker
    fuse
    fuse3
    htop
    nvtopPackages.nvidia
  ];

  xdg.autostart.enable = true;
  security.polkit.enable = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_xanmod_latest;
  boot.blacklistedKernelModules = ["psmouse" "rtsx_pci"];
  boot.kernel.sysctl = {
    "fs.inotify.max_user_watches" = 524288;
    "fs.inotify.max_user_instances" = 1024;
  };

  virtualisation.docker.enable = true;
  users.users.alsesd.extraGroups = ["docker"];

  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 50;
    priority = 100;
  };

  nix.settings.experimental-features = ["nix-command" "flakes"];
  system.stateVersion = "26.05";
}
