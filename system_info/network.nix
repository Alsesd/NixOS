{
  config,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    networkmanager
    wayvnc
  ];

  networking = {
    hostName = "nixos";
    networkmanager = {
      enable = true;
      wifi.powersave = false;
    };
    firewall = {
      enable = true;
      trustedInterfaces = ["tailscale0"];
    };
  };

  services.openssh = {
    enable = true;
  };
  programs.mosh.enable = true;
  networking.firewall.allowedUDPPortRanges = [
    {
      from = 60000;
      to = 61000;
    }
  ];

  networking.firewall.allowedTCPPorts = [5900];

  services.tailscale = {
    enable = true;
    useRoutingFeatures = "both";
  };
}
