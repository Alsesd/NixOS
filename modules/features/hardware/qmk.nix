{
  flake.nixosModules.qmk = {pkgs, ...}: {
    hardware.keyboard.qmk.enable = true;

    environment.systemPackages = with pkgs; [
      qmk
      qmk_hid
    ];

    services.udev.packages = [
      pkgs.qmk-udev-rules
    ];
  };
}
