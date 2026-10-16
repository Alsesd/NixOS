{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.myMachineConfiguration = {
    pkgs,
    ...
  }: {
    _module.args = {
      inherit inputs self;
    };

    imports = with self.nixosModules; [
      # modules/
      user

      # modules/hosts/my-machine/
      myMachineHardware

      # modules/features/
      vars

      # modules/features/system/
      boot
      nix
      nh

      # modules/features/hardware/
      cpu
      nvidia
      my-ajclock
      my-ajcontrol

      # modules/features/GUI/
      niri
      noctalia
      noctalia-greeter
      stylix

      # modules/features/services/
      audio
      mosh
      system-tweaks
      tailscale
      wallpaper

      # modules/features/shells/
      fastfetch
      starship
      zsh

      # modules/features/soft/
      blip
      kitty
      steam
      thunar
      zed

      # inputs
      inputs.stylix.nixosModules.stylix
      inputs.home-manager.nixosModules.home-manager
      inputs.noctalia-greeter.nixosModules.default
    ];

    nixpkgs.config.allowUnfree = true;

    virtualisation.docker.enable = true;

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

    system.stateVersion = "26.05";
  };
}
