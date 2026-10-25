{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.myMachineConfiguration = {pkgs, ...}: {
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

      # modules/features/GUI/
      gtk
      niri
      noctalia
      noctalia-greeter
      stylix

      # modules/features/services/
      audio
      docker
      mosh
      system-tweaks
      tailscale
      wallpaper

      # modules/features/shells/
      fastfetch
      fish

      # modules/features/soft/
      blip
      creamlinux
      kitty
      steam
      thunar
      yazi
      zed

      # inputs
      inputs.stylix.nixosModules.stylix
      inputs.home-manager.nixosModules.home-manager
      inputs.noctalia-greeter.nixosModules.default
    ];

    nixpkgs.config.allowUnfree = true;

    services = {
      udev.extraRules = ''
        ACTION=="add|change", KERNEL=="event*", ATTRS{idVendor}=="3151", ATTRS{idProduct}=="5007", ENV{LIBINPUT_ACCEL_PROFILE}="flat"
      '';
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
  };
}
