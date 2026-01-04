  { config, pkgs, ... }: {

environment.systemPackages = with pkgs; [
    networkmanager
  ];


  networking = {
    hostName = "nixos";
    networkmanager = {
      enable = true;
      wifi.powersave = false;
    };
  };
  
  services.tailscale.enable = true;
  }