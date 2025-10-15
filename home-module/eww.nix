{pkgs, ...}: {
  imports = [
    ./eww-widgets/tray/tray.nix
    ./eww-widgets/tray/toggle-tray-script.nix
  ];
  # Add eww to your packages
  home.packages = with pkgs; [
    eww
    jq
  ];

  xdg.configFile."eww/eww.yuck".text = ''
    ;; Include the tray module at the beginning
    (include "./tray.yuck")

    ;; Variables
    (defvar tray-visible false)
  '';
  xdg.configFile."eww/eww.scss".text = ''
    * {
      all: unset;
      font-family: "CaskaydiaCove Nerd Font";
    }

    .tray-container {
      background-color: rgba(50, 56, 68, 0.4);
      border-radius: 10px;
      padding: 8px 12px;
      margin: 0;
      border: 1px solid rgba(129, 161, 193, 0.2);
      box-shadow: 0 2px 8px rgba(0, 0, 0, 0.3);
    }

    .tray-systray {
      background-color: transparent;
    }

    .tray-systray > button {
      all: unset;
      padding: 4px;
      margin: 0 2px;
      border-radius: 5px;
      background-color: transparent;
    }

    .tray-systray > button:hover {
      background-color: rgba(70, 75, 90, 0.6);
    }

    /* Fix for tray menu styling */
    menu {
      background-color: rgba(50, 56, 68, 0.95);
      border: 1px solid rgba(129, 161, 193, 0.3);
      border-radius: 8px;
      padding: 4px;
    }

    menuitem {
      background-color: transparent;
      color: #dcdfe1;
      padding: 6px 12px;
      border-radius: 4px;
    }

    menuitem:hover {
      background-color: rgba(70, 75, 90, 0.9);
    }
  '';

  # Auto-start Eww daemon
  systemd.user.services.eww = {
    Unit = {
      Description = "Eww Daemon";
      PartOf = ["graphical-session.target"];
    };
    Service = {
      ExecStart = "${pkgs.eww}/bin/eww daemon --no-daemonize";
      Restart = "on-failure";
    };
    Install.WantedBy = ["graphical-session.target"];
  };
}
