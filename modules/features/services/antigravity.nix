{ inputs, ... }: {
  flake.nixosModules.antigravity = {
    pkgs,
    lib,
    vars ? { username = "alsesd"; },
    ...
  }: let
    certDir = "/var/lib/tailscale-certs";
    certFile = "${certDir}/cert.crt";
    keyFile = "${certDir}/cert.key";
    domain = "nixos.tail42f05a.ts.net";
  in {
    imports = [
      inputs.antigravity.nixosModules.default
    ];

    # Declarative directory provisioning for Tailscale certs with nginx read access
    systemd.tmpfiles.rules = [
      "d /var/lib/tailscale-certs 0770 alsesd nginx -"
    ];

    # Dashboard service running strictly on 127.0.0.1:8765
    services.antigravity-dashboard = {
      enable = true;
      host = "127.0.0.1";
      port = 8765;
      user = vars.username;
      openFirewall = false;
    };

    # Systemd service for Tailscale TLS certificate automated provisioning and renewal
    systemd.services.tailscale-cert-provision = {
      description = "Automated Tailscale TLS certificate provisioning and renewal";
      after = [ "network-online.target" "tailscaled.service" ];
      wants = [ "network-online.target" "tailscaled.service" ];
      before = [ "nginx.service" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      };

      script = ''
        mkdir -p ${certDir}
        chmod 770 ${certDir}
        chown alsesd:nginx ${certDir} || true

        # Ensure a valid certificate exists so Nginx syntax checks and service start cleanly
        if [ ! -f "${certFile}" ] || [ ! -f "${keyFile}" ]; then
          ${pkgs.openssl}/bin/openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
            -keyout "${keyFile}" -out "${certFile}" \
            -subj "/CN=${domain}" 2>/dev/null || true
          chmod 660 ${certFile} ${keyFile} || true
          chown alsesd:nginx ${certFile} ${keyFile} || true
        fi

        # Provision/renew official Tailscale TLS certificate
        if ${pkgs.tailscale}/bin/tailscale cert --cert-file "${certFile}" --key-file "${keyFile}" "${domain}"; then
          chmod 660 ${certFile} ${keyFile}
          chown alsesd:nginx ${certFile} ${keyFile}
          if ${pkgs.systemd}/bin/systemctl is-active --quiet nginx; then
            ${pkgs.systemd}/bin/systemctl reload nginx || true
          fi
        else
          echo "Notice: tailscale cert could not be fetched from control plane yet. Active cert in ${certDir} is preserved."
        fi
      '';
    };

    systemd.timers.tailscale-cert-provision = {
      description = "Daily renewal timer for Tailscale TLS certificate";
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnCalendar = "daily";
        Persistent = true;
        RandomizedDelaySec = "1h";
      };
    };

    # Declarative Nginx reverse proxy
    services.nginx = {
      enable = true;
      recommendedProxySettings = false;

      virtualHosts."${domain}" = {
        forceSSL = true;
        sslCertificate = certFile;
        sslCertificateKey = keyFile;

        locations."/agydash" = {
          proxyPass = "http://127.0.0.1:8765";
          proxyWebsockets = true;
          extraConfig = ''
            proxy_set_header Upgrade $http_upgrade;
            proxy_set_header Connection "upgrade";
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_read_timeout 86400s;
            proxy_send_timeout 86400s;
          '';
        };

        locations."/" = {
          return = "302 /agydash";
        };
      };
    };

    networking.firewall.allowedTCPPorts = [ 80 443 ];
  };
}
