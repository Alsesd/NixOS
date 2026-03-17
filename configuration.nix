{pkgs, ...}: {
  imports = [
    ./system_info/default.nix

    ./utility/stylix.nix
    ./utility/nix.nix
    ./utility/perf_tweeks.nix

    ./scripts/active.nix

    ./graphics/default.nix
    ./test.nix
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
    nix-output-monitor
  ];
  hardware.cpu.intel.updateMicrocode = true;
  xdg.autostart.enable = true;
  security.polkit.enable = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelPackages = pkgs.linuxPackages_xanmod_latest;

  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 100;
    priority = 100; # always preferred over any disk swap
  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = false;
    gamescopeSession.enable = true;
    extraCompatPackages = with pkgs; [proton-ge-bin];
  };

  boot.blacklistedKernelModules = ["psmouse"];

  nix.settings.experimental-features = ["nix-command" "flakes"];
  system.stateVersion = "26.05";
}
