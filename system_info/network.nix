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
    firewall = {
      enable = true;
      trustedInterfaces = [ "tailscale0" ];
    };
  };

  services.openssh = {
    enable = true;
  };

  services.tailscale = {
  enable = true;
  useRoutingFeatures = "both";
};
}
