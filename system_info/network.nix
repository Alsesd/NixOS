  { config, pkgs, ... }: {

  system.packages = with pkgs: [
    networkmanager
  ];

  networking = {
    hostname = "myNixos"; 
    networkmanager = {
      enable = true;
      wifi.powersave = false;
    };
  };
  services.tailscale.enable = true;
  }