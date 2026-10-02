{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.myMachineConfiguration = {
    pkgs,
    vars,
    ...
  }: {
    _module.args = {
      inherit inputs self;
    };

    imports = [
      self.nixosModules.myMachineHardware
      self.nixosModules.user

      self.nixosModules.stylix
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
      self.nixosModules.audio
      self.nixosModules.mosh

      self.nixosModules.zed
      self.nixosModules.steam
      self.nixosModules.blip

      inputs.stylix.nixosModules.stylix
      inputs.home-manager.nixosModules.home-manager
      inputs.noctalia-greeter.nixosModules.default
    ];
    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      backupFileExtension = "backup";
    };

    programs.zsh.enable = true;
programs.mosh.enable = true;
    nixpkgs.config.allowUnfree = true;

    xdg.autostart.enable = true;
    security.polkit.enable = true;
    security.rtkit.enable = true;

    boot = {
      loader = {
        systemd-boot.enable = true;
        efi.canTouchEfiVariables = true;
      };

      kernelPackages = pkgs.linuxPackages_latest;

      blacklistedKernelModules = ["psmouse" "rtsx_pci" "i2c_nvidia_gpu" "ucsi_ccg"];
      kernel.sysctl = {
        "fs.inotify.max_user_watches" = 524288;
        "fs.inotify.max_user_instances" = 1024;
      };
    };

    virtualisation.docker.enable = true;

    zramSwap = {
      enable = true;
      algorithm = "zstd";
      memoryPercent = 50;
      priority = 100;
    };

    networking = {
      hostName = "nixos";
      networkmanager = {
        enable = true;
        wifi = {
          powersave = false;
          scanRandMacAddress = false;
        };
      };
    };

    services = {
      udev.extraRules = ''
        ACTION=="add|change", KERNEL=="event*", ATTRS{idVendor}=="3151", ATTRS{idProduct}=="5007", ENV{LIBINPUT_ACCEL_PROFILE}="flat"
      '';
      acpid.enable = true;
      upower.enable = true;
      blueman.enable = true;
      speechd.enable = false;
    };

    programs.nh = {
      enable = true;
      flake = "/home/${vars.username}/.config/nixos";
      clean = {
        enable = true;
        extraArgs = "--keep-since 4d --keep 3";
      };
    };

    nix = {
      optimise = {
        automatic = true;
        dates = "daily";
      };
      settings = {
        experimental-features = ["nix-command" "flakes"];
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
    system.stateVersion = "26.05";
  };
}
