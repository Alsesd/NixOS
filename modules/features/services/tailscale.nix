{
  flake.nixosModules.tailscale = {
    pkgs,
    vars ? { username = "alsesd"; },
    ...
  }: {
    environment.systemPackages = [
      pkgs.tailscale
      pkgs.jq
    ];

    services.tailscale = {
      enable = true;
      openFirewall = true;
      useRoutingFeatures = "client";
      permitCertUid = vars.username;
      extraSetFlags = [
        "--operator=${vars.username}"
        "--ssh"
      ];
    };

    # Automatically ensure Tailscale launches and connects on system start
    systemd.services.tailscale-autoconnect = {
      description = "Automatic connection to Tailscale on boot";
      after = [ "network-online.target" "tailscaled.service" ];
      wants = [ "network-online.target" "tailscaled.service" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      };

      script = ''
        sleep 2
        # Check current Tailscale backend state
        status=$(${pkgs.tailscale}/bin/tailscale status --json 2>/dev/null | ${pkgs.jq}/bin/jq -r .BackendState 2>/dev/null || echo "")
        if [ "$status" = "Running" ]; then
          echo "Tailscale is already connected and running."
          exit 0
        fi

        echo "Ensuring Tailscale connects..."
        ${pkgs.tailscale}/bin/tailscale up --operator=${vars.username} --ssh --reset=false || true
      '';
    };
  };
}
