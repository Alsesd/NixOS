{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.myMachineConfiguration = {pkgs, ...}: {
    _module.args = {
      inherit inputs self;
    };

    imports = [
      self.nixosModules.myMachineHardware
      self.nixosModules.user

      self.nixosModules.stylix
      # self.nixosModules.greetd
      self.nixosModules.niri
      self.nixosModules.noctalia
      self.nixosModules.noctalia-greeter

      self.nixosModules.kitty

      self.nixosModules.vars
      self.nixosModules.nvidia
      self.nixosModules.cpu

      self.nixosModules.zsh
      self.nixosModules.starship
      self.nixosModules.fastfetch

      self.nixosModules.systemTweaks
      self.nixosModules.wallpaper
      self.nixosModules.tailscale
      self.nixosModules.agydash

      self.nixosModules.zed
      self.nixosModules.steam
      self.nixosModules.antigravity

      inputs.stylix.nixosModules.stylix
      inputs.home-manager.nixosModules.home-manager
      inputs.noctalia-greeter.nixosModules.default
    ];
    home-manager.useGlobalPkgs = true;
    programs.zsh.enable = true;

    nixpkgs.config.allowUnfree = true;

    xdg.autostart.enable = true;
    security.polkit.enable = true;
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    boot.kernelPackages = pkgs.linuxPackages_latest;

    boot.blacklistedKernelModules = ["psmouse" "rtsx_pci"];
    boot.kernel.sysctl = {
      "fs.inotify.max_user_watches" = 524288;
      "fs.inotify.max_user_instances" = 1024;
    };
    virtualisation.docker.enable = true;

    zramSwap = {
      enable = true;
      algorithm = "zstd";
      memoryPercent = 50;
      priority = 100;
    };
    boot.kernelModules = ["typec"];
    boot.kernelParams = [
      "typec.usb_typec.delay=1000" # Increase timeout for USB-C controller
    ];
    security.rtkit.enable = true;
    networking.networkmanager.wifi = {
      powersave = false;
      scanRandMacAddress = false;
    };
    services.udev.extraRules = ''
      # NVIDIA device nodes - fix permissions
      KERNEL=="nvidia[0-9]*", MODE="0666"
      KERNEL=="nvidiactl", MODE="0666"
      KERNEL=="nvidia-uvm", MODE="0666"
      KERNEL=="nvidia-uvm-tools", MODE="0666"
      ACTION=="add|change", KERNEL=="event*", ATTRS{idVendor}=="3151", ATTRS{idProduct}=="5007", ENV{LIBINPUT_ACCEL_PROFILE}="flat"
    '';

    nix = {
      gc = {
        automatic = true;
        persistent = true;
        dates = "weekly";
        options = "--delete-generations +5";
      };
      optimise = {
        automatic = true;
        dates = "daily";
      };
      settings = {
        fallback = true;
        download-buffer-size = 134217728;
        auto-optimise-store = true;
        substituters = [
          "https://cache.nixos.org/"
          "https://nix-community.cachix.org"
          "https://cache.nixos-cuda.org" # <-- Replaced old cachix URL here
        ];
        trusted-public-keys = [
          "cache.nixos-org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
          "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M=" # <-- Updated key
        ];
      };
    };
    services.acpid.enable = true;

    services.upower.enable = true;
    services.blueman.enable = true;
    nix.settings.experimental-features = ["nix-command" "flakes"];
    system.stateVersion = "26.05";
  };
}
