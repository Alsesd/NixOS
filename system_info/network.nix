{
  config,
  pkgs,
  ...
}: {
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

  services.openssh = {
    enable = true;
  };

  services.tailscale.enable = true;
}
