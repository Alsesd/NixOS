{pkgs, ...}: {
  home.packages = with pkgs; [
    kanshi
  ];
  xdg.configFile."kanshi/config".text = ''

          profile base {
        	  output HDMI-A-4 {
            enable
            mode 1920x1080@144
            position 1920,0
            scale 1.0
          }
          output eDP-1 {
            enable
            mode 1920x1080@60
            position 0,0
            scale 1.0
          }
          exec "exec niri msg output HDMI-A-4 on"
    }

    profile laptop {
        	  output eDP-1 {
            enable
            mode 1920x1080@60
            position 0,0
            scale 1.0
          }
    }
  '';
  systemd.user.services.kanshi = {
    description = "Turn on HDMI-A-4";
    wantedBy = ["display-manager.service"];
    partOf = ["systemd-bootctl.socket"];
    #after = ["systemd-user-sessions.service "];
    serviceConfig = {
      Type = "exec";
      ExecStart = "kanshi --load-profile base";
    };
  };
}
